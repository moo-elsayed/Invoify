import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/widgets/custom_material_button.dart';
import 'package:invoify/core/widgets/text_form_field_helper.dart';
import 'package:invoify/features/auth/presentation/view_models/signin_cubit/sign_in_cubit.dart';
import 'package:invoify/features/auth/presentation/view_models/social_sign_in_cubit/social_sign_in_cubit.dart';
import 'package:invoify/features/auth/presentation/views/login_view.dart';
import 'package:invoify/features/auth/presentation/widgets/forget_password.dart';
import 'package:invoify/features/auth/presentation/widgets/social_login_button.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/test_widget_wrapper.dart';

class MockSignInCubit extends MockCubit<SignInState> implements SignInCubit {}

class MockSocialSignInCubit extends MockCubit<SocialSignInState>
    implements SocialSignInCubit {}

void main() {
  late MockSignInCubit mockSignInCubit;
  late MockSocialSignInCubit mockSocialSignInCubit;

  setUp(() {
    mockSignInCubit = MockSignInCubit();
    mockSocialSignInCubit = MockSocialSignInCubit();

    when(() => mockSignInCubit.state).thenReturn(SignInInitial());
    when(() => mockSocialSignInCubit.state).thenReturn(SocialSignInInitial());

    if (GetIt.instance.isRegistered<SignInCubit>()) {
      GetIt.instance.unregister<SignInCubit>();
    }
    GetIt.instance.registerFactory<SignInCubit>(() => mockSignInCubit);

    if (GetIt.instance.isRegistered<SocialSignInCubit>()) {
      GetIt.instance.unregister<SocialSignInCubit>();
    }
    GetIt.instance.registerFactory<SocialSignInCubit>(
      () => mockSocialSignInCubit,
    );
  });

  group('LoginView Widget Tests', () {
    testWidgets(
      'renders all initial UI elements (welcome, text fields, buttons)',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createWidgetForTesting(child: const LoginView()),
        );
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.welcome), findsOneWidget);
        expect(find.text(AppStrings.appTagline), findsOneWidget);
        expect(find.byType(TextFormFieldHelper), findsNWidgets(2));
        expect(find.byType(ForgetPassword), findsOneWidget);
        expect(
          find.byType(CustomMaterialButton),
          findsNWidgets(2),
        ); // Login button & Social button
        expect(find.byType(SocialLoginButton), findsOneWidget);
      },
    );

    testWidgets('shows validation errors when submitting empty form', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetForTesting(child: const LoginView()));
      await tester.pumpAndSettle();

      // Tap Login button without filling inputs
      await tester.tap(
        find.widgetWithText(CustomMaterialButton, AppStrings.login),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.emailCannotBeEmpty), findsOneWidget);
      expect(find.text(AppStrings.passwordCannotBeEmpty), findsOneWidget);
      verifyNever(
        () => mockSignInCubit.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    });

    testWidgets('calls signInWithEmailAndPassword on valid form submission', (
      WidgetTester tester,
    ) async {
      when(
        () => mockSignInCubit.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetForTesting(child: const LoginView()));
      await tester.pumpAndSettle();

      // Enter valid email and password (matching password validator requirements: 8+ chars, upper, lower, digit, special)
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'user@example.com');
      await tester.enterText(textFields.at(1), 'Password123!');
      await tester.pumpAndSettle();

      // Tap Login button
      await tester.tap(
        find.widgetWithText(CustomMaterialButton, AppStrings.login),
      );
      await tester.pumpAndSettle();

      verify(
        () => mockSignInCubit.signInWithEmailAndPassword(
          email: 'user@example.com',
          password: 'Password123!',
        ),
      ).called(1);
    });

    testWidgets(
      'shows loading state on Login button when state is SignInLoading',
      (WidgetTester tester) async {
        when(() => mockSignInCubit.state).thenReturn(SignInLoading());

        await tester.pumpWidget(
          createWidgetForTesting(child: const LoginView()),
        );
        await tester.pump();

        final loginBtn = tester.widget<CustomMaterialButton>(
          find.widgetWithText(CustomMaterialButton, AppStrings.login),
        );
        expect(loginBtn.isLoading, isTrue);
      },
    );

    testWidgets('calls googleSignIn when Google button is tapped', (
      WidgetTester tester,
    ) async {
      when(() => mockSocialSignInCubit.googleSignIn()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetForTesting(child: const LoginView()));
      await tester.pumpAndSettle();

      final googleBtn = find.widgetWithText(
        CustomMaterialButton,
        AppStrings.signInWithGoogle,
      );
      await tester.ensureVisible(googleBtn);
      await tester.pumpAndSettle();

      await tester.tap(googleBtn);
      await tester.pumpAndSettle();

      verify(() => mockSocialSignInCubit.googleSignIn()).called(1);
    });
  });
}
