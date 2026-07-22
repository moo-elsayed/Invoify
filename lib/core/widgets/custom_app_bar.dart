import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.showArrowBack = true,
    this.onTap,
    this.actions,
  });

  final String title;
  final bool showArrowBack;
  final VoidCallback? onTap;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) => AppBar(
    title: Text(
      title,
      style: AppTextStyles.font18Bold.copyWith(color: context.colors.mainText),
    ),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    leading: showArrowBack
        ? IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.colors.mainText,
              size: 20.sp,
            ),
            onPressed: onTap ?? () => context.pop(),
          )
        : null,
    actions: actions,
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
