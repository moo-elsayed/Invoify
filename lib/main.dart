import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/helpers/app_logger.dart';
import 'core/helpers/di.dart';
import 'core/routing/app_router.dart';
import 'firebase_options.dart';
import 'invoify.dart';

void main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Future.wait([
    EasyLocalization.ensureInitialized(),
    _initFirebase(),
    setupGetIt(),
    ScreenUtil.ensureScreenSize(),
  ]);

  final appRouter = AppRouter();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: Invoify(appRouter: appRouter),
    ),
  );
}

Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, stackTrace) {
    AppLogger.error(
      'Firebase initialization error: $e',
      stackTrace: stackTrace,
    );
  }
}
