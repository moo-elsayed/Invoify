import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';

class AccountDetailRow extends StatelessWidget {
  const AccountDetailRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.valueWidget,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Icon(icon, size: 20.sp, color: colors.subText),
        Gap(12.w),
        Text(
          label,
          style: AppTextStyles.font14Medium.copyWith(color: colors.subText),
        ),
        Gap(12.w),
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child:
                valueWidget ??
                (value != null
                    ? Text(
                        value!,
                        style: AppTextStyles.font14Bold.copyWith(
                          color: colors.mainText,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      )
                    : const SizedBox.shrink()),
          ),
        ),
      ],
    );
  }
}
