import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/di.dart';
import 'package:invoify/features/onboarding/presentation/view_models/onboarding_cubit/onboarding_cubit.dart';
import 'package:invoify/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:invoify/features/onboarding/presentation/widgets/onboarding_view_body.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/test_widget_wrapper.dart';

class MockOnboardingCubit extends MockCubit<OnboardingState>
    implements OnboardingCubit {}

void main() {
  late MockOnboardingCubit mockOnboardingCubit;

  setUp(() async {
    mockOnboardingCubit = MockOnboardingCubit();
    when(() => mockOnboardingCubit.state).thenReturn(OnboardingInitial());
    when(() => mockOnboardingCubit.setFirstTime()).thenAnswer((_) async {});

    await getIt.reset();
    getIt.registerFactory<OnboardingCubit>(() => mockOnboardingCubit);
  });

  tearDown(() {
    getIt.reset();
  });

  Widget buildTestableWidget() =>
      createWidgetForTesting(child: const OnboardingView());

  group('OnboardingView Widget Tests', () {
    testWidgets('renders OnboardingViewBody and next button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.byType(OnboardingViewBody), findsOneWidget);
      expect(find.text(AppStrings.next), findsOneWidget);
      expect(find.text(AppStrings.skip), findsOneWidget);
    });

    testWidgets('calls setFirstTime when tapping skip button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      await tester.tap(find.text(AppStrings.skip));
      await tester.pump();

      verify(() => mockOnboardingCubit.setFirstTime()).called(1);
    });
  });
}
