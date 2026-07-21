import 'package:flutter/material.dart';
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
        return _route(const Scaffold(body: Center(child: Text('Login View'))));
      case Routes.homeView:
        return _route(const Scaffold(body: Center(child: Text('Home View'))));
      default:
        return null;
    }
  }

  MaterialPageRoute<dynamic> _route(Widget view) =>
      MaterialPageRoute(builder: (_) => view, settings: _currentSettings);
}