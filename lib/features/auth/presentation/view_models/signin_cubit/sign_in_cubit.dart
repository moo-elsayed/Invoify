import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoify/core/network/network_response.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/sign_in_with_email_and_password_use_case.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._signInWithEmailAndPasswordUseCase) : super(SignInInitial());

  final SignInWithEmailAndPasswordUseCase _signInWithEmailAndPasswordUseCase;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(SignInLoading());
    final result = await _signInWithEmailAndPasswordUseCase(
      email: email,
      password: password,
    );
    switch (result) {
      case NetworkSuccess<UserEntity>():
        emit(SignInSuccess());
      case NetworkFailure<UserEntity>():
        emit(SignInFailure(result.error));
    }
  }
}
