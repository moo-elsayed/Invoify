import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/services/app_preferences/app_preferences_service.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._appPreferencesService, {FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      super(const SplashInitial());

  final AppPreferencesService _appPreferencesService;
  final FirebaseAuth _firebaseAuth;

  Future<void> checkAppStatus() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    final isFirstTime = _appPreferencesService.isFirstTime();

    if (isFirstTime) {
      emit(const SplashSuccess(SplashProcess.navigateToOnboarding));
      return;
    }

    final isUserLoggedIn = _firebaseAuth.currentUser != null;

    if (isUserLoggedIn) {
      emit(const SplashSuccess(SplashProcess.navigateToHome));
    } else {
      emit(const SplashSuccess(SplashProcess.navigateToLogin));
    }
  }
}
