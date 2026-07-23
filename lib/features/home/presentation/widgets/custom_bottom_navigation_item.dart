import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/features/home/presentation/items/custom_bottom_navigation_item_params.dart';

class CustomBottomNavigationItem extends StatelessWidget {
  const CustomBottomNavigationItem({super.key, required this.params});

  final CustomBottomNavigationItemParams params;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final activeColor = colors.primary;
    final inactiveColor = colors.subText;
    final displayIcon = (params.isSelected && params.activeIcon != null)
        ? params.activeIcon!
        : params.icon;

    return GestureDetector(
      onTap: params.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: params.isSelected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: params.isSelected
                ? colors.primary.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: params.isSelected
                  ? colors.primary.withValues(alpha: 0.3)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                displayIcon,
                color: params.isSelected ? activeColor : inactiveColor,
                size: 22.sp,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                child: params.isSelected
                    ? Row(
                        children: [
                          SizedBox(width: 6.w),
                          AnimatedOpacity(
                            opacity: params.isSelected ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              params.label,
                              style: AppTextStyles.font12Bold.copyWith(
                                color: activeColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
