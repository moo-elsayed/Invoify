import 'package:get_it/get_it.dart';
import 'package:invoify/core/services/app_preferences/app_preferences_service.dart';
import 'package:invoify/core/services/app_preferences/app_preferences_service_imp.dart';
import 'package:invoify/core/services/notification/notification_service.dart';
import 'package:invoify/core/theming/app_theme_cubit.dart';
import 'package:invoify/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:invoify/features/auth/data/data_sources/remote/auth_remote_data_source_imp.dart';
import 'package:invoify/features/auth/data/repo_imp/auth_repo_imp.dart';
import 'package:invoify/features/auth/domain/repo/auth_repo.dart';
import 'package:invoify/features/auth/domain/use_cases/create_user_with_email_and_password_use_case.dart';
import 'package:invoify/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:invoify/features/auth/domain/use_cases/get_user_info_use_case.dart';
import 'package:invoify/features/auth/domain/use_cases/google_sign_in_use_case.dart';
import 'package:invoify/features/auth/domain/use_cases/sign_in_with_email_and_password_use_case.dart';
import 'package:invoify/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:invoify/features/auth/presentation/view_models/forget_password_cubit/forget_password_cubit.dart';
import 'package:invoify/features/auth/presentation/view_models/signin_cubit/sign_in_cubit.dart';
import 'package:invoify/features/auth/presentation/view_models/signout_cubit/sign_out_cubit.dart';
import 'package:invoify/features/auth/presentation/view_models/signup_cubit/sign_up_cubit.dart';
import 'package:invoify/features/auth/presentation/view_models/social_sign_in_cubit/social_sign_in_cubit.dart';
import 'package:invoify/features/auth/presentation/view_models/user_info_cubit/user_info_cubit.dart';
import 'package:invoify/features/clients/data/data_sources/remote/clients_remote_data_source.dart';
import 'package:invoify/features/clients/data/data_sources/remote/clients_remote_data_source_imp.dart';
import 'package:invoify/features/clients/data/repo_imp/clients_repo_imp.dart';
import 'package:invoify/features/clients/domain/repo/clients_repo.dart';
import 'package:invoify/features/clients/domain/use_cases/add_client_use_case.dart';
import 'package:invoify/features/clients/domain/use_cases/delete_client_use_case.dart';
import 'package:invoify/features/clients/domain/use_cases/get_clients_use_case.dart';
import 'package:invoify/features/clients/domain/use_cases/update_client_use_case.dart';
import 'package:invoify/features/clients/presentation/view_models/clients_cubit/clients_cubit.dart';
import 'package:invoify/features/dashboard/presentation/view_models/dashboard_cubit/dashboard_cubit.dart';
import 'package:invoify/features/invoices/data/data_sources/remote/invoices_remote_data_source.dart';
import 'package:invoify/features/invoices/data/data_sources/remote/invoices_remote_data_source_imp.dart';
import 'package:invoify/features/invoices/data/repo_imp/invoices_repo_imp.dart';
import 'package:invoify/features/invoices/domain/repo/invoices_repo.dart';
import 'package:invoify/features/invoices/domain/use_cases/create_invoice_use_case.dart';
import 'package:invoify/features/invoices/domain/use_cases/delete_invoice_use_case.dart';
import 'package:invoify/features/invoices/domain/use_cases/get_invoices_use_case.dart';
import 'package:invoify/features/invoices/domain/use_cases/update_invoice_use_case.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';
import 'package:invoify/features/onboarding/presentation/view_models/onboarding_cubit/onboarding_cubit.dart';
import 'package:invoify/features/settings/data/data_sources/remote/settings_remote_data_source.dart';
import 'package:invoify/features/settings/data/data_sources/remote/settings_remote_data_source_imp.dart';
import 'package:invoify/features/settings/data/repo_imp/settings_repo_imp.dart';
import 'package:invoify/features/settings/domain/repo/settings_repo.dart';
import 'package:invoify/features/settings/domain/use_cases/update_business_name_use_case.dart';
import 'package:invoify/features/settings/domain/use_cases/update_currency_use_case.dart';
import 'package:invoify/features/splash/presentation/view_models/splash_cubit/splash_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Core Services
  getIt.registerLazySingleton<AppPreferencesService>(
    () => AppPreferencesServiceImpl(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(),
  );

  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImp(),
  );
  getIt.registerLazySingleton<ClientsRemoteDataSource>(
    () => ClientsRemoteDataSourceImp(),
  );
  getIt.registerLazySingleton<InvoicesRemoteDataSource>(
    () => InvoicesRemoteDataSourceImp(),
  );
  getIt.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImp(),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImp(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton<ClientsRepo>(
    () => ClientsRepoImp(getIt<ClientsRemoteDataSource>()),
  );
  getIt.registerLazySingleton<InvoicesRepo>(
    () => InvoicesRepoImp(getIt<InvoicesRemoteDataSource>()),
  );
  getIt.registerLazySingleton<SettingsRepo>(
    () => SettingsRepoImp(getIt<SettingsRemoteDataSource>()),
  );

  // Use Cases - Auth
  getIt.registerLazySingleton<SignInWithEmailAndPasswordUseCase>(
    () => SignInWithEmailAndPasswordUseCase(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<CreateUserWithEmailAndPasswordUseCase>(
    () => CreateUserWithEmailAndPasswordUseCase(getIt<AuthRepo>()),
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
  getIt.registerLazySingleton<GetUserInfoUseCase>(
    () => GetUserInfoUseCase(getIt<AuthRepo>()),
  );

  // Use Cases - Settings
  getIt.registerLazySingleton<UpdateCurrencyUseCase>(
    () => UpdateCurrencyUseCase(getIt<SettingsRepo>()),
  );
  getIt.registerLazySingleton<UpdateBusinessNameUseCase>(
    () => UpdateBusinessNameUseCase(getIt<SettingsRepo>()),
  );

  // Use Cases - Clients
  getIt.registerLazySingleton<GetClientsUseCase>(
    () => GetClientsUseCase(getIt<ClientsRepo>()),
  );
  getIt.registerLazySingleton<AddClientUseCase>(
    () => AddClientUseCase(getIt<ClientsRepo>()),
  );
  getIt.registerLazySingleton<UpdateClientUseCase>(
    () => UpdateClientUseCase(getIt<ClientsRepo>()),
  );
  getIt.registerLazySingleton<DeleteClientUseCase>(
    () => DeleteClientUseCase(getIt<ClientsRepo>()),
  );

  // Use Cases - Invoices
  getIt.registerLazySingleton<GetInvoicesUseCase>(
    () => GetInvoicesUseCase(getIt<InvoicesRepo>()),
  );
  getIt.registerLazySingleton<CreateInvoiceUseCase>(
    () => CreateInvoiceUseCase(getIt<InvoicesRepo>()),
  );
  getIt.registerLazySingleton<UpdateInvoiceUseCase>(
    () => UpdateInvoiceUseCase(getIt<InvoicesRepo>()),
  );
  getIt.registerLazySingleton<DeleteInvoiceUseCase>(
    () => DeleteInvoiceUseCase(getIt<InvoicesRepo>()),
  );

  // Cubits / ViewModels
  getIt.registerFactory<UserInfoCubit>(
    () => UserInfoCubit(
      getIt<AppPreferencesService>(),
      getIt<GetUserInfoUseCase>(),
      getIt<UpdateCurrencyUseCase>(),
      getIt<UpdateBusinessNameUseCase>(),
    ),
  );

  getIt.registerFactory<ClientsCubit>(
    () => ClientsCubit(
      getIt<GetClientsUseCase>(),
      getIt<AddClientUseCase>(),
      getIt<UpdateClientUseCase>(),
      getIt<DeleteClientUseCase>(),
    ),
  );

  getIt.registerFactory<InvoicesCubit>(
    () => InvoicesCubit(
      getIt<GetInvoicesUseCase>(),
      getIt<CreateInvoiceUseCase>(),
      getIt<UpdateInvoiceUseCase>(),
      getIt<DeleteInvoiceUseCase>(),
    ),
  );

  getIt.registerFactory<DashboardCubit>(
    () => DashboardCubit(
      getIt<GetInvoicesUseCase>(),
      getIt<GetClientsUseCase>(),
    ),
  );

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
