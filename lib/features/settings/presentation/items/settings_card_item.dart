import 'package:flutter/material.dart';

class SettingsCardItem {
  const SettingsCardItem({
    required this.icon,
    required this.title,
    this.trailingText,
    this.trailingWidget,
    this.showArrow = true,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? trailingText;
  final Widget? trailingWidget;
  final bool showArrow;
  final VoidCallback? onTap;
}
