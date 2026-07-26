import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/invoices/presentation/widgets/client_picker_bottom_sheet.dart';

class InvoiceClientPicker extends StatelessWidget {
  const InvoiceClientPicker({
    super.key,
    required this.selectedClient,
    required this.onClientSelected,
  });

  final ClientEntity? selectedClient;
  final ValueChanged<ClientEntity> onClientSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.border),
      ),
      child: InkWell(
        onTap: () => ClientPickerBottomSheet.show(
          context: context,
          selectedClient: selectedClient,
          onClientSelected: onClientSelected,
        ),
        borderRadius: BorderRadius.circular(12.r),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.person_pin_rounded,
                color: colors.primary,
                size: 22.sp,
              ),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.selectClient,
                    style: AppTextStyles.font12Medium.copyWith(
                      color: colors.subText,
                    ),
                  ),
                  Gap(2.h),
                  Text(
                    selectedClient != null && selectedClient!.name.isNotEmpty
                        ? selectedClient!.name
                        : AppStrings.pleaseSelectClient,
                    style: AppTextStyles.font14Bold.copyWith(
                      color: selectedClient != null
                          ? colors.mainText
                          : colors.subText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colors.subText,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
