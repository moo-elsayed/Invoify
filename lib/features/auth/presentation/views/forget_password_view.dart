import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/di.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/helpers/validator.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/core/widgets/app_toasts.dart';
import 'package:invoify/core/widgets/custom_app_bar.dart';
import 'package:invoify/core/widgets/custom_keyboard_unfocus.dart';
import 'package:invoify/core/widgets/custom_material_button.dart';
import 'package:invoify/core/widgets/text_form_field_helper.dart';
import 'package:invoify/features/auth/presentation/view_models/forget_password_cubit/forget_password_cubit.dart';
import 'package:toastification/toastification.dart';
import '../args/login_args.dart';
import '../widgets/custom_dialog.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  late TextEditingController _emailController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppBar(
      title: AppStrings.passwordReset,
      showArrowBack: true,
      onTap: () => context.pop(),
    ),
    body: BlocProvider(
      create: (context) => getIt<ForgetPasswordCubit>(),
      child: CustomKeyboardUnfocus(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gap(16.h),
                FadeInDown(
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    children: [
                      Container(
                        width: 72.r,
                        height: 72.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.colors.primary.withValues(alpha: 0.1),
                          border: Border.all(
                            color: context.colors.primary.withValues(
                              alpha: 0.3,
                            ),
                            width: 2.w,
                          ),
                        ),
                        child: Icon(
                          Icons.lock_reset_rounded,
                          size: 34.sp,
                          color: context.colors.primary,
                        ),
                      ),
                      Gap(16.h),
                      Text(
                        AppStrings.passwordReset,
                        style: AppTextStyles.font24Bold.copyWith(
                          color: context.colors.mainText,
                        ),
                      ),
                      Gap(8.h),
                      Text(
                        AppStrings.sendEmailResetLink,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.font14Regular.copyWith(
                          color: context.colors.subText,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(32.h),
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child: Column(
                    children: [
                      TextFormFieldHelper(
                        controller: _emailController,
                        hint: AppStrings.email,
                        keyboardType: TextInputType.emailAddress,
                        onValidate: Validator.validateEmail,
                        action: TextInputAction.done,
                      ),
                      Gap(28.h),
                      BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
                        listener: (context, state) {
                          if (state is ForgetPasswordSuccess) {
                            AppToast.show(
                              context: context,
                              title: AppStrings.emailSent,
                              type: ToastificationType.success,
                            );
                            showCupertinoDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                text: AppStrings.emailSentToReset,
                                onPressed: () {
                                  context.pop();
                                  final loginArgs = LoginArgs(
                                    email: _emailController.text.trim(),
                                    password: '',
                                  );
                                  context.pop(loginArgs);
                                },
                              ),
                            );
                          }
                          if (state is ForgetPasswordFailure) {
                            AppToast.show(
                              context: context,
                              title: state.errorMessage,
                              type: ToastificationType.error,
                            );
                          }
                        },
                        builder: (context, state) => CustomMaterialButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<ForgetPasswordCubit>()
                                  .forgetPassword(_emailController.text);
                            }
                          },
                          maxWidth: true,
                          text: AppStrings.sendPasswordResetLink,
                          textStyle: AppTextStyles.font16Bold.copyWith(
                            color: Colors.white,
                          ),
                          isLoading: state is ForgetPasswordLoading,
                        ),
                      ),
                      Gap(24.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
