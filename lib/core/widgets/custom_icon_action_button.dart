import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomIconActionButton extends StatelessWidget {
  const CustomIconActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.color,
    this.backgroundColor,
    this.iconSize,
    this.padding,
    this.borderRadius,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color? backgroundColor;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(10.r);
    final effectiveBackgroundColor =
        backgroundColor ?? color.withValues(alpha: 0.1);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: effectiveBorderRadius,
        child: Container(
          padding: padding ?? EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: effectiveBorderRadius,
          ),
          child: Icon(icon, size: iconSize ?? 18.sp, color: color),
        ),
      ),
    );
  }
}
