import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoify/core/network/network_response.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/google_sign_in_use_case.dart';

part 'social_sign_in_state.dart';

class SocialSignInCubit extends Cubit<SocialSignInState> {
  SocialSignInCubit(this._googleSignInUseCase) : super(SocialSignInInitial());

  final GoogleSignInUseCase _googleSignInUseCase;

  Future<void> googleSignIn() async {
    emit(GoogleLoading());
    final result = await _googleSignInUseCase();
    switch (result) {
      case NetworkSuccess<UserEntity>():
        emit(GoogleSuccess());
      case NetworkFailure<UserEntity>():
        emit(GoogleFailure(result.error));
    }
  }
}
