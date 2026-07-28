import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';

class StatusChartLegendItem extends StatelessWidget {
  const StatusChartLegendItem({
    super.key,
    required this.color,
    required this.label,
    required this.count,
  });

  final Color color;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        Gap(8.w),
        Text(
          '$label ($count)',
          style: AppTextStyles.font12Medium.copyWith(color: colors.mainText),
        ),
      ],
    );
  }
}
