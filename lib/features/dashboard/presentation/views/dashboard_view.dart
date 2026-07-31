import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/widgets/custom_error_widget.dart';
import 'package:invoify/core/widgets/main_screen_header.dart';
import 'package:invoify/features/dashboard/presentation/view_models/dashboard_cubit/dashboard_cubit.dart';
import 'package:invoify/features/dashboard/presentation/view_models/dashboard_cubit/dashboard_state.dart';
import 'package:invoify/features/dashboard/presentation/widgets/dashboard_metrics_cards.dart';
import 'package:invoify/features/dashboard/presentation/widgets/dashboard_recent_invoices.dart';
import 'package:invoify/features/dashboard/presentation/widgets/dashboard_revenue_chart.dart';
import 'package:invoify/features/dashboard/presentation/widgets/dashboard_skeleton_loading.dart';
import 'package:invoify/features/dashboard/presentation/widgets/dashboard_status_chart.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: Padding(
      padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainScreenHeader(title: AppStrings.home),
          Gap(16.h),
          Expanded(
            child: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                final cubit = context.read<DashboardCubit>();

                if (state is DashboardLoading || state is DashboardInitial) {
                  return const DashboardSkeletonLoading();
                }

                if (state is DashboardFailure) {
                  return CustomErrorWidget(
                    error: state.error,
                    onRetry: () => cubit.loadDashboardData(forceRefresh: true),
                  );
                }

                if (state is DashboardSuccess) {
                  return RefreshIndicator(
                    onRefresh: () =>
                        cubit.loadDashboardData(forceRefresh: true),
                    color: context.colors.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16.h,
                        children: [
                          DashboardMetricsCards(
                            monthlyEarnings: state.monthlyEarnings,
                            totalOverdue: state.totalOverdue,
                            pendingAmount: state.pendingAmount,
                            activeClientsCount: state.totalClientsCount,
                          ),
                          DashboardRevenueChart(
                            monthlyRevenueMap: state.monthlyRevenueMap,
                          ),
                          DashboardStatusChart(
                            statusDistribution: state.statusDistribution,
                          ),
                          DashboardRecentInvoices(
                            recentInvoices: state.recentInvoices,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    ),
  );
}
