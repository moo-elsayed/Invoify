import 'package:invoify/core/network/network_response.dart';
import '../../../domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<NetworkResponse<UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<NetworkResponse<UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  });

  Future<NetworkResponse<UserEntity>> googleSignIn();

  Future<NetworkResponse<void>> forgetPassword(String email);

  Future<NetworkResponse<void>> signOut();
}
