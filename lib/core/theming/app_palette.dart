import 'package:flutter/material.dart';

class AppPalette {
  AppPalette._();

  // --- Brand Colors (Derived from App Icon #4B9FE1) ---
  static const Color appIconBlue = Color(0xff4B9FE1); // لون الأيقونة الأساسي
  static const Color primaryBlueLight = Color(0xff2563EB); // أزرق كهربائي حيوي ومريح للعين
  static const Color primaryBlueDark = Color(0xff60A5FA); // أزرق ساطع عالي التباين للوضع الداكن
  static const Color secondaryCyan = Color(0xff0EA5E9); // لون ثانوي سماوي

  // --- Accent & Status Colors ---
  static const Color accentGreen = Color(0xff10B981); // Emerald Green
  static const Color starYellow = Color(0xffF59E0B);
  static const Color error = Color(0xffEF4444);
  static const Color success = Color(0xff10B981);
  static const Color warning = Color(0xffF59E0B);
  static const Color info = Color(0xff3B82F6);

  // --- Common Colors ---
  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xff000000);

  // --- Backgrounds & Surfaces (Light Theme) ---
  static const Color bgLight = Color(0xffF1F5F9); // Slate 100 (خلفية متباينة للأكارت البيضاء)
  static const Color surfaceLight = Color(0xffFFFFFF); // White Surface
  static const Color borderLight = Color(0xffE2E8F0); // Slate 200

  // --- Backgrounds & Surfaces (Dark Theme) ---
  static const Color bgDark = Color(0xff0F172A); // Midnight Dark Slate 900
  static const Color surfaceDark = Color(0xff1E293B); // Slate 800 Container
  static const Color borderDark = Color(0xff334155); // Slate 700

  // --- Text Colors (Light Theme) ---
  static const Color textMainLight = Color(0xff0F172A); // Deep Slate 900 (عالي التباين)
  static const Color textBodyLight = Color(0xff334155); // Slate 700
  static const Color textSubLight = Color(0xff64748B); // Slate 500

  // --- Text Colors (Dark Theme) ---
  static const Color textMainDark = Color(0xffF8FAFC); // Crisp Slate 50 (عالي التباين)
  static const Color textBodyDark = Color(0xffCBD5E1); // Slate 300
  static const Color textSubDark = Color(0xff94A3B8); // Slate 400

  // --- Tags & Status Chips ---
  static const Color tagConfirmedBgLight = Color(0xffEFF6FF);
  static const Color tagConfirmedTextLight = Color(0xff1D4ED8);
  static const Color tagInProgressBgLight = Color(0xffECFDF5);
  static const Color tagInProgressTextLight = Color(0xff047857);

  static const Color tagConfirmedBgDark = Color(0x263B82F6);
  static const Color tagConfirmedTextDark = Color(0xff93C5FD);
  static const Color tagInProgressBgDark = Color(0x2610B981);
  static const Color tagInProgressTextDark = Color(0xff6EE7B7);
}
