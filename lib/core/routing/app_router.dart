import 'package:flutter/material.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  RouteSettings? _currentSettings;

  Route? generateRoute(RouteSettings settings) {
    _currentSettings = settings;
    final arguments = settings.arguments;

    switch (settings.name) {
      default:
        return null;
    }
  }

  MaterialPageRoute<dynamic> _route(Widget view) =>
      MaterialPageRoute(builder: (_) => view, settings: _currentSettings);
}