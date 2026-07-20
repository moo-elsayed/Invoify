import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  static void show({
    required BuildContext context,
    required String title,
    String? description,
    required ToastificationType type,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    toastification.showCustom(
      context: context,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 2, milliseconds: 500),
      animationBuilder: (context, animation, alignment, child) =>
          FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, -0.5),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
              child: child,
            ),
          ),
      builder: (BuildContext context, ToastificationItem holder) => Material(
        type: MaterialType.transparency,
        child: GestureDetector(
          onTap: () {
            toastification.dismiss(holder);
            if (onTap != null) {
              onTap();
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                  spreadRadius: 2,
                ),
              ],
              border: Border(
                left: !context.isRTL
                    ? BorderSide(color: type.getColor(context), width: 4.w)
                    : BorderSide.none,
                right: context.isRTL
                    ? BorderSide(color: type.getColor(context), width: 4.w)
                    : BorderSide.none,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon ?? type.stateIcon,
                  color: type.getColor(context),
                  size: 28.sp,
                ),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.font16Bold.copyWith(
                          color: context.colors.mainText,
                          height: 1.2,
                        ),
                      ),
                      if (description != null && description.isNotEmpty) ...[
                        Gap(4.h),
                        Text(
                          description,
                          style: AppTextStyles.font14Regular.copyWith(
                            color: context.colors.bodyText,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Gap(8.w),
                InkWell(
                  onTap: () => toastification.dismiss(holder),
                  child: Icon(
                    Icons.close,
                    color: context.colors.subText,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
