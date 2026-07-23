import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<NetworkResponse<UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<NetworkResponse<UserModel>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  });

  Future<NetworkResponse<UserModel>> googleSignIn();

  Future<NetworkResponse<UserModel>> getUserInfo(String uid);

  Future<NetworkResponse<void>> forgetPassword(String email);

  Future<NetworkResponse<void>> signOut();
}
