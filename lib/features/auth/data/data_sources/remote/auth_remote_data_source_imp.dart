import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invoify/core/errors/exceptions.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/network/api_helper.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/auth/data/models/user_model.dart';
import '../../../domain/entities/user_entity.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  AuthRemoteDataSourceImp({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  static const String _usersCollection = 'users';

  @override
  Future<NetworkResponse<UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async => ApiHelper.executeSafely(() async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw BusinessException(AppStrings.unexpectedError);
      }

      await user.updateDisplayName(username);

      final userModel = UserModel(
        uid: user.uid,
        businessName: username,
        email: email,
        currency: 'USD',
        createdAt: DateTime.now(),
        isVerified: user.emailVerified,
      );

      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .set(userModel.toJson());

      await user.sendEmailVerification();
      await _firebaseAuth.signOut();

      return userModel.toUserEntity();
    } on FirebaseAuthException catch (e) {
      if (e.code != 'email-already-in-use') {
        await _firebaseAuth.currentUser?.delete();
      }
      rethrow;
    } catch (_) {
      await _firebaseAuth.currentUser?.delete();
      rethrow;
    }
  }, functionName: 'createUserWithEmailAndPassword');

  @override
  Future<NetworkResponse<UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async => ApiHelper.executeSafely(() async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user == null) {
      throw BusinessException(AppStrings.userNotFound);
    }

    await user.reload();
    final updatedUser = _firebaseAuth.currentUser ?? user;

    if (!updatedUser.emailVerified) {
      await _firebaseAuth.signOut();
      throw BusinessException(AppStrings.pleaseVerifyYourEmail);
    }

    final userEntity = UserModel.fromFirebaseUser(updatedUser).toUserEntity();
    return await _getOrUpdateUserFromDB(userEntity);
  }, functionName: 'signInWithEmailAndPassword');

  @override
  Future<NetworkResponse<UserEntity>> googleSignIn() async =>
      ApiHelper.executeSafely(() async {
        final googleProvider = GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithProvider(
          googleProvider,
        );

        final user = userCredential.user;
        if (user == null) {
          throw BusinessException(AppStrings.unexpectedError);
        }

        final userEntity = UserModel.fromFirebaseUser(user).toUserEntity();
        return await _getOrUpdateUserFromDB(userEntity);
      }, functionName: 'googleSignIn');

  @override
  Future<NetworkResponse<void>> forgetPassword(String email) async =>
      ApiHelper.executeSafely(() async {
        final exists = await _checkIfEmailExists(email);
        if (!exists) {
          throw Exception('user-not-found');
        }
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      }, functionName: 'forgetPassword');

  @override
  Future<NetworkResponse<void>> signOut() async =>
      ApiHelper.executeSafely(() async {
        await _firebaseAuth.signOut();
      }, functionName: 'signOut');

  // -------------------------------------------------------------------
  // Private Helper Methods
  // -------------------------------------------------------------------

  Future<UserEntity> _getOrUpdateUserFromDB(UserEntity user) async {
    final docSnapshot = await _firestore
        .collection(_usersCollection)
        .doc(user.uid)
        .get();

    if (docSnapshot.exists && docSnapshot.data() != null) {
      final storedUserData = docSnapshot.data()!;
      await _firestore.collection(_usersCollection).doc(user.uid).update({
        'isVerified': user.isVerified,
      });
      return UserModel.fromJson(storedUserData).toUserEntity();
    } else {
      final userModel = UserModel.fromUserEntity(user);
      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .set(userModel.toJson());
      return userModel.toUserEntity();
    }
  }

  Future<bool> _checkIfEmailExists(String email) async {
    final query = await _firestore
        .collection(_usersCollection)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    return query.docs.isNotEmpty;
  }
}
