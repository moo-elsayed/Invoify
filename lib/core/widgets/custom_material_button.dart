import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoify/core/theming/app_palette.dart';
import '../helpers/extensions.dart';
import '../theming/app_text_styles.dart';

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.maxWidth = false,
    this.isLoading = false,
    this.isTrailingIcon = true,
    this.padding,
    this.backgroundColor,
    this.side,
    this.borderRadius,
    this.loadingIndicatorColor,
    this.textColor,
    this.icon,
  });

  final VoidCallback onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? loadingIndicatorColor;
  final Color? textColor;
  final bool maxWidth;
  final bool isLoading;
  final bool isTrailingIcon;
  final TextStyle? textStyle;
  final BorderSide? side;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      textAlign: TextAlign.center,
      style:
          (textStyle ??
                  AppTextStyles.font16Bold.copyWith(
                    color: textColor ?? AppPalette.white,
                  ))
              .copyWith(height: 1.2),
    );

    return MaterialButton(
      color: backgroundColor ?? context.colors.primary,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      minWidth: maxWidth ? double.infinity : null,
      elevation: 0,
      highlightElevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(8.r),
        side: side ?? BorderSide.none,
      ),
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      onPressed: onPressed,
      child: isLoading
          ? CupertinoActivityIndicator(
              color: loadingIndicatorColor ?? AppPalette.white,
            )
          : icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8.w,
              children: isTrailingIcon
                  ? [textWidget, icon!]
                  : [icon!, textWidget],
            )
          : textWidget,
    );
  }
}
