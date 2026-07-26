import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/core/widgets/custom_confirmation_dialog.dart';
import 'package:invoify/core/widgets/custom_icon_action_button.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/presentation/widgets/client_info_row.dart';

class ClientCard extends StatelessWidget {
  const ClientCard({
    super.key,
    required this.client,
    required this.onEdit,
    required this.onDelete,
  });

  final ClientEntity client;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  void _showDeleteConfirmation(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CustomConfirmationDialog(
        title: AppStrings.deleteClient,
        subtitle: AppStrings.deleteClientConfirmation,
        textConfirmButton: AppStrings.deleteClient,
        onConfirm: () {
          dialogContext.pop();
          onDelete();
        },
      ),
    );
  }

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
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.isDarkMode
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Icon Badge, Name & Direct Action Buttons
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: colors.primary,
                  size: 20.sp,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Text(
                  client.name,
                  style: AppTextStyles.font16Bold.copyWith(
                    color: colors.mainText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Gap(8.w),
              // Edit Action Button
              CustomIconActionButton(
                icon: Icons.edit_outlined,
                onTap: onEdit,
                color: colors.primary,
              ),
              Gap(8.w),
              // Delete Action Button
              CustomIconActionButton(
                icon: Icons.delete_outline_rounded,
                onTap: () => _showDeleteConfirmation(context),
                color: colors.error,
              ),
            ],
          ),
          if (client.email.isNotEmpty ||
              client.phone.isNotEmpty ||
              client.address.isNotEmpty) ...[
            Gap(12.h),
            Divider(color: colors.border.withValues(alpha: 0.5), height: 1),
            Gap(12.h),
            if (client.email.isNotEmpty) ...[
              ClientInfoRow(icon: Icons.email_outlined, text: client.email),
              if (client.phone.isNotEmpty || client.address.isNotEmpty)
                Gap(8.h),
            ],
            if (client.phone.isNotEmpty) ...[
              ClientInfoRow(icon: Icons.phone_outlined, text: client.phone),
              if (client.address.isNotEmpty) Gap(8.h),
            ],
            if (client.address.isNotEmpty)
              ClientInfoRow(
                icon: Icons.location_on_outlined,
                text: client.address,
              ),
          ],
        ],
      ),
    );
  }
}
