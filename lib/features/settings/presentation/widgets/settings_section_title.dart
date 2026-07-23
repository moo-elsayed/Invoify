import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';

class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsetsDirectional.only(
          bottom: 8.h,
          start: 4.w,
          end: 4.w,
        ),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            title,
            style: AppTextStyles.font14SemiBold.copyWith(
              color: context.colors.subText,
            ),
          ),
        ),
      );
}
