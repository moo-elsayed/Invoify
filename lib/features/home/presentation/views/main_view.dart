import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/di.dart';
import 'package:invoify/core/helpers/notification_router.dart';
import 'package:invoify/features/clients/presentation/view_models/clients_cubit/clients_cubit.dart';
import 'package:invoify/features/clients/presentation/views/clients_view.dart';
import 'package:invoify/features/dashboard/presentation/view_models/dashboard_cubit/dashboard_cubit.dart';
import 'package:invoify/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:invoify/features/home/presentation/items/nav_bar_item.dart';
import 'package:invoify/features/home/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_state.dart';
import 'package:invoify/features/invoices/presentation/views/invoices_view.dart';
import 'package:invoify/features/settings/presentation/views/settings_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationRouter.markAppAsReady();
    });
  }

  final List<Widget> _screens = const [
    DashboardView(),
    InvoicesView(),
    ClientsView(),
    SettingsView(),
  ];

  List<NavBarItem> get _navItems => [
        NavBarItem(
          icon: CupertinoIcons.square_grid_2x2,
          activeIcon: CupertinoIcons.square_grid_2x2_fill,
          label: AppStrings.home,
        ),
        NavBarItem(
          icon: CupertinoIcons.doc_text,
          activeIcon: CupertinoIcons.doc_text_fill,
          label: AppStrings.invoices,
        ),
        NavBarItem(
          icon: CupertinoIcons.person_2,
          activeIcon: CupertinoIcons.person_2_fill,
          label: AppStrings.clients,
        ),
        NavBarItem(
          icon: CupertinoIcons.gear_alt,
          activeIcon: CupertinoIcons.gear_alt_fill,
          label: AppStrings.settings,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    // Listen to locale changes so nav items and screens rebuild dynamically
    final _ = context.locale;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<DashboardCubit>()..loadDashboardData(),
        ),
        BlocProvider(
          create: (context) => getIt<InvoicesCubit>()..getInvoices(),
        ),
        BlocProvider(
          create: (context) => getIt<ClientsCubit>()..getClients(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<InvoicesCubit, InvoicesState>(
            listener: (context, state) {
              if (state is InvoiceActionSuccess || state is InvoicesSuccess) {
                final invoices = context.read<InvoicesCubit>().allInvoices;
                context.read<DashboardCubit>().updateFromInvoices(invoices);
              }
            },
          ),
          BlocListener<ClientsCubit, ClientsState>(
            listener: (context, state) {
              if (state is ClientActionSuccess || state is ClientsSuccess) {
                final count = context.read<ClientsCubit>().allClients.length;
                context.read<DashboardCubit>().updateClientsCount(count);
              }
            },
          ),
        ],
        child: Scaffold(
          extendBody: true,
          body: IndexedStack(index: _currentIndex, children: _screens),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: _currentIndex,
            items: _navItems,
            onTabSelected: (index) => setState(() => _currentIndex = index),
          ),
        ),
      ),
    );
  }
}
