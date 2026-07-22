import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoify/core/network/network_response.dart';
import '../../../domain/use_cases/sign_out_use_case.dart';

part 'sign_out_state.dart';

class SignOutCubit extends Cubit<SignOutState> {
  SignOutCubit(this._signOutUseCase) : super(SignOutInitial());

  final SignOutUseCase _signOutUseCase;

  Future<void> signOut() async {
    emit(SignOutLoading());
    final result = await _signOutUseCase();
    switch (result) {
      case NetworkSuccess<void>():
        emit(SignOutSuccess());
      case NetworkFailure<void>():
        emit(SignOutFailure(result.error));
    }
  }
}
