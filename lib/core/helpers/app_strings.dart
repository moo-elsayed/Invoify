import 'package:easy_localization/easy_localization.dart';

abstract class AppStrings {
  AppStrings._();

  static String get welcome => 'welcome'.tr();
  static String get optional => 'optional'.tr();
  static String get cancel => 'cancel'.tr();
  static String get system => 'system'.tr();
  static String get light => 'light'.tr();
  static String get dark => 'dark'.tr();

  // Network & Firebase Errors
  static String get noInternetConnection => 'noInternetConnection'.tr();
  static String get unexpectedError => 'unexpectedError'.tr();
  static String get unauthorizedError => 'unauthorizedError'.tr();
  static String get notFoundError => 'notFoundError'.tr();
  static String get serverError => 'serverError'.tr();
  static String get somethingWentWrong => 'somethingWentWrong'.tr();
  static String get userNotFound => 'userNotFound'.tr();
  static String get wrongPassword => 'wrongPassword'.tr();
  static String get emailAlreadyInUse => 'emailAlreadyInUse'.tr();
  static String get invalidEmail => 'invalidEmail'.tr();
  static String get tooManyRequests => 'tooManyRequests'.tr();
  static String get permissionDenied => 'permissionDenied'.tr();
  static String get userDisabled => 'userDisabled'.tr();
  static String get operationNotAllowed => 'operationNotAllowed'.tr();
  static String get cacheError => 'cacheError'.tr();

  // Validation Strings
  static String get emailCannotBeEmpty => 'emailCannotBeEmpty'.tr();
  static String get enterAValidEmailAddress => 'enterAValidEmailAddress'.tr();
  static String get requiredField => 'requiredField'.tr();
  static String get passwordCannotBeEmpty => 'passwordCannotBeEmpty'.tr();
  static String get passwordMustBeAtLeast8CharactersLong =>
      'passwordMustBeAtLeast8CharactersLong'.tr();
  static String get passwordMustContainUppercase =>
      'passwordMustContainUppercase'.tr();
  static String get passwordMustContainLowercase =>
      'passwordMustContainLowercase'.tr();
  static String get passwordMustContainNumber =>
      'passwordMustContainNumber'.tr();
  static String get passwordMustContainSpecialCharacter =>
      'passwordMustContainSpecialCharacter'.tr();
  static String get confirmPasswordMustMatchThePassword =>
      'confirmPasswordMustMatchThePassword'.tr();
  static String get nameCannotBeEmpty => 'nameCannotBeEmpty'.tr();
  static String get profilePictureIsRequired =>
      'profilePictureIsRequired'.tr();
  static String get idCardImageIsRequired => 'idCardImageIsRequired'.tr();
  static String get usernameCannotBeEmpty => 'usernameCannotBeEmpty'.tr();
  static String get streetNameCannotBeEmpty => 'streetNameCannotBeEmpty'.tr();
  static String get cityCannotBeEmpty => 'cityCannotBeEmpty'.tr();
  static String get buildingNumberCannotBeEmpty =>
      'buildingNumberCannotBeEmpty'.tr();
  static String get itMustBeANumber => 'itMustBeANumber'.tr();
  static String get pleaseEnterDescription => 'pleaseEnterDescription'.tr();
  static String get pleaseSelectLocation => 'pleaseSelectLocation'.tr();
  static String get pleaseSelectDate => 'pleaseSelectDate'.tr();
  static String get pleaseSelectTime => 'pleaseSelectTime'.tr();
  static String get yearsOfExperienceCannotBeEmpty =>
      'yearsOfExperienceCannotBeEmpty'.tr();
  static String get phoneNumberCannotBeEmpty =>
      'phoneNumberCannotBeEmpty'.tr();
  static String get enterAValidPhoneNumber => 'enterAValidPhoneNumber'.tr();
  static String get codeCannotBeEmpty => 'codeCannotBeEmpty'.tr();
  static String get codeShouldBeAtLeast6Digits =>
      'codeShouldBeAtLeast6Digits'.tr();
  static String get nationalIdCannotBeEmpty => 'nationalIdCannotBeEmpty'.tr();
  static String get nationalIdMustBe14Digits =>
      'nationalIdMustBe14Digits'.tr();
}
