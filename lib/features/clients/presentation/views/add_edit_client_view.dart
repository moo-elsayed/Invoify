import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/widgets/app_toasts.dart';
import 'package:invoify/core/widgets/custom_app_bar.dart';
import 'package:invoify/core/widgets/custom_keyboard_unfocus.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/presentation/view_models/clients_cubit/clients_cubit.dart';
import 'package:invoify/features/clients/presentation/widgets/client_form_card.dart';
import 'package:invoify/features/clients/presentation/widgets/client_form_submit_button.dart';
import 'package:toastification/toastification.dart';

class AddEditClientView extends StatefulWidget {
  const AddEditClientView({super.key, this.client});

  final ClientEntity? client;

  @override
  State<AddEditClientView> createState() => _AddEditClientViewState();
}

class _AddEditClientViewState extends State<AddEditClientView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(false);

  bool get _isEditing => widget.client != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client?.name ?? '');
    _emailController = TextEditingController(text: widget.client?.email ?? '');
    _phoneController = TextEditingController(text: widget.client?.phone ?? '');
    _addressController = TextEditingController(
      text: widget.client?.address ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _isLoadingNotifier.dispose();
    super.dispose();
  }

  void _onSavePressed(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      _isLoadingNotifier.value = true;

      if (_isEditing) {
        final updatedClient = widget.client!.copyWith(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
        );
        context.read<ClientsCubit>().updateClient(updatedClient);
      } else {
        context.read<ClientsCubit>().addClient(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => CustomKeyboardUnfocus(
    child: Scaffold(
      appBar: CustomAppBar(
        title: _isEditing ? AppStrings.editClient : AppStrings.addClient,
        showArrowBack: true,
      ),
      body: SafeArea(
        child: BlocListener<ClientsCubit, ClientsState>(
          listener: (context, state) {
            if (state is ClientActionSuccess) {
              _isLoadingNotifier.value = false;
              AppToast.show(
                context: context,
                title: state.message,
                type: ToastificationType.success,
              );
              context.pop(true);
            } else if (state is ClientActionFailure) {
              _isLoadingNotifier.value = false;
              AppToast.show(
                context: context,
                title: state.error,
                type: ToastificationType.error,
              );
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 24.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Structured Inputs Card
                  ClientFormCard(
                    nameController: _nameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    addressController: _addressController,
                  ),

                  // Submit Button
                  ClientFormSubmitButton(
                    isEditing: _isEditing,
                    isLoadingNotifier: _isLoadingNotifier,
                    onPressed: () => _onSavePressed(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
