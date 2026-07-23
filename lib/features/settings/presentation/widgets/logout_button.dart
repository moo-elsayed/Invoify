import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/di.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/routing/routes.dart';
import 'package:invoify/core/widgets/app_toasts.dart';
import 'package:invoify/core/widgets/custom_confirmation_dialog.dart';
import 'package:invoify/core/widgets/custom_material_button.dart';
import 'package:invoify/features/auth/presentation/view_models/signout_cubit/sign_out_cubit.dart';
import 'package:toastification/toastification.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void _onSignOutTap(BuildContext context, SignOutCubit signOutCubit) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CustomConfirmationDialog(
        title: AppStrings.signOut,
        subtitle: AppStrings.signOutConfirmation,
        textConfirmButton: AppStrings.signOut,
        onConfirm: () {
          dialogContext.pop();
          signOutCubit.signOut();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocProvider(
      create: (context) => getIt<SignOutCubit>(),
      child: BlocConsumer<SignOutCubit, SignOutState>(
        listener: (context, signOutState) {
          if (signOutState is SignOutSuccess) {
            context.pushNamedAndRemoveUntil(
              Routes.loginView,
              predicate: (route) => false,
            );
          } else if (signOutState is SignOutFailure) {
            AppToast.show(
              context: context,
              title: signOutState.errorMessage,
              type: ToastificationType.error,
            );
          }
        },
        builder: (context, signOutState) => CustomMaterialButton(
          onPressed: () => _onSignOutTap(context, context.read<SignOutCubit>()),
          text: AppStrings.signOut,
          isLoading: signOutState is SignOutLoading,
          loadingIndicatorColor: colors.error,
          backgroundColor: colors.error.withValues(alpha: 0.1),
          textColor: colors.error,
          side: BorderSide(
            color: colors.error.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
