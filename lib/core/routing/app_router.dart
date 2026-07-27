import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoify/core/helpers/di.dart';
import 'package:invoify/features/auth/presentation/args/login_args.dart';
import 'package:invoify/features/auth/presentation/views/forget_password_view.dart';
import 'package:invoify/features/auth/presentation/views/login_view.dart';
import 'package:invoify/features/auth/presentation/views/register_view.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/presentation/args/add_edit_client_args.dart';
import 'package:invoify/features/clients/presentation/view_models/clients_cubit/clients_cubit.dart';
import 'package:invoify/features/clients/presentation/views/add_edit_client_view.dart';
import 'package:invoify/features/home/presentation/views/main_view.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/presentation/args/add_edit_invoice_args.dart';
import 'package:invoify/features/invoices/presentation/args/invoice_details_args.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';
import 'package:invoify/features/invoices/presentation/views/add_edit_invoice_view.dart';
import 'package:invoify/features/invoices/presentation/views/invoice_details_view.dart';
import 'package:invoify/features/settings/presentation/views/profile_details_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/splash/presentation/views/animated_splash_view.dart';
import 'routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  RouteSettings? _currentSettings;

  Route? generateRoute(RouteSettings settings) {
    _currentSettings = settings;

    switch (settings.name) {
      case Routes.splashView:
        return _route(const AnimatedSplashView());
      case Routes.onboardingView:
        return _route(const OnboardingView());
      case Routes.loginView:
        return _route(LoginView(loginArgs: settings.arguments as LoginArgs?));
      case Routes.registerView:
        return _route(const RegisterView());
      case Routes.forgetPasswordView:
        return _route(const ForgetPasswordView());
      case Routes.homeView:
        return _route(const MainView());
      case Routes.profileDetailsView:
        return _route(const ProfileDetailsView());
      case Routes.addEditClientView:
        final args = settings.arguments;
        if (args is AddEditClientArgs) {
          return _route(
            BlocProvider.value(
              value: args.cubit,
              child: AddEditClientView(client: args.client),
            ),
          );
        }
        return _route(
          BlocProvider(
            create: (context) => getIt<ClientsCubit>(),
            child: AddEditClientView(client: args as ClientEntity?),
          ),
        );
      case Routes.addEditInvoiceView:
        final args = settings.arguments;
        if (args is AddEditInvoiceArgs) {
          if (args.cubit != null) {
            return _route(
              BlocProvider.value(
                value: args.cubit!,
                child: AddEditInvoiceView(invoice: args.invoice),
              ),
            );
          }
          return _route(
            BlocProvider(
              create: (context) => getIt<InvoicesCubit>(),
              child: AddEditInvoiceView(invoice: args.invoice),
            ),
          );
        }
        return _route(
          BlocProvider(
            create: (context) => getIt<InvoicesCubit>(),
            child: AddEditInvoiceView(invoice: args as InvoiceEntity?),
          ),
        );
      case Routes.invoiceDetailsView:
        final args = settings.arguments;
        if (args is InvoiceDetailsArgs) {
          return _route(
            BlocProvider.value(
              value: args.cubit,
              child: InvoiceDetailsView(invoice: args.invoice),
            ),
          );
        } else if (args is InvoiceEntity) {
          return _route(
            BlocProvider(
              create: (context) => getIt<InvoicesCubit>(),
              child: InvoiceDetailsView(invoice: args),
            ),
          );
        }
        return null;
      default:
        return null;
    }
  }

  PageRouteBuilder<dynamic> _route(Widget view) => PageRouteBuilder(
    settings: _currentSettings,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, animation, secondaryAnimation) => view,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideTween = Tween<Offset>(
        begin: const Offset(0.08, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));

      final fadeTween = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeOutCubic));

      return FadeTransition(
        opacity: animation.drive(fadeTween),
        child: SlideTransition(
          position: animation.drive(slideTween),
          child: child,
        ),
      );
    },
  );
}
