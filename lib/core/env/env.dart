import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  // Android Firebase
  @EnviedField(varName: 'ANDROID_FIREBASE_API_KEY', obfuscate: true)
  static final String androidApiKey = _Env.androidApiKey;

  @EnviedField(varName: 'ANDROID_FIREBASE_APP_ID', obfuscate: true)
  static final String androidAppId = _Env.androidAppId;

  @EnviedField(varName: 'ANDROID_FIREBASE_MESSAGING_SENDER_ID', obfuscate: true)
  static final String androidMessagingSenderId = _Env.androidMessagingSenderId;

  @EnviedField(varName: 'ANDROID_FIREBASE_PROJECT_ID', obfuscate: true)
  static final String androidProjectId = _Env.androidProjectId;

  @EnviedField(varName: 'ANDROID_FIREBASE_STORAGE_BUCKET', obfuscate: true)
  static final String androidStorageBucket = _Env.androidStorageBucket;

  // iOS Firebase
  @EnviedField(varName: 'IOS_FIREBASE_API_KEY', obfuscate: true)
  static final String iosApiKey = _Env.iosApiKey;

  @EnviedField(varName: 'IOS_FIREBASE_APP_ID', obfuscate: true)
  static final String iosAppId = _Env.iosAppId;

  @EnviedField(varName: 'IOS_FIREBASE_MESSAGING_SENDER_ID', obfuscate: true)
  static final String iosMessagingSenderId = _Env.iosMessagingSenderId;

  @EnviedField(varName: 'IOS_FIREBASE_PROJECT_ID', obfuscate: true)
  static final String iosProjectId = _Env.iosProjectId;

  @EnviedField(varName: 'IOS_FIREBASE_STORAGE_BUCKET', obfuscate: true)
  static final String iosStorageBucket = _Env.iosStorageBucket;

  @EnviedField(varName: 'IOS_FIREBASE_BUNDLE_ID', obfuscate: true)
  static final String iosBundleId = _Env.iosBundleId;

  // App Config
  @EnviedField(varName: 'APP_NAME', obfuscate: true)
  static final String appName = _Env.appName;

  @EnviedField(varName: 'API_BASE_URL', obfuscate: true)
  static final String apiBaseUrl = _Env.apiBaseUrl;
}
