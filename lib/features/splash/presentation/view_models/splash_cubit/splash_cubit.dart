import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/services/app_preferences/app_preferences_service.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._appPreferencesService) : super(const SplashInitial());

  final AppPreferencesService _appPreferencesService;

  Future<void> checkAppStatus() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    final isFirstTime = _appPreferencesService.isFirstTime();

    if (isFirstTime) {
      emit(const SplashSuccess(SplashProcess.navigateToOnboarding));
      return;
    }

    bool isUserLoggedIn = false;

    try {
      if (Firebase.apps.isNotEmpty) {
        isUserLoggedIn = FirebaseAuth.instance.currentUser != null;
      }
    } catch (_) {
      isUserLoggedIn = false;
    }

    if (isUserLoggedIn) {
      emit(const SplashSuccess(SplashProcess.navigateToHome));
    } else {
      emit(const SplashSuccess(SplashProcess.navigateToLogin));
    }
  }
}

