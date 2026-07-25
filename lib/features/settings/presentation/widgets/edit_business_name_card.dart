import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/helpers/validator.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/core/widgets/custom_keyboard_unfocus.dart';
import 'package:invoify/core/widgets/custom_material_button.dart';
import 'package:invoify/core/widgets/text_form_field_helper.dart';

class EditBusinessNameCard extends StatelessWidget {
  const EditBusinessNameCard({
    super.key,
    required this.controller,
    required this.isSavingNotifier,
    required this.onSave,
  });

  final TextEditingController controller;
  final ValueNotifier<bool> isSavingNotifier;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return CustomKeyboardUnfocus(
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: context.isDarkMode
                ? colors.border.withValues(alpha: 0.5)
                : colors.border,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.edit_note_rounded,
                  color: colors.primary,
                  size: 22.sp,
                ),
                Gap(8.w),
                Text(
                  AppStrings.businessName,
                  style: AppTextStyles.font15Bold.copyWith(
                    color: colors.mainText,
                  ),
                ),
              ],
            ),
            Gap(14.h),
            TextFormFieldHelper(
              controller: controller,
              hint: AppStrings.fullName,
              prefixIcon: Icon(
                Icons.business_center_outlined,
                color: colors.subText,
                size: 20.sp,
              ),
              onValidate: (value) => Validator.validateName(value),
            ),
            Gap(16.h),
            ValueListenableBuilder<bool>(
              valueListenable: isSavingNotifier,
              builder: (context, isSaving, child) => CustomMaterialButton(
                onPressed: onSave,
                text: AppStrings.saveChanges,
                isLoading: isSaving,
                maxWidth: true,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
