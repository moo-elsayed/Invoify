import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/helpers/validator.dart';
import 'package:invoify/core/widgets/text_form_field_helper.dart';

class ClientFormCard extends StatelessWidget {
  const ClientFormCard({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: context.isDarkMode
              ? colors.border.withValues(alpha: 0.5)
              : colors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Client Name Field
          TextFormFieldHelper(
            controller: nameController,
            hint: AppStrings.clientName,
            prefixIcon: Icon(
              Icons.person_outline_rounded,
              color: colors.subText,
              size: 20.sp,
            ),
            onValidate: (value) => Validator.validateName(value),
          ),
          Gap(16.h),

          // Client Email Field
          TextFormFieldHelper(
            controller: emailController,
            hint: AppStrings.clientEmail,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(
              Icons.email_outlined,
              color: colors.subText,
              size: 20.sp,
            ),
            onValidate: (value) => Validator.validateEmail(value),
          ),
          Gap(16.h),

          // Client Phone Field
          TextFormFieldHelper(
            controller: phoneController,
            hint: AppStrings.clientPhone,
            keyboardType: TextInputType.phone,
            prefixIcon: Icon(
              Icons.phone_outlined,
              color: colors.subText,
              size: 20.sp,
            ),
            onValidate: (value) => Validator.validatePhoneNumber(value),
          ),
          Gap(16.h),

          // Client Address Field
          TextFormFieldHelper(
            controller: addressController,
            hint: AppStrings.clientAddress,
            maxLines: 2,
            prefixIcon: Icon(
              Icons.location_on_outlined,
              color: colors.subText,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
