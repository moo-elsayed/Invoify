import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';
import 'package:invoify/features/auth/presentation/view_models/user_info_cubit/user_info_cubit.dart';
import 'package:invoify/features/settings/presentation/views/profile_details_view.dart';
import 'package:invoify/features/settings/presentation/widgets/account_details_card.dart';
import 'package:invoify/features/settings/presentation/widgets/edit_business_name_card.dart';
import 'package:invoify/features/settings/presentation/widgets/profile_header_card.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/test_widget_wrapper.dart';

class MockUserInfoCubit extends MockCubit<UserInfoState>
    implements UserInfoCubit {}

void main() {
  late MockUserInfoCubit mockUserInfoCubit;

  final tUser = UserEntity(
    uid: 'u200',
    email: 'clark@dailyplanet.com',
    businessName: 'Daily Planet',
    currency: 'EGP',
    createdAt: DateTime(2025, 1, 1),
  );

  setUp(() {
    mockUserInfoCubit = MockUserInfoCubit();
    when(() => mockUserInfoCubit.state).thenReturn(UserInfoInitial());
    when(() => mockUserInfoCubit.currentUser).thenReturn(tUser);
    when(() => mockUserInfoCubit.getUserInfo()).thenAnswer((_) async {});
  });

  Widget buildTestableWidget() => createWidgetForTesting(
        child: BlocProvider<UserInfoCubit>.value(
          value: mockUserInfoCubit,
          child: const ProfileDetailsView(),
        ),
      );

  group('ProfileDetailsView Widget Tests', () {
    testWidgets('renders profile header, business name input, and account details', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.profileInformation), findsOneWidget);
      expect(find.byType(ProfileHeaderCard), findsOneWidget);
      expect(find.byType(EditBusinessNameCard), findsOneWidget);
      expect(find.byType(AccountDetailsCard), findsOneWidget);
      expect(find.text('clark@dailyplanet.com'), findsWidgets);
      expect(find.text('Daily Planet'), findsWidgets);
    });

    testWidgets('calls updateBusinessName on cubit when business name is modified and saved', (
      WidgetTester tester,
    ) async {
      when(() => mockUserInfoCubit.updateBusinessName(any())).thenAnswer((_) async {});

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final input = find.byType(EditBusinessNameCard);
      await tester.enterText(input, 'Metropolis News Network');
      await tester.pumpAndSettle();

      final saveBtn = find.text(AppStrings.saveChanges);
      await tester.tap(saveBtn);
      await tester.pump();

      verify(() => mockUserInfoCubit.updateBusinessName('Metropolis News Network')).called(1);
    });
  });
}
