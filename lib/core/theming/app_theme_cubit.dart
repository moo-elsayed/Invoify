import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/app_preferences/app_preferences_service.dart';

class AppThemeCubit extends Cubit<ThemeMode> {
  AppThemeCubit(this._appPreferencesService) : super(.system) {
    _loadSavedTheme();
  }

  final AppPreferencesService _appPreferencesService;

  void _loadSavedTheme() {
    final savedTheme = _appPreferencesService.getThemeMode();
    switch (savedTheme) {
      case 'light':
        emit(.light);
      case 'dark':
        emit(.dark);
      case 'system':
      default:
        emit(.system);
    }
  }

  Future<void> changeTheme(ThemeMode themeMode) async {
    emit(themeMode);
    String themeString = 'system';
    if (themeMode == .light) themeString = 'light';
    if (themeMode == .dark) themeString = 'dark';
    await _appPreferencesService.saveThemeMode(themeString);
  }
}
