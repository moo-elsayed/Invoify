import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/core/widgets/custom_date_picker_bottom_sheet.dart';

class InvoiceDatesSection extends StatelessWidget {
  const InvoiceDatesSection({
    super.key,
    required this.issueDateNotifier,
    required this.dueDateNotifier,
  });

  final ValueNotifier<DateTime> issueDateNotifier;
  final ValueNotifier<DateTime> dueDateNotifier;

  void _selectDate(
    BuildContext context,
    ValueNotifier<DateTime> notifier, {
    DateTime? minimumDate,
    VoidCallback? onDateChanged,
  }) {
    CustomDatePickerBottomSheet.show(
      context: context,
      initialDate: notifier.value,
      minimumDate: minimumDate,
      onDateSelected: (date) {
        notifier.value = date;
        onDateChanged?.call();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        // Issue Date Card
        Expanded(
          child: ValueListenableBuilder<DateTime>(
            valueListenable: issueDateNotifier,
            builder: (context, issueDate, child) => InkWell(
              onTap: () => _selectDate(
                context,
                issueDateNotifier,
                onDateChanged: () {
                  if (dueDateNotifier.value.isBefore(issueDateNotifier.value)) {
                    dueDateNotifier.value = issueDateNotifier.value.add(
                      const Duration(days: 14),
                    );
                  }
                },
              ),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.issueDate,
                      style: AppTextStyles.font12Medium.copyWith(
                        color: colors.subText,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      DateFormat('yyyy-MM-dd').format(issueDate),
                      style: AppTextStyles.font14Bold.copyWith(
                        color: colors.mainText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Gap(12.w),

        // Due Date Card
        Expanded(
          child: ValueListenableBuilder<DateTime>(
            valueListenable: dueDateNotifier,
            builder: (context, dueDate, child) => InkWell(
              onTap: () => _selectDate(
                context,
                dueDateNotifier,
                minimumDate: issueDateNotifier.value,
              ),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.dueDate,
                      style: AppTextStyles.font12Medium.copyWith(
                        color: colors.subText,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      DateFormat('yyyy-MM-dd').format(dueDate),
                      style: AppTextStyles.font14Bold.copyWith(
                        color: colors.mainText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
