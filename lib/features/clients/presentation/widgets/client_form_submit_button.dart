import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/widgets/custom_material_button.dart';

class ClientFormSubmitButton extends StatelessWidget {
  const ClientFormSubmitButton({
    super.key,
    required this.isEditing,
    required this.isLoadingNotifier,
    required this.onPressed,
  });

  final bool isEditing;
  final ValueNotifier<bool> isLoadingNotifier;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
    valueListenable: isLoadingNotifier,
    builder: (context, isLoading, child) => CustomMaterialButton(
      onPressed: onPressed,
      text: isEditing ? AppStrings.saveChanges : AppStrings.addClient,
      isLoading: isLoading,
      maxWidth: true,
      borderRadius: BorderRadius.circular(12.r),
    ),
  );
}
