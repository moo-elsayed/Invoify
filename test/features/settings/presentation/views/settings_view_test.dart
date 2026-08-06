import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/di.dart';
import 'package:invoify/core/theming/app_theme_cubit.dart';
import 'package:invoify/core/widgets/main_screen_header.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';
import 'package:invoify/features/auth/presentation/view_models/signout_cubit/sign_out_cubit.dart';
import 'package:invoify/features/auth/presentation/view_models/user_info_cubit/user_info_cubit.dart';
import 'package:invoify/features/settings/presentation/views/settings_view.dart';
import 'package:invoify/features/settings/presentation/widgets/logout_button.dart';
import 'package:invoify/features/settings/presentation/widgets/user_profile_card.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/test_widget_wrapper.dart';

class MockUserInfoCubit extends MockCubit<UserInfoState>
    implements UserInfoCubit {}

class MockAppThemeCubit extends MockCubit<ThemeMode> implements AppThemeCubit {}

class MockSignOutCubit extends MockCubit<SignOutState>
    implements SignOutCubit {}

void main() {
  late MockUserInfoCubit mockUserInfoCubit;
  late MockAppThemeCubit mockAppThemeCubit;
  late MockSignOutCubit mockSignOutCubit;

  const tUser = UserEntity(
    uid: 'u100',
    email: 'bruce@wayne.com',
    businessName: 'Wayne Enterprises',
    currency: 'USD',
  );

  setUp(() async {
    mockUserInfoCubit = MockUserInfoCubit();
    mockAppThemeCubit = MockAppThemeCubit();
    mockSignOutCubit = MockSignOutCubit();

    when(() => mockUserInfoCubit.state).thenReturn(UserInfoInitial());
    when(() => mockUserInfoCubit.currentUser).thenReturn(tUser);
    when(() => mockAppThemeCubit.state).thenReturn(ThemeMode.light);
    when(() => mockSignOutCubit.state).thenReturn(SignOutInitial());

    await getIt.reset();
    getIt.registerFactory<SignOutCubit>(() => mockSignOutCubit);
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
      child: const SettingsView(),
    ),
  );

  group('SettingsView Widget Tests', () {
    testWidgets('renders user profile, settings sections, and logout button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.byType(MainScreenHeader), findsOneWidget);
      expect(find.byType(UserProfileCard), findsOneWidget);
      expect(find.text('Wayne Enterprises'), findsOneWidget);
      expect(find.text('bruce@wayne.com'), findsOneWidget);
      expect(find.text(AppStrings.generalSettings), findsOneWidget);
      expect(find.text(AppStrings.localSettings), findsOneWidget);
      expect(find.byType(LogoutButton), findsOneWidget);
    });
  });
}
