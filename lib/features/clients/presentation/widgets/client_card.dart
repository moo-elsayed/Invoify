import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/core/widgets/custom_confirmation_dialog.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';

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
    showDialog(
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
    final initialLetter =
        client.name.trim().isNotEmpty ? client.name.trim()[0].toUpperCase() : 'C';

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
          // Header Row: Avatar, Name & Options Menu
          Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: colors.primary.withValues(alpha: 0.12),
                child: Text(
                  initialLetter,
                  style: AppTextStyles.font16Bold.copyWith(
                    color: colors.primary,
                  ),
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
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: colors.subText,
                  size: 20.sp,
                ),
                color: colors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(context);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 18.sp,
                          color: colors.primary,
                        ),
                        Gap(8.w),
                        Text(
                          AppStrings.editClient,
                          style: AppTextStyles.font14Medium.copyWith(
                            color: colors.mainText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          size: 18.sp,
                          color: colors.error,
                        ),
                        Gap(8.w),
                        Text(
                          AppStrings.deleteClient,
                          style: AppTextStyles.font14Medium.copyWith(
                            color: colors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap(12.h),

          // Email
          if (client.email.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.email_outlined,
                  size: 16.sp,
                  color: colors.subText,
                ),
                Gap(8.w),
                Expanded(
                  child: Text(
                    client.email,
                    style: AppTextStyles.font13Regular.copyWith(
                      color: colors.subText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Gap(6.h),
          ],

          // Phone
          if (client.phone.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.phone_outlined,
                  size: 16.sp,
                  color: colors.subText,
                ),
                Gap(8.w),
                Expanded(
                  child: Text(
                    client.phone,
                    style: AppTextStyles.font13Regular.copyWith(
                      color: colors.subText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Gap(6.h),
          ],

          // Address
          if (client.address.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16.sp,
                  color: colors.subText,
                ),
                Gap(8.w),
                Expanded(
                  child: Text(
                    client.address,
                    style: AppTextStyles.font13Regular.copyWith(
                      color: colors.subText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
