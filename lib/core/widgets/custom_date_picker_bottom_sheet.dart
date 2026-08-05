import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/core/widgets/bottom_sheet_handle.dart';

class CustomDatePickerBottomSheet extends StatelessWidget {
  const CustomDatePickerBottomSheet({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
    this.title,
    this.minimumDate,
    this.maximumDate,
  });

  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? title;
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  static Future<void> show({
    required BuildContext context,
    required DateTime initialDate,
    required ValueChanged<DateTime> onDateSelected,
    String? title,
    DateTime? minimumDate,
    DateTime? maximumDate,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      isScrollControlled: true,
      builder: (context) => CustomDatePickerBottomSheet(
        initialDate: initialDate,
        onDateSelected: onDateSelected,
        title: title,
        minimumDate: minimumDate,
        maximumDate: maximumDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final minDate = minimumDate ?? today;
    final maxDate = maximumDate ?? DateTime(now.year + 10);
    final effectiveInitialDate = initialDate.isBefore(minDate)
        ? minDate
        : initialDate;

    DateTime tempPicked = effectiveInitialDate;

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      height: 340.h,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: context.isDarkMode
              ? colors.border.withValues(alpha: 0.5)
              : colors.border,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      child: Column(
        children: [
          // Drag Handle
          const BottomSheetHandle(),
          Gap(8.h),

          // Header Row with Cancel, Title, and OK
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  AppStrings.cancel,
                  style: AppTextStyles.font14Medium.copyWith(
                    color: colors.subText,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  title ?? AppStrings.selectDate,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font16SemiBold.copyWith(
                    color: colors.mainText,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  onDateSelected(tempPicked);
                  context.pop();
                },
                child: Text(
                  AppStrings.ok,
                  style: AppTextStyles.font14SemiBold.copyWith(
                    color: colors.primary,
                  ),
                ),
              ),
            ],
          ),
          Divider(color: colors.border.withValues(alpha: 0.5), height: 1),
          Gap(8.h),

          // Cupertino Date Picker Wheel
          Expanded(
            child: CupertinoTheme(
              data: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: AppTextStyles.font16Medium.copyWith(
                    color: colors.mainText,
                  ),
                ),
              ),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: effectiveInitialDate,
                minimumDate: minDate,
                maximumDate: maxDate,
                onDateTimeChanged: (date) {
                  tempPicked = date;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
