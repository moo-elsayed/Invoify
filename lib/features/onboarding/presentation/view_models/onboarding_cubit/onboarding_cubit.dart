import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/services/app_preferences/app_preferences_service.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._appPreferencesService) : super(OnboardingInitial());
  final AppPreferencesService _appPreferencesService;

  Future<void> setFirstTime() async {
    await _appPreferencesService.saveFirstTime();
    emit(OnboardingNavigateToLogin());
  }
}
