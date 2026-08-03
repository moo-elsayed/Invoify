import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/routing/routes.dart';
import 'package:invoify/core/widgets/app_toasts.dart';
import 'package:invoify/core/widgets/custom_error_widget.dart';
import 'package:invoify/core/widgets/custom_keyboard_unfocus.dart';
import 'package:invoify/core/widgets/main_screen_header.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/presentation/args/add_edit_client_args.dart';
import 'package:invoify/features/clients/presentation/view_models/clients_cubit/clients_cubit.dart';
import 'package:invoify/features/clients/presentation/widgets/client_card.dart';
import 'package:invoify/features/clients/presentation/widgets/client_search_bar.dart';
import 'package:invoify/features/clients/presentation/widgets/client_skeleton_list.dart';
import 'package:invoify/features/clients/presentation/widgets/empty_clients_widget.dart';
import 'package:toastification/toastification.dart';

class ClientsView extends StatefulWidget {
  const ClientsView({super.key});

  @override
  State<ClientsView> createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomKeyboardUnfocus(
    child: SafeArea(
      bottom: false,
      child: BlocConsumer<ClientsCubit, ClientsState>(
        listener: (context, state) {
          if (ModalRoute.of(context)?.isCurrent != true) return;
          if (state is ClientActionSuccess) {
            AppToast.show(
              context: context,
              title: state.message,
              type: ToastificationType.success,
            );
          } else if (state is ClientActionFailure) {
            AppToast.show(
              context: context,
              title: state.error,
              type: ToastificationType.error,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ClientsCubit>();

          List<ClientEntity> filteredList = [];
          final bool isSearching = _searchController.text.trim().isNotEmpty;

          if (state is ClientsSuccess) {
            filteredList = state.filteredClients;
          } else {
            filteredList = cubit.allClients;
          }

          return Padding(
            padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 12.h),
            child: Column(
              children: [
                MainScreenHeader(
                  title: AppStrings.clients,
                  action: HeaderActionButton(
                    label: AppStrings.addClient,
                    icon: Icons.person_add_alt_1_rounded,
                    onTap: () => context
                        .pushNamed(
                          Routes.addEditClientView,
                          arguments: AddEditClientArgs(
                            client: null,
                            cubit: cubit,
                          ),
                        )
                        .then((isUpdated) {
                          if (isUpdated == true) {
                            cubit.getClients();
                          }
                        }),
                  ),
                ),
                Gap(16.h),
                // Search Bar Widget
                ClientSearchBar(
                  controller: _searchController,
                  onChanged: (query) => cubit.searchClients(query),
                ),
                Gap(16.h),

                // Content Body (Skeleton / Error / Empty / List)
                Expanded(
                  child: state is ClientsLoading
                      ? const ClientSkeletonList()
                      : state is ClientsFailure
                      ? CustomErrorWidget(
                          error: state.error,
                          onRetry: () => cubit.getClients(),
                        )
                      : filteredList.isEmpty
                      ? EmptyClientsWidget(isSearching: isSearching)
                      : RefreshIndicator(
                          onRefresh: () => cubit.getClients(),
                          color: context.colors.primary,
                          child: ListView.separated(
                            padding: EdgeInsets.only(bottom: 90.h),
                            itemCount: filteredList.length,
                            separatorBuilder: (context, index) => Gap(12.h),
                            itemBuilder: (context, index) {
                              final client = filteredList[index];
                              return ClientCard(
                                client: client,
                                onEdit: () {
                                  context
                                      .pushNamed(
                                        Routes.addEditClientView,
                                        arguments: AddEditClientArgs(
                                          client: client,
                                          cubit: cubit,
                                        ),
                                      )
                                      .then((isUpdated) {
                                        if (isUpdated == true) {
                                          cubit.getClients();
                                        }
                                      });
                                },
                                onDelete: () =>
                                    cubit.deleteClient(client.clientId),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
