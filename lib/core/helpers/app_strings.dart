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
  static String get invalidCredential => 'invalidCredential'.tr();
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

  // Onboarding & Action Navigation
  static String get skip => 'skip'.tr();
  static String get onboardingSkip => 'onboardingSkip'.tr();
  static String get next => 'next'.tr();
  static String get getStarted => 'getStarted'.tr();
  static String get onboardingTitle1 => 'onboardingTitle1'.tr();
  static String get onboardingDescription1 => 'onboardingDescription1'.tr();
  static String get onboardingDesc1 => 'onboardingDescription1'.tr();
  static String get onboardingTitle2 => 'onboardingTitle2'.tr();
  static String get onboardingDescription2 => 'onboardingDescription2'.tr();
  static String get onboardingDesc2 => 'onboardingDescription2'.tr();
  static String get onboardingTitle3 => 'onboardingTitle3'.tr();
  static String get onboardingDescription3 => 'onboardingDescription3'.tr();
  static String get onboardingDesc3 => 'onboardingDescription3'.tr();
  static String get appTagline => 'appTagline'.tr();

  // Auth Strings
  static String get login => 'login'.tr();
  static String get email => 'email'.tr();
  static String get password => 'password'.tr();
  static String get forgotPassword => 'forgotPassword'.tr();
  static String get dontHaveAccount => 'dontHaveAccount'.tr();
  static String get createAnAccount => 'createAnAccount'.tr();
  static String get or => 'or'.tr();
  static String get signInWithGoogle => 'signInWithGoogle'.tr();
  static String get newAccount => 'newAccount'.tr();
  static String get fullName => 'fullName'.tr();
  static String get register => 'register'.tr();
  static String get alreadyHaveAnAccount => 'alreadyHaveAnAccount'.tr();
  static String get passwordReset => 'passwordReset'.tr();
  static String get sendEmailResetLink => 'sendEmailResetLink'.tr();
  static String get sendPasswordResetLink => 'sendPasswordResetLink'.tr();
  static String get send => 'send'.tr();
  static String get sendPasswordResetConfirmation =>
      'sendPasswordResetConfirmation'.tr();
  static String get emailSent => 'emailSent'.tr();
  static String get emailSentToReset => 'emailSentToReset'.tr();
  static String get emailCreated => 'emailCreated'.tr();
  static String get emailSentToVerify => 'emailSentToVerify'.tr();
  static String get youShouldAcceptTermsAndConditions =>
      'youShouldAcceptTermsAndConditions'.tr();
  static String get termsAndConditionsP1 => 'termsAndConditionsP1'.tr();
  static String get termsAndConditionsP2 => 'termsAndConditionsP2'.tr();
  static String get ok => 'ok'.tr();
  static String get noUserFoundForThatEmail => 'noUserFoundForThatEmail'.tr();
  static String get pleaseVerifyYourEmail => 'pleaseVerifyYourEmail'.tr();

  // Navigation Bar Strings
  static String get home => 'home'.tr();
  static String get invoices => 'invoices'.tr();
  static String get clients => 'clients'.tr();
  static String get settings => 'settings'.tr();
  static String get generalSettings => 'generalSettings'.tr();
  static String get localSettings => 'localSettings'.tr();
  static String get profileInformation => 'profileInformation'.tr();
  static String get securitySettings => 'securitySettings'.tr();
  static String get theme => 'theme'.tr();
  static String get language => 'language'.tr();
  static String get arabic => 'arabic'.tr();
  static String get english => 'english'.tr();
  static String get currency => 'currency'.tr();
  static String get signOut => 'signOut'.tr();
  static String get signOutConfirmation => 'signOutConfirmation'.tr();
  static String get passwordResetSent => 'passwordResetSent'.tr();
  static String get currencyUpdated => 'currencyUpdated'.tr();
  static String get usd => 'usd'.tr();
  static String get egp => 'egp'.tr();
  static String get eur => 'eur'.tr();
  static String get sar => 'sar'.tr();
  static String get aed => 'aed'.tr();
  static String get businessNameUpdated => 'businessNameUpdated'.tr();
  static String get businessName => 'businessName'.tr();
  static String get memberSince => 'memberSince'.tr();
  static String get accountStatus => 'accountStatus'.tr();
  static String get verified => 'verified'.tr();
  static String get unverified => 'unverified'.tr();
  static String get saveChanges => 'saveChanges'.tr();
  static String get accountDetails => 'accountDetails'.tr();

  // Client Management Strings
  static String get addClient => 'addClient'.tr();
  static String get editClient => 'editClient'.tr();
  static String get deleteClient => 'deleteClient'.tr();
  static String get deleteClientConfirmation => 'deleteClientConfirmation'.tr();
  static String get searchClients => 'searchClients'.tr();
  static String get noClientsFound => 'noClientsFound'.tr();
  static String get noClientsYet => 'noClientsYet'.tr();
  static String get clientName => 'clientName'.tr();
  static String get clientEmail => 'clientEmail'.tr();
  static String get clientPhone => 'clientPhone'.tr();
  static String get clientAddress => 'clientAddress'.tr();
  static String get clientInformation => 'clientInformation'.tr();
  static String get clientAddedSuccessfully => 'clientAddedSuccessfully'.tr();
  static String get clientUpdatedSuccessfully =>
      'clientUpdatedSuccessfully'.tr();
  static String get clientDeletedSuccessfully =>
      'clientDeletedSuccessfully'.tr();
  static String get phone => 'phone'.tr();
  static String get address => 'address'.tr();

  // Invoice Management Strings
  static String get createInvoice => 'createInvoice'.tr();
  static String get invoiceNumber => 'invoiceNumber'.tr();
  static String get selectClient => 'selectClient'.tr();
  static String get pleaseSelectClient => 'pleaseSelectClient'.tr();
  static String get issueDate => 'issueDate'.tr();
  static String get dueDate => 'dueDate'.tr();
  static String get invoiceItems => 'invoiceItems'.tr();
  static String get addItem => 'addItem'.tr();
  static String get itemName => 'itemName'.tr();
  static String get itemDescriptionHint => 'itemDescriptionHint'.tr();
  static String get quantity => 'quantity'.tr();
  static String get unitPrice => 'unitPrice'.tr();
  static String get subtotal => 'subtotal'.tr();
  static String get taxRate => 'taxRate'.tr();
  static String get taxAmount => 'taxAmount'.tr();
  static String get discount => 'discount'.tr();
  static String get grandTotal => 'grandTotal'.tr();
  static String get notes => 'notes'.tr();
  static String get notesHint => 'notesHint'.tr();
  static String get saveAsDraft => 'saveAsDraft'.tr();
  static String get invoiceCreatedSuccessfully =>
      'invoiceCreatedSuccessfully'.tr();
  static String get pleaseAddAtLeastOneItem => 'pleaseAddAtLeastOneItem'.tr();
  static String get statusDraft => 'statusDraft'.tr();
  static String get statusSent => 'statusSent'.tr();
  static String get statusPaid => 'statusPaid'.tr();
  static String get statusOverdue => 'statusOverdue'.tr();
  static String get statusCancelled => 'statusCancelled'.tr();
  static String get all => 'all'.tr();
  static String get noInvoicesYet => 'noInvoicesYet'.tr();
  static String get noInvoicesFound => 'noInvoicesFound'.tr();
  static String get deleteInvoiceConfirmation =>
      'deleteInvoiceConfirmation'.tr();
  static String get invoiceDeletedSuccessfully =>
      'invoiceDeletedSuccessfully'.tr();
  static String get selectDate => 'selectDate'.tr();
  static String get updateStatus => 'updateStatus'.tr();
  static String get editInvoice => 'editInvoice'.tr();
  static String get invoiceDetails => 'invoiceDetails'.tr();
  static String get invoiceUpdatedSuccessfully =>
      'invoiceUpdatedSuccessfully'.tr();
  static String get deleteInvoice => 'deleteInvoice'.tr();
}

