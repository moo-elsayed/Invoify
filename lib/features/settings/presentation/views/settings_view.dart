import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/widgets/app_toasts.dart';
import 'package:invoify/core/widgets/custom_app_bar.dart';
import 'package:invoify/features/auth/presentation/view_models/user_info_cubit/user_info_cubit.dart';
import 'package:invoify/features/settings/presentation/helpers/settings_helpers.dart';
import 'package:invoify/features/settings/presentation/widgets/logout_button.dart';
import 'package:invoify/features/settings/presentation/widgets/settings_card.dart';
import 'package:invoify/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:invoify/features/settings/presentation/widgets/user_profile_card.dart';
import 'package:toastification/toastification.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to locale changes so app bar title and settings items rebuild dynamically
    final _ = context.locale;

    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.settings, showArrowBack: false),
      body: SafeArea(
        child: BlocConsumer<UserInfoCubit, UserInfoState>(
          listener: (context, state) {
            if (state is UserUpdateSuccess) {
              AppToast.show(
                context: context,
                title: state.message,
                type: ToastificationType.success,
              );
            } else if (state is UserUpdateFailure) {
              AppToast.show(
                context: context,
                title: state.error,
                type: ToastificationType.error,
              );
            }
          },
          builder: (context, state) {
            final user = context.read<UserInfoCubit>().currentUser;
            final currentCurrency = user?.currency ?? 'USD';

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                children: [
                  // User Profile Header Card
                  UserProfileCard(user: user),
                  Gap(24.h),

                  // General Settings Section
                  SettingsSectionTitle(title: AppStrings.generalSettings),
                  SettingsCard(
                    items: getGeneralSettingsItems(
                      context: context,
                      onProfileTap: () {
                        // Profile details info trigger
                      },
                    ),
                  ),
                  Gap(24.h),

                  // Preferences Section
                  SettingsSectionTitle(title: AppStrings.localSettings),
                  SettingsCard(
                    items: getLocalSettingsItems(
                      context: context,
                      currentCurrency: currentCurrency,
                      onCurrencyChanged: (newCurrency) {
                        context
                            .read<UserInfoCubit>()
                            .updateCurrency(newCurrency);
                      },
                    ),
                  ),
                  Gap(32.h),

                  // Logout Button
                  const LogoutButton(),
                  Gap(24.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
