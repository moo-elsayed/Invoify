import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/di.dart';
import 'package:invoify/features/splash/presentation/view_models/splash_cubit/splash_cubit.dart';
import 'package:invoify/features/splash/presentation/views/animated_splash_view.dart';
import 'package:invoify/features/splash/presentation/widgets/animated_splash_view_body.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/test_widget_wrapper.dart';

class MockSplashCubit extends MockCubit<SplashState> implements SplashCubit {}

void main() {
  late MockSplashCubit mockSplashCubit;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockSplashCubit = MockSplashCubit();

    when(() => mockSplashCubit.state).thenReturn(const SplashInitial());
    when(() => mockSplashCubit.checkAppStatus()).thenAnswer((_) async {});

    await getIt.reset();
    getIt.registerFactory<SplashCubit>(() => mockSplashCubit);
  });

  tearDown(() {
    getIt.reset();
  });

  Widget buildTestableWidget() =>
      createWidgetForTesting(child: const AnimatedSplashView());

  group('AnimatedSplashView Widget Tests', () {
    testWidgets('renders AnimatedSplashViewBody and app title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.byType(AnimatedSplashViewBody), findsOneWidget);
      expect(find.text('Invoify'), findsOneWidget);
      expect(find.text(AppStrings.appTagline), findsOneWidget);
      verify(() => mockSplashCubit.checkAppStatus()).called(1);
    });
  });
}
