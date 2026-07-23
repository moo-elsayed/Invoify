import 'package:flutter/material.dart';
import 'package:invoify/features/auth/presentation/args/login_args.dart';
import 'package:invoify/features/auth/presentation/views/forget_password_view.dart';
import 'package:invoify/features/auth/presentation/views/login_view.dart';
import 'package:invoify/features/auth/presentation/views/register_view.dart';
import 'package:invoify/features/home/presentation/views/main_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/splash/presentation/views/animated_splash_view.dart';
import 'routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  RouteSettings? _currentSettings;

  Route? generateRoute(RouteSettings settings) {
    _currentSettings = settings;

    switch (settings.name) {
      case Routes.splashView:
        return _route(const AnimatedSplashView());
      case Routes.onboardingView:
        return _route(const OnboardingView());
      case Routes.loginView:
        return _route(LoginView(loginArgs: settings.arguments as LoginArgs?));
      case Routes.registerView:
        return _route(const RegisterView());
      case Routes.forgetPasswordView:
        return _route(const ForgetPasswordView());
      case Routes.homeView:
        return _route(const MainView());
      default:
        return null;
    }
  }

  PageRouteBuilder<dynamic> _route(Widget view) => PageRouteBuilder(
    settings: _currentSettings,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, animation, secondaryAnimation) => view,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideTween = Tween<Offset>(
        begin: const Offset(0.08, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));

      final fadeTween = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeOutCubic));

      return FadeTransition(
        opacity: animation.drive(fadeTween),
        child: SlideTransition(
          position: animation.drive(slideTween),
          child: child,
        ),
      );
    },
  );
}
