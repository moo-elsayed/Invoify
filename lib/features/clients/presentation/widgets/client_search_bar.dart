import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/widgets/text_form_field_helper.dart';

class ClientSearchBar extends StatelessWidget {
  const ClientSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TextFormFieldHelper(
      controller: controller,
      hint: AppStrings.searchClients,
      prefixIcon: Icon(
        Icons.search_rounded,
        color: colors.subText,
        size: 22.sp,
      ),
      suffixWidget: controller.text.isNotEmpty
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                controller.clear();
                onChanged('');
              },
              child: Icon(
                Icons.clear_rounded,
                color: colors.subText,
                size: 18.sp,
              ),
            )
          : null,
      onChanged: (value) => onChanged(value ?? ''),
    );
  }
}
