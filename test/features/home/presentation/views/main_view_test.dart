import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/di.dart';
import 'package:invoify/core/services/notification/notification_service.dart';
import 'package:invoify/core/theming/app_theme_cubit.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';
import 'package:invoify/features/auth/presentation/view_models/signout_cubit/sign_out_cubit.dart';
import 'package:invoify/features/auth/presentation/view_models/user_info_cubit/user_info_cubit.dart';
import 'package:invoify/features/clients/presentation/view_models/clients_cubit/clients_cubit.dart';
import 'package:invoify/features/dashboard/presentation/view_models/dashboard_cubit/dashboard_cubit.dart';
import 'package:invoify/features/dashboard/presentation/view_models/dashboard_cubit/dashboard_state.dart';
import 'package:invoify/features/home/presentation/views/main_view.dart';
import 'package:invoify/features/home/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_state.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/test_widget_wrapper.dart';

class MockDashboardCubit extends MockCubit<DashboardState>
    implements DashboardCubit {}

class MockInvoicesCubit extends MockCubit<InvoicesState>
    implements InvoicesCubit {}

class MockClientsCubit extends MockCubit<ClientsState>
    implements ClientsCubit {}

class MockUserInfoCubit extends MockCubit<UserInfoState>
    implements UserInfoCubit {}

class MockAppThemeCubit extends MockCubit<ThemeMode> implements AppThemeCubit {}

class MockSignOutCubit extends MockCubit<SignOutState>
    implements SignOutCubit {}

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  late MockDashboardCubit mockDashboardCubit;
  late MockInvoicesCubit mockInvoicesCubit;
  late MockClientsCubit mockClientsCubit;
  late MockUserInfoCubit mockUserInfoCubit;
  late MockAppThemeCubit mockAppThemeCubit;
  late MockSignOutCubit mockSignOutCubit;
  late MockNotificationService mockNotificationService;

  const tUser = UserEntity(
    uid: 'u1',
    email: 'user@test.com',
    businessName: 'Test Corp',
  );

  setUp(() async {
    mockDashboardCubit = MockDashboardCubit();
    mockInvoicesCubit = MockInvoicesCubit();
    mockClientsCubit = MockClientsCubit();
    mockUserInfoCubit = MockUserInfoCubit();
    mockAppThemeCubit = MockAppThemeCubit();
    mockSignOutCubit = MockSignOutCubit();
    mockNotificationService = MockNotificationService();

    when(() => mockDashboardCubit.state).thenReturn(const DashboardInitial());
    when(
      () => mockDashboardCubit.loadDashboardData(
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => mockDashboardCubit.updateFromInvoices(any()),
    ).thenAnswer((_) async {});
    when(
      () => mockDashboardCubit.updateClientsCount(any()),
    ).thenAnswer((_) async {});

    when(() => mockInvoicesCubit.state).thenReturn(const InvoicesInitial());
    when(() => mockInvoicesCubit.allInvoices).thenReturn([]);
    when(() => mockInvoicesCubit.getInvoices()).thenAnswer((_) async {});

    when(() => mockClientsCubit.state).thenReturn(ClientsInitial());
    when(() => mockClientsCubit.allClients).thenReturn([]);
    when(() => mockClientsCubit.getClients()).thenAnswer((_) async {});

    when(() => mockUserInfoCubit.state).thenReturn(UserInfoInitial());
    when(() => mockUserInfoCubit.currentUser).thenReturn(tUser);
    when(
      () => mockUserInfoCubit.updateLanguageCode(any()),
    ).thenAnswer((_) async {});

    when(() => mockAppThemeCubit.state).thenReturn(ThemeMode.light);
    when(() => mockSignOutCubit.state).thenReturn(SignOutInitial());

    when(
      () => mockNotificationService.updateLanguageCode(any()),
    ).thenAnswer((_) async {});

    await getIt.reset();
    getIt.registerSingleton<DashboardCubit>(mockDashboardCubit);
    getIt.registerSingleton<InvoicesCubit>(mockInvoicesCubit);
    getIt.registerSingleton<ClientsCubit>(mockClientsCubit);
    getIt.registerFactory<SignOutCubit>(() => mockSignOutCubit);
    getIt.registerSingleton<NotificationService>(mockNotificationService);
  });

  tearDown(() {
    getIt.reset();
  });

  Widget buildTestableWidget() => createWidgetForTesting(
    child: MultiBlocProvider(
      providers: [
        BlocProvider<UserInfoCubit>.value(value: mockUserInfoCubit),
        BlocProvider<AppThemeCubit>.value(value: mockAppThemeCubit),
      ],
      child: const MainView(),
    ),
  );

  group('MainView Widget Tests', () {
    testWidgets('renders bottom navigation bar with 4 tabs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.byType(CustomBottomNavigationBar), findsOneWidget);
    });

    testWidgets('switches screen view when tapping navigation bar tabs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      // Tap Invoices Tab icon
      await tester.tap(find.byIcon(CupertinoIcons.doc_text));
      await tester.pump();

      // Tap Clients Tab icon
      await tester.tap(find.byIcon(CupertinoIcons.person_2));
      await tester.pump();

      // Tap Settings Tab icon
      await tester.tap(find.byIcon(CupertinoIcons.gear_alt));
      await tester.pump();
    });
  });
}
