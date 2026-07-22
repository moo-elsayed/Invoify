import 'package:get_it/get_it.dart';
import 'package:invoify/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:invoify/features/auth/data/data_sources/remote/auth_remote_data_source_imp.dart';
import 'package:invoify/features/auth/data/repo_imp/auth_repo_imp.dart';
import 'package:invoify/features/auth/domain/repo/auth_repo.dart';
import 'package:invoify/features/auth/domain/use_cases/create_user_with_email_and_password_use_case.dart';
import 'package:invoify/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:invoify/features/auth/domain/use_cases/google_sign_in_use_case.dart';
import 'package:invoify/features/auth/domain/use_cases/sign_in_with_email_and_password_use_case.dart';
import 'package:invoify/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:invoify/features/auth/presentation/view_models/forget_password_cubit/forget_password_cubit.dart';
import 'package:invoify/features/auth/presentation/view_models/signin_cubit/sign_in_cubit.dart';
import 'package:invoify/features/auth/presentation/view_models/signout_cubit/sign_out_cubit.dart';
import 'package:invoify/features/auth/presentation/view_models/signup_cubit/sign_up_cubit.dart';
import 'package:invoify/features/auth/presentation/view_models/social_sign_in_cubit/social_sign_in_cubit.dart';
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

  // Auth Data Source & Repo
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImp(),
  );
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImp(getIt<AuthRemoteDataSource>()),
  );

  // Auth Use Cases
  getIt.registerLazySingleton<CreateUserWithEmailAndPasswordUseCase>(
    () => CreateUserWithEmailAndPasswordUseCase(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<SignInWithEmailAndPasswordUseCase>(
    () => SignInWithEmailAndPasswordUseCase(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<GoogleSignInUseCase>(
    () => GoogleSignInUseCase(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<ForgetPasswordUseCase>(
    () => ForgetPasswordUseCase(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(getIt<AuthRepo>()),
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

  // Auth Cubits
  getIt.registerFactory<SignInCubit>(
    () => SignInCubit(getIt<SignInWithEmailAndPasswordUseCase>()),
  );
  getIt.registerFactory<SignupCubit>(
    () => SignupCubit(getIt<CreateUserWithEmailAndPasswordUseCase>()),
  );
  getIt.registerFactory<SocialSignInCubit>(
    () => SocialSignInCubit(getIt<GoogleSignInUseCase>()),
  );
  getIt.registerFactory<ForgetPasswordCubit>(
    () => ForgetPasswordCubit(getIt<ForgetPasswordUseCase>()),
  );
  getIt.registerFactory<SignOutCubit>(
    () => SignOutCubit(getIt<SignOutUseCase>()),
  );
}
