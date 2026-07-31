import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/core/widgets/bottom_sheet_handle.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/presentation/view_models/clients_cubit/clients_cubit.dart';
import 'package:invoify/features/invoices/presentation/widgets/client_picker_bottom_sheet_tile.dart';
import 'package:invoify/features/invoices/presentation/widgets/client_picker_skeleton_list.dart';

class ClientPickerBottomSheet extends StatelessWidget {
  const ClientPickerBottomSheet({
    super.key,
    required this.selectedClient,
    required this.onClientSelected,
  });

  final ClientEntity? selectedClient;
  final ValueChanged<ClientEntity> onClientSelected;

  static void show({
    required BuildContext context,
    required ClientEntity? selectedClient,
    required ValueChanged<ClientEntity> onClientSelected,
  }) {
    final clientsCubit = context.read<ClientsCubit>();
    clientsCubit.getClients();

    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) => BlocProvider.value(
        value: clientsCubit,
        child: SafeArea(
          child: ClientPickerBottomSheet(
            selectedClient: selectedClient,
            onClientSelected: onClientSelected,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final clientsCubit = context.read<ClientsCubit>();

    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: BottomSheetHandle()),
          Gap(16.h),
          Text(
            AppStrings.selectClient,
            style: AppTextStyles.font18Bold.copyWith(color: colors.mainText),
          ),
          Gap(16.h),
          Expanded(
            child: BlocBuilder<ClientsCubit, ClientsState>(
              builder: (context, state) {
                final clients = clientsCubit.allClients;

                if (state is ClientsLoading && clients.isEmpty) {
                  return const ClientPickerSkeletonList();
                }

                if (clients.isEmpty) {
                  return Center(
                    child: Text(
                      AppStrings.noClientsAvailable,
                      style: AppTextStyles.font14Medium.copyWith(
                        color: colors.subText,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: clients.length,
                  separatorBuilder: (context, index) => Gap(10.h),
                  itemBuilder: (context, index) {
                    final client = clients[index];
                    final isSelected =
                        selectedClient?.clientId == client.clientId;

                    return ClientPickerBottomSheetTile(
                      client: client,
                      isSelected: isSelected,
                      onTap: () {
                        onClientSelected(client);
                        context.pop();
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
