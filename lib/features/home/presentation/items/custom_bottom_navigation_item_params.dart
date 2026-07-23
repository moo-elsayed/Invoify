import 'package:flutter/material.dart';

class CustomBottomNavigationItemParams {
  const CustomBottomNavigationItemParams({
    required this.isSelected,
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.onTap,
  });

  final bool isSelected;
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final VoidCallback onTap;
}
