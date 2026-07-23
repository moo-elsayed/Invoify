import 'package:flutter/material.dart';

class NavBarItem {
  const NavBarItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData? activeIcon;
  final String label;
}
