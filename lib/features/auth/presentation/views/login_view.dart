import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/constants/app_assets.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/di.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/helpers/validator.dart';
import 'package:invoify/core/routing/routes.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/core/widgets/app_toasts.dart';
import 'package:invoify/core/widgets/custom_app_bar.dart';
import 'package:invoify/core/widgets/custom_keyboard_unfocus.dart';
import 'package:invoify/core/widgets/custom_material_button.dart';
import 'package:invoify/core/widgets/text_form_field_helper.dart';
import 'package:invoify/features/auth/presentation/view_models/signin_cubit/sign_in_cubit.dart';
import 'package:invoify/features/auth/presentation/view_models/social_sign_in_cubit/social_sign_in_cubit.dart';
import 'package:toastification/toastification.dart';
import '../args/login_args.dart';
import '../widgets/auth_redirect_text.dart';
import '../widgets/forget_password.dart';
import '../widgets/or_divider.dart';
import '../widgets/social_login_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, this.loginArgs});

  final LoginArgs? loginArgs;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _formKey = GlobalKey<FormState>();
    setState(() {});
  }

  Future<void> _navigate({
    required BuildContext context,
    required String routeName,
  }) async {
    final result = await context.pushNamed(routeName);
    if (result != null && result is LoginArgs) {
      _emailController.text = result.email;
      _passwordController.text = result.password;
    } else {
      _clearForm();
    }
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController(
      text: widget.loginArgs?.email ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.loginArgs?.password ?? '',
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => getIt<SignInCubit>()),
      BlocProvider(create: (context) => getIt<SocialSignInCubit>()),
    ],
    child: Scaffold(
      appBar: CustomAppBar(title: AppStrings.login, showArrowBack: false),
      body: CustomKeyboardUnfocus(
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
                          color: context.colors.surface,
                          border: Border.all(
                            color: context.colors.primary.withValues(alpha: 0.3),
                            width: 2.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: context.colors.primary.withValues(alpha: 0.1),
                              blurRadius: 16.r,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            AppAssets.appIcon,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Gap(16.h),
                      Text(
                        AppStrings.welcome,
                        style: AppTextStyles.font24Bold.copyWith(
                          color: context.colors.mainText,
                        ),
                      ),
                      Gap(6.h),
                      Text(
                        AppStrings.appTagline,
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
                        action: TextInputAction.next,
                      ),
                      Gap(16.h),
                      TextFormFieldHelper(
                        controller: _passwordController,
                        hint: AppStrings.password,
                        isPassword: true,
                        obscuringCharacter: '●',
                        keyboardType: TextInputType.visiblePassword,
                        onValidate: Validator.validatePassword,
                        action: TextInputAction.done,
                      ),
                      Gap(12.h),
                      ForgetPassword(
                        onTap: () async => await _navigate(
                          context: context,
                          routeName: Routes.forgetPasswordView,
                        ),
                      ),
                      Gap(28.h),
                      BlocConsumer<SignInCubit, SignInState>(
                        listener: (context, state) {
                          if (state is SignInSuccess) {
                            AppToast.show(
                              context: context,
                              title: AppStrings.welcome,
                              type: ToastificationType.success,
                            );
                            context.pushReplacementNamed(Routes.homeView);
                          }
                          if (state is SignInFailure) {
                            AppToast.show(
                              context: context,
                              title: state.message,
                              type: ToastificationType.error,
                            );
                          }
                        },
                        builder: (context, state) => CustomMaterialButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<SignInCubit>().signInWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                            }
                          },
                          maxWidth: true,
                          text: AppStrings.login,
                          textStyle: AppTextStyles.font16Bold.copyWith(
                            color: Colors.white,
                          ),
                          isLoading: state is SignInLoading,
                        ),
                      ),
                      Gap(28.h),
                      AuthRedirectText(
                        question: AppStrings.dontHaveAccount,
                        action: AppStrings.createAnAccount,
                        onTap: () async => await _navigate(
                          context: context,
                          routeName: Routes.registerView,
                        ),
                      ),
                      Gap(28.h),
                      const OrDivider(),
                      Gap(20.h),
                      BlocConsumer<SocialSignInCubit, SocialSignInState>(
                        listener: (context, state) {
                          if (state is GoogleSuccess) {
                            AppToast.show(
                              context: context,
                              title: AppStrings.welcome,
                              type: ToastificationType.success,
                            );
                            context.pushReplacementNamed(Routes.homeView);
                          }
                          if (state is GoogleFailure) {
                            AppToast.show(
                              context: context,
                              title: state.message,
                              type: ToastificationType.error,
                            );
                          }
                        },
                        buildWhen: (previous, current) =>
                            current is GoogleSuccess ||
                            current is GoogleFailure ||
                            current is GoogleLoading,
                        builder: (context, state) => SocialLoginButton(
                          onPressed: () =>
                              context.read<SocialSignInCubit>().googleSignIn(),
                          isLoading: state is GoogleLoading,
                          text: AppStrings.signInWithGoogle,
                          socialIcon: SvgPicture.asset(
                            AppAssets.googleIcon,
                            width: 22.w,
                            height: 22.h,
                          ),
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
