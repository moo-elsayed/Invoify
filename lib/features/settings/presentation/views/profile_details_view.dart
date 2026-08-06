import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/widgets/app_toasts.dart';
import 'package:invoify/core/widgets/custom_app_bar.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';
import 'package:invoify/features/auth/presentation/view_models/user_info_cubit/user_info_cubit.dart';
import 'package:invoify/features/settings/presentation/widgets/account_details_card.dart';
import 'package:invoify/features/settings/presentation/widgets/edit_business_name_card.dart';
import 'package:invoify/features/settings/presentation/widgets/profile_header_card.dart';
import 'package:toastification/toastification.dart';

class ProfileDetailsView extends StatefulWidget {
  const ProfileDetailsView({super.key});

  @override
  State<ProfileDetailsView> createState() => _ProfileDetailsViewState();
}

class _ProfileDetailsViewState extends State<ProfileDetailsView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _businessNameController;
  final ValueNotifier<bool> _isSavingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    context.read<UserInfoCubit>().getUserInfo();
    final user = context.read<UserInfoCubit>().currentUser;
    _businessNameController = TextEditingController(
      text: user?.businessName ?? '',
    );
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _isSavingNotifier.dispose();
    super.dispose();
  }

  void _onSavePressed(UserEntity? currentUser) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      final newName = _businessNameController.text.trim();
      if (newName == currentUser?.businessName) {
        return;
      }
      _isSavingNotifier.value = true;
      context.read<UserInfoCubit>().updateBusinessName(newName);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppBar(
      title: AppStrings.profileInformation,
      showArrowBack: true,
    ),
    body: SafeArea(
      child: BlocConsumer<UserInfoCubit, UserInfoState>(
        listener: (context, state) {
          if (state is UserUpdateSuccess) {
            _isSavingNotifier.value = false;
            AppToast.show(
              context: context,
              title: state.message,
              type: ToastificationType.success,
            );
          } else if (state is UserUpdateFailure) {
            _isSavingNotifier.value = false;
            AppToast.show(
              context: context,
              title: state.error,
              type: ToastificationType.error,
            );
          }
        },
        builder: (context, state) {
          final user = context.read<UserInfoCubit>().currentUser;
          // Format member since date
          String formattedDate = '';
          if (user?.createdAt != null) {
            formattedDate = DateFormat.yMMMMd(
              EasyLocalization.of(context)?.currentLocale?.languageCode,
            ).format(user!.createdAt!);
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Profile Card
                  ProfileHeaderCard(user: user),
                  Gap(24.h),

                  // Editable Business Name Section
                  EditBusinessNameCard(
                    controller: _businessNameController,
                    isSavingNotifier: _isSavingNotifier,
                    onSave: () => _onSavePressed(user),
                  ),
                  Gap(24.h),

                  // Read-only Account Details Section
                  AccountDetailsCard(user: user, formattedDate: formattedDate),
                  Gap(24.h),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
