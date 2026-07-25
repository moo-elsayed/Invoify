import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/di.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/core/theming/app_theme_cubit.dart';
import 'package:invoify/core/utils/custom_bottom_sheet_selection_item.dart';
import 'package:invoify/core/widgets/app_toasts.dart';
import 'package:invoify/core/widgets/custom_bottom_sheet.dart';
import 'package:invoify/core/widgets/custom_confirmation_dialog.dart';
import 'package:invoify/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:invoify/features/settings/presentation/items/currency_item.dart';
import 'package:invoify/features/settings/presentation/items/settings_card_item.dart';
import 'package:toastification/toastification.dart';

List<CurrencyItem> getSupportedCurrencies() => [
  CurrencyItem(code: 'USD', name: AppStrings.usd),
  CurrencyItem(code: 'EGP', name: AppStrings.egp),
  CurrencyItem(code: 'EUR', name: AppStrings.eur),
  CurrencyItem(code: 'SAR', name: AppStrings.sar),
  CurrencyItem(code: 'AED', name: AppStrings.aed),
];

List<CustomBottomSheetSelectionItem<String>> getLanguageItems({
  required BuildContext context,
}) => [
  CustomBottomSheetSelectionItem<String>(
    title: AppStrings.arabic,
    icon: Icons.language_rounded,
    value: 'ar',
    isSelected: context.isArabic,
    onTap: () async {
      await context.setLocale(const Locale('ar'));
    },
  ),
  CustomBottomSheetSelectionItem<String>(
    title: AppStrings.english,
    icon: Icons.language_rounded,
    value: 'en',
    isSelected: !context.isArabic,
    onTap: () async {
      await context.setLocale(const Locale('en'));
    },
  ),
];

List<CustomBottomSheetSelectionItem<ThemeMode>> getThemeItems({
  required BuildContext context,
}) {
  final currentTheme = context.read<AppThemeCubit>().state;
  return [
    CustomBottomSheetSelectionItem<ThemeMode>(
      title: AppStrings.light,
      icon: Icons.wb_sunny_outlined,
      value: ThemeMode.light,
      isSelected: currentTheme == ThemeMode.light,
      onTap: () => context.read<AppThemeCubit>().changeTheme(ThemeMode.light),
    ),
    CustomBottomSheetSelectionItem<ThemeMode>(
      title: AppStrings.dark,
      icon: Icons.nightlight_round_outlined,
      value: ThemeMode.dark,
      isSelected: currentTheme == ThemeMode.dark,
      onTap: () => context.read<AppThemeCubit>().changeTheme(ThemeMode.dark),
    ),
    CustomBottomSheetSelectionItem<ThemeMode>(
      title: AppStrings.system,
      icon: Icons.brightness_auto_outlined,
      value: ThemeMode.system,
      isSelected: currentTheme == ThemeMode.system,
      onTap: () => context.read<AppThemeCubit>().changeTheme(ThemeMode.system),
    ),
  ];
}

List<CustomBottomSheetSelectionItem<String>> getCurrencyItems({
  required BuildContext context,
  required String currentCurrency,
  required ValueChanged<String> onCurrencySelected,
}) => getSupportedCurrencies()
    .map(
      (curr) => CustomBottomSheetSelectionItem<String>(
        title: '${curr.name} (${curr.code})',
        icon: Icons.monetization_on_outlined,
        value: curr.code,
        isSelected: currentCurrency == curr.code,
        onTap: () => onCurrencySelected(curr.code),
      ),
    )
    .toList();

List<SettingsCardItem> getGeneralSettingsItems({
  required BuildContext context,
  required VoidCallback onProfileTap,
}) => [
  SettingsCardItem(
    icon: Icons.business_center_outlined,
    title: AppStrings.profileInformation,
    onTap: onProfileTap,
  ),
  SettingsCardItem(
    icon: Icons.lock_reset_rounded,
    title: AppStrings.securitySettings,
    onTap: () {
      final user = FirebaseAuth.instance.currentUser;
      if (user?.email == null) return;

      showCupertinoDialog(
        context: context,
        builder: (dialogContext) => CustomConfirmationDialog(
          title: AppStrings.passwordReset,
          subtitle: AppStrings.sendPasswordResetConfirmation,
          textConfirmButton: AppStrings.send,
          onConfirm: () async {
            dialogContext.pop();
            final response = await getIt<ForgetPasswordUseCase>()(user!.email!);
            if (context.mounted) {
              switch (response) {
                case NetworkSuccess<void>():
                  AppToast.show(
                    context: context,
                    title: AppStrings.passwordResetSent,
                    type: ToastificationType.success,
                  );
                case NetworkFailure<void>():
                  AppToast.show(
                    context: context,
                    title: response.error,
                    type: ToastificationType.error,
                  );
              }
            }
          },
        ),
      );
    },
  ),
];

List<SettingsCardItem> getLocalSettingsItems({
  required BuildContext context,
  required String currentCurrency,
  required ValueChanged<String> onCurrencyChanged,
}) => [
  SettingsCardItem(
    icon: Icons.language_rounded,
    title: AppStrings.language,
    trailingText: context.isArabic ? AppStrings.arabic : AppStrings.english,
    onTap: () {
      CustomBottomSheet.show(
        context: context,
        title: AppStrings.language,
        items: getLanguageItems(context: context),
      );
    },
  ),
  SettingsCardItem(
    icon: Icons.color_lens_outlined,
    title: AppStrings.theme,
    trailingText: context.watch<AppThemeCubit>().state.toText(),
    onTap: () {
      CustomBottomSheet.show(
        context: context,
        title: AppStrings.theme,
        items: getThemeItems(context: context),
      );
    },
  ),
  SettingsCardItem(
    icon: Icons.attach_money_rounded,
    title: AppStrings.currency,
    trailingText: currentCurrency,
    onTap: () {
      CustomBottomSheet.show(
        context: context,
        title: AppStrings.currency,
        items: getCurrencyItems(
          context: context,
          currentCurrency: currentCurrency,
          onCurrencySelected: onCurrencyChanged,
        ),
      );
    },
  ),
];
