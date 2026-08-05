import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/features/auth/presentation/view_models/user_info_cubit/user_info_cubit.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
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

extension InvoiceStatusColorExtension on InvoiceStatus {
  Color getColor(BuildContext context) => switch (this) {
    InvoiceStatus.paid => const Color(0xFF10B981),
    InvoiceStatus.sent => context.colors.primary,
    InvoiceStatus.opened => const Color(0xFF0284C7),
    InvoiceStatus.overdue => context.colors.error,
    InvoiceStatus.draft => context.colors.subText,
    InvoiceStatus.cancelled => Colors.orange,
  };

  Color getBackgroundColor(BuildContext context) =>
      getColor(context).withValues(alpha: 0.12);
}

extension CurrencyExtension on BuildContext {
  String get userCurrency {
    try {
      final user = watch<UserInfoCubit>().currentUser;
      final cur = user?.currency;
      if (cur != null && cur.trim().isNotEmpty) {
        return cur;
      }
      return 'EGP';
    } catch (_) {
      try {
        final user = read<UserInfoCubit>().currentUser;
        final cur = user?.currency;
        if (cur != null && cur.trim().isNotEmpty) {
          return cur;
        }
        return 'EGP';
      } catch (_) {
        return 'EGP';
      }
    }
  }

  String getCurrencySymbolByCode(String code) => switch (code.toUpperCase()) {
    'USD' => '\$',
    'EUR' => '€',
    'EGP' => isArabic ? 'ج.م' : 'EGP',
    'SAR' => isArabic ? 'ر.س' : 'SAR',
    'AED' => isArabic ? 'د.إ' : 'AED',
    _ => isArabic ? 'ج.م' : 'EGP',
  };

  String get currencySymbol => getCurrencySymbolByCode(userCurrency);

  String formatCurrency(num amount) {
    final formatted = amount.toStringAsFixed(2);
    final symbol = currencySymbol;

    if (symbol == '\$' || symbol == '€') {
      return '$symbol$formatted';
    } else {
      return '$formatted $symbol';
    }
  }
}

extension AppTheme on BuildContext {
  ColorsManager get colors => !isDarkMode ? LightColors() : DarkColors();
}

extension LanguageExtension on BuildContext {
  bool get isArabic {
    try {
      return locale.languageCode == 'ar';
    } catch (_) {
      return false;
    }
  }

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
