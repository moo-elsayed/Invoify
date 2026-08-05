import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoify/core/theming/app_theme.dart';

Widget createWidgetForTesting({
  required Widget child,
  ThemeMode themeMode = ThemeMode.light,
  NavigatorObserver? navigatorObserver,
}) => ScreenUtilInit(
  designSize: const Size(375, 812),
  minTextAdapt: true,
  splitScreenMode: true,
  builder: (context, _) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: themeMode,
    navigatorObservers: navigatorObserver != null ? [navigatorObserver] : [],
    home: child is Scaffold ? child : Scaffold(body: child),
  ),
);
