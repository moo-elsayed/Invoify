import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:toastification/toastification.dart';
import '../theming/colors_manager.dart';

extension Navigation on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushNamed(routeName, arguments: arguments);

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);

  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
    required RoutePredicate predicate,
    bool rootNavigator = false,
  }) => Navigator.of(
    this,
    rootNavigator: rootNavigator,
  ).pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);

  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);
}

extension AppToastColorExtension on ToastificationType {
  Color getColor(BuildContext context) => switch (this) {
    .success => context.colors.success,
    .info => context.colors.primary,
    .warning => context.colors.warning,
    .error => context.colors.error,
    _ => context.colors.primary,
  };
}

extension AppToastIconExtension on ToastificationType {
  IconData get stateIcon => switch (this) {
    .success => Icons.check_circle_outline_rounded,
    .error => Icons.error_outline_rounded,
    .warning => Icons.warning_amber_rounded,
    .info => Icons.info_outline_rounded,
    _ => Icons.info_outline_rounded,
  };
}

extension AppTheme on BuildContext {
  ColorsManager get colors => !isDarkMode ? LightColors() : DarkColors();
}

extension LanguageExtension on BuildContext {
  bool get isArabic => locale.languageCode == 'ar';

  bool get isRTL => Directionality.of(this) == ui.TextDirection.rtl;
}

extension ThemeExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == .dark;

  ThemeData get theme => Theme.of(this);
}

extension ThemeModeExtension on ThemeMode {
  String toText() {
    switch (this) {
      case .system:
        return AppStrings.system;
      case .light:
        return AppStrings.light;
      case .dark:
        return AppStrings.dark;
    }
  }
}
