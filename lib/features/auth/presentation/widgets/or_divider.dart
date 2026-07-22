import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Divider(color: context.colors.border)),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Text(
          AppStrings.or,
          style: AppTextStyles.font14SemiBold.copyWith(
            color: context.colors.subText,
          ),
        ),
      ),
      Expanded(child: Divider(color: context.colors.border)),
    ],
  );
}
