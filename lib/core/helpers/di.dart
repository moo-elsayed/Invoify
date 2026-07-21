import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/onboarding/presentation/view_models/onboarding_cubit/onboarding_cubit.dart';
import '../../features/splash/presentation/view_models/splash_cubit/splash_cubit.dart';
import '../services/app_preferences/app_preferences_service.dart';
import '../services/app_preferences/app_preferences_service_imp.dart';
import '../theming/app_theme_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // ==========================================
  // 1. External Dependencies
  // ==========================================
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // ==========================================
  // 2. Core Services & Repositories
  // ==========================================
  getIt.registerLazySingleton<AppPreferencesService>(
    () => AppPreferencesServiceImpl(getIt<SharedPreferences>()),
  );

  // ==========================================
  // 3. Cubits / ViewModels
  // ==========================================
  getIt.registerFactory<AppThemeCubit>(
    () => AppThemeCubit(getIt<AppPreferencesService>()),
  );

  getIt.registerFactory<SplashCubit>(
    () => SplashCubit(getIt<AppPreferencesService>()),
  );

  getIt.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(getIt<AppPreferencesService>()),
  );
}
