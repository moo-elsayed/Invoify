import 'package:flutter/material.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: GestureDetector(
      onTap: onTap,
      child: Text(
        AppStrings.forgotPassword,
        style: AppTextStyles.font13SemiBold.copyWith(
          color: context.colors.primary,
        ),
      ),
    ),
  );
}
