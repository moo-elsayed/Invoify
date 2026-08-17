import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/di.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/core/routing/app_router.dart';
import 'package:invoify/core/services/app_preferences/app_preferences_service.dart';
import 'package:invoify/core/services/notification/notification_service.dart';
import 'package:invoify/core/theming/app_theme_cubit.dart';
import 'package:invoify/core/widgets/app_toasts.dart';
import 'package:invoify/core/widgets/custom_material_button.dart';
import 'package:invoify/core/widgets/custom_success_dialog.dart';
import 'package:invoify/core/widgets/main_screen_header.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';
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
import 'package:invoify/features/auth/presentation/views/forget_password_view.dart';
import 'package:invoify/features/auth/presentation/views/login_view.dart';
import 'package:invoify/features/auth/presentation/views/register_view.dart';
import 'package:invoify/features/auth/presentation/widgets/auth_redirect_text.dart';
import 'package:invoify/features/auth/presentation/widgets/forget_password.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/domain/use_cases/add_client_use_case.dart';
import 'package:invoify/features/clients/domain/use_cases/delete_client_use_case.dart';
import 'package:invoify/features/clients/domain/use_cases/get_clients_use_case.dart';
import 'package:invoify/features/clients/domain/use_cases/update_client_use_case.dart';
import 'package:invoify/features/clients/presentation/view_models/clients_cubit/clients_cubit.dart';
import 'package:invoify/features/clients/presentation/views/add_edit_client_view.dart';
import 'package:invoify/features/clients/presentation/views/clients_view.dart';
import 'package:invoify/features/clients/presentation/widgets/client_card.dart';
import 'package:invoify/features/clients/presentation/widgets/client_form_submit_button.dart';
import 'package:invoify/features/dashboard/presentation/view_models/dashboard_cubit/dashboard_cubit.dart';
import 'package:invoify/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_item_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:invoify/features/invoices/domain/use_cases/create_invoice_use_case.dart';
import 'package:invoify/features/invoices/domain/use_cases/delete_invoice_use_case.dart';
import 'package:invoify/features/invoices/domain/use_cases/get_invoices_stream_use_case.dart';
import 'package:invoify/features/invoices/domain/use_cases/get_invoices_use_case.dart';
import 'package:invoify/features/invoices/domain/use_cases/update_invoice_use_case.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';
import 'package:invoify/features/invoices/presentation/views/add_edit_invoice_view.dart';
import 'package:invoify/features/invoices/presentation/views/invoices_view.dart';
import 'package:invoify/features/invoices/presentation/widgets/add_edit_invoice_save_button.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_card.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_client_picker.dart';
import 'package:invoify/features/onboarding/presentation/view_models/onboarding_cubit/onboarding_cubit.dart';
import 'package:invoify/features/settings/domain/use_cases/update_business_name_use_case.dart';
import 'package:invoify/features/settings/domain/use_cases/update_currency_use_case.dart';
import 'package:invoify/features/settings/presentation/views/settings_view.dart';
import 'package:invoify/features/splash/presentation/view_models/splash_cubit/splash_cubit.dart';
import 'package:invoify/invoify.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mocks for Dependency Injection
class MockAppPreferencesService extends Mock implements AppPreferencesService {}

class MockNotificationService extends Mock implements NotificationService {}

class MockSignInWithEmailAndPasswordUseCase extends Mock
    implements SignInWithEmailAndPasswordUseCase {}

class MockCreateUserWithEmailAndPasswordUseCase extends Mock
    implements CreateUserWithEmailAndPasswordUseCase {}

class MockGoogleSignInUseCase extends Mock implements GoogleSignInUseCase {}

class MockForgetPasswordUseCase extends Mock implements ForgetPasswordUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

class MockGetUserInfoUseCase extends Mock implements GetUserInfoUseCase {}

class MockGetClientsUseCase extends Mock implements GetClientsUseCase {}

class MockAddClientUseCase extends Mock implements AddClientUseCase {}

class MockUpdateClientUseCase extends Mock implements UpdateClientUseCase {}

class MockDeleteClientUseCase extends Mock implements DeleteClientUseCase {}

class MockGetInvoicesUseCase extends Mock implements GetInvoicesUseCase {}

class MockGetInvoicesStreamUseCase extends Mock
    implements GetInvoicesStreamUseCase {}

class MockCreateInvoiceUseCase extends Mock implements CreateInvoiceUseCase {}

class MockUpdateInvoiceUseCase extends Mock implements UpdateInvoiceUseCase {}

class MockDeleteInvoiceUseCase extends Mock implements DeleteInvoiceUseCase {}

class MockUpdateBusinessNameUseCase extends Mock
    implements UpdateBusinessNameUseCase {}

class MockUpdateCurrencyUseCase extends Mock implements UpdateCurrencyUseCase {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class FakeClientEntity extends Fake implements ClientEntity {}

class FakeInvoiceEntity extends Fake implements InvoiceEntity {}

const testClient = ClientEntity(
  clientId: 'client_1',
  name: 'Tech Corp',
  email: 'contact@techcorp.com',
  phone: '+1234567890',
  address: '123 Innovation Way',
);

const newClient = ClientEntity(
  clientId: 'client_2',
  name: 'Acme Corp',
  email: 'contact@acme.com',
  phone: '+1999888777',
  address: '123 Tech Park',
);

Future<void> _pumpApp(WidgetTester tester, {Widget? home}) async {
  await EasyLocalization.ensureInitialized();
  final appRouter = AppRouter();
  final Widget rootWidget = home != null
      ? MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<AppThemeCubit>()),
            BlocProvider(create: (_) => getIt<UserInfoCubit>()),
            BlocProvider(create: (_) => getIt<ClientsCubit>()),
            BlocProvider(create: (_) => getIt<InvoicesCubit>()),
            BlocProvider(create: (_) => getIt<DashboardCubit>()),
          ],
          child: MaterialApp(
            home: home,
            onGenerateRoute: appRouter.generateRoute,
          ),
        )
      : Invoify(appRouter: appRouter);

  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: rootWidget,
    ),
  );
  // Wait for SplashCubit 1500ms delay + animations in real time
  await tester.pump(const Duration(milliseconds: 100));
  await Future.delayed(const Duration(milliseconds: 2000));
  await tester.pumpAndSettle();
}

Future<void> _navigateToTab<T extends Widget>(
  WidgetTester tester,
  IconData icon,
) async {
  final tabFinder = find.byIcon(icon);
  if (tabFinder.evaluate().isNotEmpty) {
    await tester.tap(tabFinder.first);
    await tester.pumpAndSettle();
    expect(find.byType(T), findsOneWidget);
  }
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // benchmarkLive runs at full speed like fullyLive but allows the process
  // to exit cleanly when tests finish — fullyLive keeps pumping frames
  // indefinitely which caused the Firebase Test Lab hang.
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.benchmarkLive;
  binding.testTextInput.register();

  late MockAppPreferencesService mockAppPreferencesService;
  late MockNotificationService mockNotificationService;

  late MockGetUserInfoUseCase mockGetUserInfoUseCase;
  late MockSignInWithEmailAndPasswordUseCase
  mockSignInWithEmailAndPasswordUseCase;
  late MockCreateUserWithEmailAndPasswordUseCase
  mockCreateUserWithEmailAndPasswordUseCase;
  late MockGoogleSignInUseCase mockGoogleSignInUseCase;
  late MockForgetPasswordUseCase mockForgetPasswordUseCase;
  late MockSignOutUseCase mockSignOutUseCase;

  late MockGetClientsUseCase mockGetClientsUseCase;
  late MockAddClientUseCase mockAddClientUseCase;
  late MockUpdateClientUseCase mockUpdateClientUseCase;
  late MockDeleteClientUseCase mockDeleteClientUseCase;

  late MockGetInvoicesUseCase mockGetInvoicesUseCase;
  late MockGetInvoicesStreamUseCase mockGetInvoicesStreamUseCase;
  late MockCreateInvoiceUseCase mockCreateInvoiceUseCase;
  late MockUpdateInvoiceUseCase mockUpdateInvoiceUseCase;
  late MockDeleteInvoiceUseCase mockDeleteInvoiceUseCase;

  late MockUpdateBusinessNameUseCase mockUpdateBusinessNameUseCase;
  late MockUpdateCurrencyUseCase mockUpdateCurrencyUseCase;

  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockFirebaseUser;

  final testUser = UserEntity(
    uid: 'user_123',
    email: 'test@invoify.com',
    businessName: 'Invoify Tech',
    currency: 'USD',
    createdAt: DateTime.now(),
  );

  final testInvoice = InvoiceEntity(
    invoiceId: 'inv_1',
    invoiceNumber: 'INV-001',
    userId: 'user_123',
    client: testClient,
    items: const [
      InvoiceItemEntity(
        itemId: 'item_1',
        name: 'Web Development',
        quantity: 2,
        unitPrice: 500,
      ),
    ],
    taxRate: 14.0,
    totalAmount: 1090.0,
    status: InvoiceStatus.sent,
    dueDate: DateTime.now().add(const Duration(days: 7)),
    createdAt: DateTime.now(),
  );

  final newInvoice = InvoiceEntity(
    invoiceId: 'inv_2',
    invoiceNumber: 'INV-002',
    userId: 'user_123',
    client: newClient,
    items: const [
      InvoiceItemEntity(
        itemId: 'item_2',
        name: 'Web Development Package',
        quantity: 2,
        unitPrice: 500,
      ),
    ],
    taxRate: 14.0,
    totalAmount: 1140.0,
    status: InvoiceStatus.draft,
    dueDate: DateTime.now().add(const Duration(days: 7)),
    createdAt: DateTime.now(),
  );

  setUpAll(() {
    AppToast.isEnabled = false;
    registerFallbackValue(FakeClientEntity());
    registerFallbackValue(FakeInvoiceEntity());
    registerFallbackValue(
      const UserEntity(
        uid: 'fake_uid',
        businessName: 'Fake Business',
        email: 'fake@fake.com',
        currency: 'USD',
        isVerified: false,
      ),
    );
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();

    mockAppPreferencesService = MockAppPreferencesService();
    mockNotificationService = MockNotificationService();

    mockGetUserInfoUseCase = MockGetUserInfoUseCase();
    mockSignInWithEmailAndPasswordUseCase =
        MockSignInWithEmailAndPasswordUseCase();
    mockCreateUserWithEmailAndPasswordUseCase =
        MockCreateUserWithEmailAndPasswordUseCase();
    mockGoogleSignInUseCase = MockGoogleSignInUseCase();
    mockForgetPasswordUseCase = MockForgetPasswordUseCase();
    mockSignOutUseCase = MockSignOutUseCase();

    mockGetClientsUseCase = MockGetClientsUseCase();
    mockAddClientUseCase = MockAddClientUseCase();
    mockUpdateClientUseCase = MockUpdateClientUseCase();
    mockDeleteClientUseCase = MockDeleteClientUseCase();

    mockGetInvoicesUseCase = MockGetInvoicesUseCase();
    mockGetInvoicesStreamUseCase = MockGetInvoicesStreamUseCase();
    mockCreateInvoiceUseCase = MockCreateInvoiceUseCase();
    mockUpdateInvoiceUseCase = MockUpdateInvoiceUseCase();
    mockDeleteInvoiceUseCase = MockDeleteInvoiceUseCase();

    mockUpdateBusinessNameUseCase = MockUpdateBusinessNameUseCase();
    mockUpdateCurrencyUseCase = MockUpdateCurrencyUseCase();

    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseUser = MockUser();

    when(() => mockFirebaseUser.uid).thenReturn('user_123');
    // At start: unauthenticated → SplashCubit routes to LoginView
    when(() => mockFirebaseAuth.currentUser).thenReturn(null);

    when(() => mockAppPreferencesService.isFirstTime()).thenReturn(false);
    when(
      () => mockAppPreferencesService.getUser(),
    ).thenReturn(null); // Unauthenticated at start
    when(() => mockAppPreferencesService.getThemeMode()).thenReturn('light');
    when(() => mockAppPreferencesService.getLanguage()).thenReturn('ar');
    when(
      () => mockAppPreferencesService.saveUser(any()),
    ).thenAnswer((_) async {});
    when(() => mockAppPreferencesService.clearUser()).thenAnswer((_) async {});
    when(() => mockNotificationService.init()).thenAnswer((_) async {});
    when(
      () => mockNotificationService.updateLanguageCode(any()),
    ).thenAnswer((_) async {});

    when(
      () => mockSignInWithEmailAndPasswordUseCase(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {
      // After login: simulate authenticated user
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);
      when(() => mockAppPreferencesService.getUser()).thenReturn(testUser);
      return NetworkSuccess(testUser);
    });

    when(
      () => mockCreateUserWithEmailAndPasswordUseCase(
        username: any(named: 'username'),
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => NetworkSuccess(testUser));

    when(
      () => mockForgetPasswordUseCase(any()),
    ).thenAnswer((_) async => const NetworkSuccess());

    when(
      () => mockGetUserInfoUseCase(any()),
    ).thenAnswer((_) async => NetworkSuccess(testUser));
    when(
      () => mockGetClientsUseCase(any()),
    ).thenAnswer((_) async => NetworkSuccess(List.of([testClient])));
    when(() => mockAddClientUseCase(any())).thenAnswer((_) async {
      when(() => mockGetClientsUseCase(any())).thenAnswer(
        (_) async => NetworkSuccess(List.of([testClient, newClient])),
      );
      return const NetworkSuccess(newClient);
    });
    when(
      () => mockGetInvoicesUseCase(any()),
    ).thenAnswer((_) async => NetworkSuccess(List.of([testInvoice])));
    when(
      () => mockGetInvoicesStreamUseCase(any()),
    ).thenAnswer((_) => Stream.value(List.of([testInvoice])));
    when(() => mockCreateInvoiceUseCase(any())).thenAnswer((_) async {
      when(() => mockGetInvoicesUseCase(any())).thenAnswer(
        (_) async => NetworkSuccess(List.of([testInvoice, newInvoice])),
      );
      when(
        () => mockGetInvoicesStreamUseCase(any()),
      ).thenAnswer((_) => Stream.value(List.of([testInvoice, newInvoice])));
      return NetworkSuccess(newInvoice);
    });

    await getIt.reset();
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);
    getIt.registerSingleton<AppPreferencesService>(mockAppPreferencesService);
    getIt.registerSingleton<NotificationService>(mockNotificationService);

    getIt.registerFactory<AppThemeCubit>(
      () => AppThemeCubit(mockAppPreferencesService),
    );
    getIt.registerFactory<SplashCubit>(
      () => SplashCubit(
        mockAppPreferencesService,
        firebaseAuth: mockFirebaseAuth,
      ),
    );
    getIt.registerFactory<OnboardingCubit>(
      () => OnboardingCubit(mockAppPreferencesService),
    );

    getIt.registerFactory<SignInCubit>(
      () => SignInCubit(mockSignInWithEmailAndPasswordUseCase),
    );
    getIt.registerFactory<SignupCubit>(
      () => SignupCubit(mockCreateUserWithEmailAndPasswordUseCase),
    );
    getIt.registerFactory<SocialSignInCubit>(
      () => SocialSignInCubit(mockGoogleSignInUseCase),
    );
    getIt.registerFactory<ForgetPasswordCubit>(
      () => ForgetPasswordCubit(mockForgetPasswordUseCase),
    );
    getIt.registerFactory<SignOutCubit>(() => SignOutCubit(mockSignOutUseCase));
    getIt.registerLazySingleton<UserInfoCubit>(
      () => UserInfoCubit(
        mockAppPreferencesService,
        mockGetUserInfoUseCase,
        mockUpdateCurrencyUseCase,
        mockUpdateBusinessNameUseCase,
        mockNotificationService,
        firebaseAuth: mockFirebaseAuth,
      ),
    );

    getIt.registerFactory<ClientsCubit>(
      () => ClientsCubit(
        mockGetClientsUseCase,
        mockAddClientUseCase,
        mockUpdateClientUseCase,
        mockDeleteClientUseCase,
        firebaseAuth: mockFirebaseAuth,
      ),
    );
    getIt.registerFactory<InvoicesCubit>(
      () => InvoicesCubit(
        mockGetInvoicesStreamUseCase,
        mockCreateInvoiceUseCase,
        mockUpdateInvoiceUseCase,
        mockDeleteInvoiceUseCase,
        firebaseAuth: mockFirebaseAuth,
      ),
    );
    getIt.registerFactory<DashboardCubit>(
      () => DashboardCubit(
        mockGetInvoicesUseCase,
        mockGetClientsUseCase,
        firebaseAuth: mockFirebaseAuth,
      ),
    );
    getIt.registerFactory<UpdateBusinessNameUseCase>(
      () => mockUpdateBusinessNameUseCase,
    );
    getIt.registerFactory<UpdateCurrencyUseCase>(
      () => mockUpdateCurrencyUseCase,
    );
  });

  group('Invoify Complete Interactive E2E Master Journey Test Suite', () {
    testWidgets(
      'Complete End-to-End User Master Journey: Auth -> Dashboard -> Add Client -> Create Invoice -> Settings',
      (WidgetTester tester) async {
        // Step 1: Launch App naturally from root entry point
        await _pumpApp(tester);

        // Step 2: Unauthenticated User lands on LoginView via Splash route
        expect(find.byType(LoginView), findsOneWidget);

        // Step 3: Enter User Auth Credentials
        final textFields = find.byType(TextField);
        expect(textFields, findsAtLeast(2));

        await tester.enterText(textFields.at(0), 'test@invoify.com');
        await tester.enterText(textFields.at(1), 'Password123!');
        await tester.pumpAndSettle();

        // Step 4: Tap Login Button
        final loginBtn = find.byType(CustomMaterialButton);
        expect(loginBtn, findsAtLeastNWidgets(1));
        await tester.tap(loginBtn.first);
        await tester.pumpAndSettle();

        // Verify SignInUseCase was invoked with credentials
        verify(
          () => mockSignInWithEmailAndPasswordUseCase(
            email: 'test@invoify.com',
            password: 'Password123!',
          ),
        ).called(1);

        // Step 5: Transition to DashboardView inside MainView
        expect(find.byType(DashboardView), findsOneWidget);

        // Step 6: User Navigates to Clients View & Adds New Client
        await _navigateToTab<ClientsView>(tester, CupertinoIcons.person_2);
        expect(find.byType(ClientCard), findsOneWidget);
        expect(find.text('Tech Corp'), findsOneWidget);

        final addClientHeaderBtn = find.byType(HeaderActionButton);
        expect(addClientHeaderBtn, findsAtLeast(1));
        await tester.tap(addClientHeaderBtn.first);
        await tester.pumpAndSettle();

        // Assert push to AddEditClientView
        expect(find.byType(AddEditClientView), findsOneWidget);

        // Fill Client Form
        final clientFields = find.byType(TextField);
        if (clientFields.evaluate().length >= 4) {
          await tester.enterText(clientFields.at(0), 'Acme Corp');
          await tester.enterText(clientFields.at(1), 'contact@acme.com');
          await tester.enterText(clientFields.at(2), '+1999888777');
          await tester.enterText(clientFields.at(3), '123 Tech Park');
          await tester.pumpAndSettle();
        }

        // Tap Save Client Button cleanly using specific ClientFormSubmitButton
        final saveClientBtn = find.byType(ClientFormSubmitButton);
        if (saveClientBtn.evaluate().isNotEmpty) {
          await tester.tap(saveClientBtn);
          await tester.pumpAndSettle();
        }

        // Assert successful pop back to ClientsView & newly added client is rendered
        expect(find.byType(ClientsView), findsOneWidget);
        expect(find.text('Acme Corp'), findsOneWidget);

        // Step 7: User Navigates to Invoices View & Creates Detailed Invoice with Items & Pricing
        await _navigateToTab<InvoicesView>(tester, CupertinoIcons.doc_text);
        expect(find.byType(InvoiceCard), findsOneWidget);
        expect(find.text('INV-001'), findsOneWidget);

        final addInvoiceHeaderBtn = find.byType(HeaderActionButton);
        expect(addInvoiceHeaderBtn, findsAtLeast(1));
        await tester.tap(addInvoiceHeaderBtn.first, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert push to AddEditInvoiceView
        expect(find.byType(AddEditInvoiceView), findsOneWidget);

        // Select Client via InvoiceClientPicker
        final clientPicker = find.byType(InvoiceClientPicker);
        if (clientPicker.evaluate().isNotEmpty) {
          await tester.tap(clientPicker);
          await tester.pumpAndSettle();

          final clientTile = find.text('Acme Corp');
          if (clientTile.evaluate().isNotEmpty) {
            await tester.tap(clientTile.last);
            await tester.pumpAndSettle();
          }
        }

        // Fill Invoice Item Details (Item Name, Quantity, Unit Price)
        final invoiceFormFields = find.byType(TextField);
        if (invoiceFormFields.evaluate().isNotEmpty) {
          await tester.enterText(
            invoiceFormFields.at(0),
            'Web Development Package',
          );
          if (invoiceFormFields.evaluate().length >= 3) {
            await tester.enterText(invoiceFormFields.at(1), '2');
            await tester.enterText(invoiceFormFields.at(2), '500');
          }
          await tester.pumpAndSettle();
        }

        // Programmatically dismiss the keyboard before tapping save.
        // tapAt() is unreliable because the AppBar absorbs taps before they
        // reach the CustomKeyboardUnfocus GestureDetector.
        // In integration tests, test & app share the same Dart isolate, so we
        // can call FocusManager directly.
        FocusManager.instance.primaryFocus?.unfocus();
        await tester
            .pumpAndSettle(); // Wait for keyboard dismiss animation to complete

        // scrollUntilVisible() scrolls the SingleChildScrollView until the button
        // is actually in the visible viewport, then we tap it.
        final saveInvoiceBtn = find.byType(AddEditInvoiceSaveButton);
        expect(saveInvoiceBtn, findsOneWidget);
        await tester.scrollUntilVisible(
          saveInvoiceBtn,
          100,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.pumpAndSettle();
        await tester.tap(saveInvoiceBtn, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert successful pop back to InvoicesView & newly created invoice card is rendered
        expect(find.byType(InvoicesView), findsOneWidget);
        expect(find.text('INV-002'), findsOneWidget);

        // Step 8: User Navigates to Settings View
        await _navigateToTab<SettingsView>(tester, CupertinoIcons.gear);
        expect(find.byType(SettingsView), findsOneWidget);
      },
    );

    testWidgets('Alternative Auth Flow: Navigate to Register View via Login Screen', (
      WidgetTester tester,
    ) async {
      await _pumpApp(tester);
      expect(find.byType(LoginView), findsOneWidget);

      // AuthRedirectText uses RichText + TapGestureRecognizer on the action span.
      // The action span is on the right side of the RichText widget.
      final registerLinkAlt = find.byType(AuthRedirectText);
      expect(registerLinkAlt, findsOneWidget);
      await Scrollable.ensureVisible(
        tester.element(registerLinkAlt),
        duration: const Duration(milliseconds: 300),
      );
      await tester.pumpAndSettle();
      // Tap the right-side of the RichText where the action TextSpan (TapGestureRecognizer) lives
      final richTextFinder = find.descendant(
        of: registerLinkAlt,
        matching: find.byType(RichText),
      );
      final richTextBox =
          tester.renderObject(
                richTextFinder.evaluate().isNotEmpty
                    ? richTextFinder
                    : registerLinkAlt,
              )
              as RenderBox;
      // App runs in Arabic (RTL): action span is on the LEFT side
      await tester.tapAt(
        richTextBox.localToGlobal(
          Offset(richTextBox.size.width * 0.15, richTextBox.size.height / 2),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RegisterView), findsOneWidget);

      // Fill Register form: name (0), email (1), password (2)
      final registerFields = find.byType(TextField);
      expect(registerFields, findsAtLeast(3));
      await tester.enterText(registerFields.at(0), 'Test User');
      await tester.enterText(registerFields.at(1), 'register@invoify.com');
      await tester.enterText(registerFields.at(2), 'RegPass123!');
      await tester.pumpAndSettle();

      // Dismiss keyboard then scroll to and tap the Register button
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();

      final registerBtn = find.byType(CustomMaterialButton);
      expect(registerBtn, findsOneWidget);
      await tester.scrollUntilVisible(
        registerBtn,
        100,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      await tester.tap(registerBtn, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Verify CreateUserWithEmailAndPasswordUseCase was called with correct args
      verify(
        () => mockCreateUserWithEmailAndPasswordUseCase(
          username: 'Test User',
          email: 'register@invoify.com',
          password: 'RegPass123!',
        ),
      ).called(1);

      expect(find.byType(CustomSuccessDialog), findsOneWidget);
      final dialogTitle = find.text(AppStrings.emailSentToVerify);
      expect(dialogTitle, findsOneWidget);

      final okBtn = find.widgetWithText(CustomMaterialButton, AppStrings.ok);
      if (okBtn.evaluate().isNotEmpty) {
        await tester.tap(okBtn);
        await tester.pumpAndSettle();
      }
    });

    testWidgets(
      'Alternative Auth Flow: Navigate to Forget Password View via Login Screen',
      (WidgetTester tester) async {
        await _pumpApp(tester);
        expect(find.byType(LoginView), findsOneWidget);

        // ForgetPassword uses an Align(centerEnd) wrapping a GestureDetector + Text.
        // We find the inner Text widget directly for a precise tap.
        final forgetPasswordLink = find.byType(ForgetPassword);
        expect(forgetPasswordLink, findsOneWidget);
        await Scrollable.ensureVisible(
          tester.element(forgetPasswordLink),
          duration: const Duration(milliseconds: 300),
        );
        await tester.pumpAndSettle();
        // Find the inner Text (forgotPassword label) for an exact tap on the tappable area
        final forgetText = find.descendant(
          of: forgetPasswordLink,
          matching: find.byType(Text),
        );
        final forgetBox =
            tester.renderObject(
                  forgetText.evaluate().isNotEmpty
                      ? forgetText
                      : forgetPasswordLink,
                )
                as RenderBox;
        await tester.tapAt(
          forgetBox.localToGlobal(forgetBox.size.center(Offset.zero)),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ForgetPasswordView), findsOneWidget);

        // Fill Forget Password form: email only
        final forgetFields = find.byType(TextField);
        expect(forgetFields, findsAtLeast(1));
        await tester.enterText(forgetFields.first, 'reset@invoify.com');
        await tester.pumpAndSettle();

        // Dismiss keyboard then tap the Send Reset Link button
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();

        final resetBtn = find.byType(CustomMaterialButton);
        expect(resetBtn, findsOneWidget);
        await tester.tap(resetBtn, warnIfMissed: false);
        await tester.pumpAndSettle();

        verify(() => mockForgetPasswordUseCase('reset@invoify.com')).called(1);

        expect(find.byType(CustomSuccessDialog), findsOneWidget);
        final dialogTitle = find.text(AppStrings.emailSentToReset);
        expect(dialogTitle, findsOneWidget);

        final okBtn = find.widgetWithText(CustomMaterialButton, AppStrings.ok);
        if (okBtn.evaluate().isNotEmpty) {
          await tester.tap(okBtn);
          await tester.pumpAndSettle();
        }
      },
    );

    tearDownAll(() async {
      await getIt.reset();
    });
  });
}
