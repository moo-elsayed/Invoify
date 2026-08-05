import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/widgets/custom_material_button.dart';
import 'package:invoify/core/widgets/text_form_field_helper.dart';
import 'package:invoify/features/auth/presentation/view_models/forget_password_cubit/forget_password_cubit.dart';
import 'package:invoify/features/auth/presentation/views/forget_password_view.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/test_widget_wrapper.dart';

class MockForgetPasswordCubit extends MockCubit<ForgetPasswordState>
    implements ForgetPasswordCubit {}

void main() {
  late MockForgetPasswordCubit mockForgetPasswordCubit;

  setUp(() {
    mockForgetPasswordCubit = MockForgetPasswordCubit();

    when(
      () => mockForgetPasswordCubit.state,
    ).thenReturn(ForgetPasswordInitial());

    if (GetIt.instance.isRegistered<ForgetPasswordCubit>()) {
      GetIt.instance.unregister<ForgetPasswordCubit>();
    }
    GetIt.instance.registerFactory<ForgetPasswordCubit>(
      () => mockForgetPasswordCubit,
    );
  });

  group('ForgetPasswordView Widget Tests', () {
    testWidgets('renders title, email field, and send reset link button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(child: const ForgetPasswordView()),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(AppStrings.passwordReset),
        findsNWidgets(2),
      ); // AppBar & Header
      expect(find.text(AppStrings.sendEmailResetLink), findsOneWidget);
      expect(find.byType(TextFormFieldHelper), findsOneWidget);
      expect(find.byType(CustomMaterialButton), findsOneWidget);
    });

    testWidgets('shows validation error when submitting empty email', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(child: const ForgetPasswordView()),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.widgetWithText(
          CustomMaterialButton,
          AppStrings.sendPasswordResetLink,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.emailCannotBeEmpty), findsOneWidget);
      verifyNever(() => mockForgetPasswordCubit.forgetPassword(any()));
    });

    testWidgets('calls forgetPassword on valid email submission', (
      WidgetTester tester,
    ) async {
      when(
        () => mockForgetPasswordCubit.forgetPassword(any()),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(
        createWidgetForTesting(child: const ForgetPasswordView()),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'user@example.com');
      await tester.pumpAndSettle();

      await tester.tap(
        find.widgetWithText(
          CustomMaterialButton,
          AppStrings.sendPasswordResetLink,
        ),
      );
      await tester.pumpAndSettle();

      verify(
        () => mockForgetPasswordCubit.forgetPassword('user@example.com'),
      ).called(1);
    });

    testWidgets(
      'shows loading indicator on button when state is ForgetPasswordLoading',
      (WidgetTester tester) async {
        when(
          () => mockForgetPasswordCubit.state,
        ).thenReturn(ForgetPasswordLoading());

        await tester.pumpWidget(
          createWidgetForTesting(child: const ForgetPasswordView()),
        );
        await tester.pump();

        final resetBtn = tester.widget<CustomMaterialButton>(
          find.widgetWithText(
            CustomMaterialButton,
            AppStrings.sendPasswordResetLink,
          ),
        );
        expect(resetBtn.isLoading, isTrue);
      },
    );
  });
}
