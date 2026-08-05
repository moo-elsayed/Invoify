import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/widgets/custom_material_button.dart';
import 'package:invoify/core/widgets/text_form_field_helper.dart';
import 'package:invoify/features/auth/presentation/view_models/signup_cubit/sign_up_cubit.dart';
import 'package:invoify/features/auth/presentation/views/register_view.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/test_widget_wrapper.dart';

class MockSignupCubit extends MockCubit<SignupState> implements SignupCubit {}

void main() {
  late MockSignupCubit mockSignupCubit;

  setUp(() {
    mockSignupCubit = MockSignupCubit();

    when(() => mockSignupCubit.state).thenReturn(SignUpInitial());

    if (GetIt.instance.isRegistered<SignupCubit>()) {
      GetIt.instance.unregister<SignupCubit>();
    }
    GetIt.instance.registerFactory<SignupCubit>(() => mockSignupCubit);
  });

  group('RegisterView Widget Tests', () {
    testWidgets(
      'renders all initial UI elements (new account header, app tagline, 3 fields, register button)',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createWidgetForTesting(child: const RegisterView()),
        );
        await tester.pumpAndSettle();

        expect(
          find.text(AppStrings.newAccount),
          findsNWidgets(2),
        ); // Header & AppBar
        expect(find.text(AppStrings.appTagline), findsOneWidget);
        expect(
          find.byType(TextFormFieldHelper),
          findsNWidgets(3),
        ); // Name, Email, Password
        expect(find.byType(CustomMaterialButton), findsOneWidget);
      },
    );

    testWidgets('shows validation errors when submitting empty form', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(child: const RegisterView()),
      );
      await tester.pumpAndSettle();

      // Tap Register button without entering inputs
      await tester.tap(
        find.widgetWithText(CustomMaterialButton, AppStrings.register),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.nameCannotBeEmpty), findsOneWidget);
      expect(find.text(AppStrings.emailCannotBeEmpty), findsOneWidget);
      expect(find.text(AppStrings.passwordCannotBeEmpty), findsOneWidget);
      verifyNever(
        () => mockSignupCubit.createUserWithEmailAndPassword(
          username: any(named: 'username'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    });

    testWidgets(
      'calls createUserWithEmailAndPassword on valid form submission',
      (WidgetTester tester) async {
        when(
          () => mockSignupCubit.createUserWithEmailAndPassword(
            username: any(named: 'username'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(
          createWidgetForTesting(child: const RegisterView()),
        );
        await tester.pumpAndSettle();

        final fields = find.byType(TextFormField);
        await tester.enterText(fields.at(0), 'John Doe');
        await tester.enterText(fields.at(1), 'john@example.com');
        await tester.enterText(fields.at(2), 'Password123!');
        await tester.pumpAndSettle();

        await tester.tap(
          find.widgetWithText(CustomMaterialButton, AppStrings.register),
        );
        await tester.pumpAndSettle();

        verify(
          () => mockSignupCubit.createUserWithEmailAndPassword(
            username: 'John Doe',
            email: 'john@example.com',
            password: 'Password123!',
          ),
        ).called(1);
      },
    );

    testWidgets(
      'shows loading state on Register button when state is SignUpLoading',
      (WidgetTester tester) async {
        when(() => mockSignupCubit.state).thenReturn(SignUpLoading());

        await tester.pumpWidget(
          createWidgetForTesting(child: const RegisterView()),
        );
        await tester.pump();

        final registerBtn = tester.widget<CustomMaterialButton>(
          find.widgetWithText(CustomMaterialButton, AppStrings.register),
        );
        expect(registerBtn.isLoading, isTrue);
      },
    );
  });
}
