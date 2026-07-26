import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/di.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/routing/routes.dart';
import 'package:invoify/core/widgets/app_toasts.dart';
import 'package:invoify/core/widgets/custom_error_widget.dart';
import 'package:invoify/core/widgets/main_screen_header.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_state.dart';
import 'package:invoify/features/invoices/presentation/widgets/empty_invoices_widget.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_card.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_skeleton_list.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_status_tabs.dart';
import 'package:toastification/toastification.dart';

class InvoicesView extends StatefulWidget {
  const InvoicesView({super.key});

  @override
  State<InvoicesView> createState() => _InvoicesViewState();
}

class _InvoicesViewState extends State<InvoicesView> {
  final ValueNotifier<InvoiceStatus?> _selectedStatusNotifier =
      ValueNotifier<InvoiceStatus?>(null);

  @override
  void dispose() {
    _selectedStatusNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => getIt<InvoicesCubit>()..getInvoices(),
    child: SafeArea(
      child: BlocConsumer<InvoicesCubit, InvoicesState>(
        listener: (context, state) {
          if (ModalRoute.of(context)?.isCurrent != true) return;
          if (state is InvoiceActionSuccess) {
            AppToast.show(
              context: context,
              title: state.message,
              type: ToastificationType.success,
            );
          } else if (state is InvoicesFailure) {
            AppToast.show(
              context: context,
              title: state.error,
              type: ToastificationType.error,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<InvoicesCubit>();
          final allInvoices = cubit.allInvoices;

          return Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Screen Header & Action Button (with 16.w horizontal padding)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: MainScreenHeader(
                    title: AppStrings.invoices,
                    action: HeaderActionButton(
                      label: AppStrings.createInvoice,
                      icon: Icons.add_rounded,
                      onTap: () => context
                          .pushNamed(Routes.createInvoiceView)
                          .then((isUpdated) {
                            if (isUpdated == true) {
                              cubit.getInvoices();
                            }
                          }),
                    ),
                  ),
                ),
                Gap(16.h),

                // ValueListenableBuilder for reactive status filtering without setState
                Expanded(
                  child: ValueListenableBuilder<InvoiceStatus?>(
                    valueListenable: _selectedStatusNotifier,
                    builder: (context, selectedStatus, child) {
                      List<InvoiceEntity> filteredList = [];
                      if (selectedStatus == null) {
                        filteredList = List.from(allInvoices);
                      } else {
                        filteredList = allInvoices
                            .where((inv) => inv.status == selectedStatus)
                            .toList();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status Filter Tabs (Scrolls edge-to-edge full width)
                          InvoiceStatusTabs(
                            selectedStatus: selectedStatus,
                            allInvoices: allInvoices,
                            onStatusSelected: (status) {
                              _selectedStatusNotifier.value = status;
                            },
                          ),
                          Gap(16.h),

                          // Invoices Content Area
                          Expanded(
                            child: state is InvoicesLoading
                                ? const InvoiceSkeletonList()
                                : state is InvoicesFailure
                                ? CustomErrorWidget(
                                    error: state.error,
                                    onRetry: () => cubit.getInvoices(),
                                  )
                                : filteredList.isEmpty
                                ? EmptyInvoicesWidget(
                                    isFiltered: selectedStatus != null,
                                  )
                                : RefreshIndicator(
                                    onRefresh: () => cubit.getInvoices(),
                                    color: context.colors.primary,
                                    child: ListView.separated(
                                      padding: EdgeInsets.only(
                                        left: 16.w,
                                        right: 16.w,
                                        bottom: 90.h,
                                      ),
                                      itemCount: filteredList.length,
                                      separatorBuilder: (context, index) =>
                                          Gap(12.h),
                                      itemBuilder: (context, index) {
                                        final invoice = filteredList[index];
                                        return InvoiceCard(
                                          invoice: invoice,
                                          onDelete: () => cubit.deleteInvoice(
                                            invoice.invoiceId,
                                          ),
                                          onStatusChanged: (newStatus) {
                                            final updated = invoice.copyWith(
                                              status: newStatus,
                                            );
                                            cubit.updateInvoice(updated);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                          ),
                        ],
                      );
                    },
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
