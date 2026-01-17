import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @pleaseEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterYourPassword;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget password'**
  String get forgetPassword;

  /// No description provided for @sendForgetPasswordCode.
  ///
  /// In en, this message translates to:
  /// **'Send forget password code'**
  String get sendForgetPasswordCode;

  /// No description provided for @enterOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOTP;

  /// No description provided for @enterOTPHint.
  ///
  /// In en, this message translates to:
  /// **'An OTP has been sent to your email, check your inbox or spam folder'**
  String get enterOTPHint;

  /// No description provided for @didNotReceiveOTP.
  ///
  /// In en, this message translates to:
  /// **'Did not receive the OTP?'**
  String get didNotReceiveOTP;

  /// No description provided for @tryAgainAfter.
  ///
  /// In en, this message translates to:
  /// **'Try again after'**
  String get tryAgainAfter;

  /// No description provided for @checkForNewOTP.
  ///
  /// In en, this message translates to:
  /// **'Check for new OTP'**
  String get checkForNewOTP;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @clockInClockOut.
  ///
  /// In en, this message translates to:
  /// **'Clock In/Clock Out'**
  String get clockInClockOut;

  /// No description provided for @newRequest.
  ///
  /// In en, this message translates to:
  /// **'New Request'**
  String get newRequest;

  /// No description provided for @attendanceCorrection.
  ///
  /// In en, this message translates to:
  /// **'Attendance Correction'**
  String get attendanceCorrection;

  /// No description provided for @workAssignment.
  ///
  /// In en, this message translates to:
  /// **'Work Assignment'**
  String get workAssignment;

  /// No description provided for @leaveRequest.
  ///
  /// In en, this message translates to:
  /// **'Leave Request'**
  String get leaveRequest;

  /// No description provided for @permissionRequest.
  ///
  /// In en, this message translates to:
  /// **'Permission Request'**
  String get permissionRequest;

  /// No description provided for @accuredLeaveBalance.
  ///
  /// In en, this message translates to:
  /// **'Accured Leave Balance'**
  String get accuredLeaveBalance;

  /// No description provided for @timeLeftUntilYourShiftEnds.
  ///
  /// In en, this message translates to:
  /// **'Time left until your shift ends'**
  String get timeLeftUntilYourShiftEnds;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @inRange.
  ///
  /// In en, this message translates to:
  /// **'In Range'**
  String get inRange;

  /// No description provided for @fingerPrintRegistration.
  ///
  /// In en, this message translates to:
  /// **'FingerPrint Registration'**
  String get fingerPrintRegistration;

  /// No description provided for @attendanceCalendar.
  ///
  /// In en, this message translates to:
  /// **'Attendance Calendar'**
  String get attendanceCalendar;

  /// No description provided for @workHours.
  ///
  /// In en, this message translates to:
  /// **'Work Hours'**
  String get workHours;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @difference.
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get difference;

  /// No description provided for @youShouldOpenLocationPermission.
  ///
  /// In en, this message translates to:
  /// **'You should open location permission to clock in/clock out'**
  String get youShouldOpenLocationPermission;

  /// No description provided for @goToSettingsPage.
  ///
  /// In en, this message translates to:
  /// **'Go to settings page'**
  String get goToSettingsPage;

  /// No description provided for @currentRequests.
  ///
  /// In en, this message translates to:
  /// **'Current Requests'**
  String get currentRequests;

  /// No description provided for @completedRequests.
  ///
  /// In en, this message translates to:
  /// **'Completed Requests'**
  String get completedRequests;

  /// No description provided for @noCurrentRequestsUntilNow.
  ///
  /// In en, this message translates to:
  /// **'No current requests until now'**
  String get noCurrentRequestsUntilNow;

  /// No description provided for @noCompletedRequestsUntilNow.
  ///
  /// In en, this message translates to:
  /// **'No completed requests until now'**
  String get noCompletedRequestsUntilNow;

  /// No description provided for @permissionDayAndType.
  ///
  /// In en, this message translates to:
  /// **'Permission Day and Type'**
  String get permissionDayAndType;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @choosePermissionReason.
  ///
  /// In en, this message translates to:
  /// **'Choose Permission Reason'**
  String get choosePermissionReason;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @clickToUpload.
  ///
  /// In en, this message translates to:
  /// **'Click to Upload'**
  String get clickToUpload;

  /// No description provided for @fileFormatsHint.
  ///
  /// In en, this message translates to:
  /// **'JPEG, PNG, PDF, and MP4 formats, up to 50 MB.'**
  String get fileFormatsHint;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @punchCorrection.
  ///
  /// In en, this message translates to:
  /// **'Punch Correction'**
  String get punchCorrection;

  /// No description provided for @suggestedCorrectionTime.
  ///
  /// In en, this message translates to:
  /// **'Suggested Correction Time'**
  String get suggestedCorrectionTime;

  /// No description provided for @shift.
  ///
  /// In en, this message translates to:
  /// **'Shift (Work Time)'**
  String get shift;

  /// No description provided for @recordedCheckInTime.
  ///
  /// In en, this message translates to:
  /// **'Recorded Check-In Time'**
  String get recordedCheckInTime;

  /// No description provided for @recordedCheckOutTime.
  ///
  /// In en, this message translates to:
  /// **'Recorded Check-Out Time'**
  String get recordedCheckOutTime;

  /// No description provided for @forgotFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Forgot Fingerprint'**
  String get forgotFingerprint;

  /// No description provided for @enterDetailsHere.
  ///
  /// In en, this message translates to:
  /// **'Enter details here'**
  String get enterDetailsHere;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @enterTimeManually.
  ///
  /// In en, this message translates to:
  /// **'Enter time manually'**
  String get enterTimeManually;

  /// No description provided for @selectFromRecordedFingerprints.
  ///
  /// In en, this message translates to:
  /// **'Select from recorded fingerprints'**
  String get selectFromRecordedFingerprints;

  /// No description provided for @personalData.
  ///
  /// In en, this message translates to:
  /// **'Personal Data'**
  String get personalData;

  /// No description provided for @editPersonalData.
  ///
  /// In en, this message translates to:
  /// **'Edit Personal Data'**
  String get editPersonalData;

  /// No description provided for @fullNameInArabic.
  ///
  /// In en, this message translates to:
  /// **'Full Name in Arabic'**
  String get fullNameInArabic;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get maritalStatus;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @identityDetails.
  ///
  /// In en, this message translates to:
  /// **'Identity Details'**
  String get identityDetails;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @religion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get religion;

  /// No description provided for @muslim.
  ///
  /// In en, this message translates to:
  /// **'Muslim'**
  String get muslim;

  /// No description provided for @identityType.
  ///
  /// In en, this message translates to:
  /// **'Identity Type'**
  String get identityType;

  /// No description provided for @identityNumber.
  ///
  /// In en, this message translates to:
  /// **'Identity Number'**
  String get identityNumber;

  /// No description provided for @identityExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Identity Expiry Date'**
  String get identityExpiryDate;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @buildingNumber.
  ///
  /// In en, this message translates to:
  /// **'Building Number'**
  String get buildingNumber;

  /// No description provided for @streetName.
  ///
  /// In en, this message translates to:
  /// **'Street Name'**
  String get streetName;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @postalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get postalCode;

  /// No description provided for @bankAccountDetails.
  ///
  /// In en, this message translates to:
  /// **'Bank Account Details'**
  String get bankAccountDetails;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankName;

  /// No description provided for @ibanNumber.
  ///
  /// In en, this message translates to:
  /// **'IBAN Number'**
  String get ibanNumber;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @requestNumber.
  ///
  /// In en, this message translates to:
  /// **'Request Number'**
  String get requestNumber;

  /// No description provided for @requestStatus.
  ///
  /// In en, this message translates to:
  /// **'Request Status'**
  String get requestStatus;

  /// No description provided for @cancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel Request'**
  String get cancelRequest;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @lateArrival.
  ///
  /// In en, this message translates to:
  /// **'Late Arrival'**
  String get lateArrival;

  /// No description provided for @fingerprintDevice.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint Device'**
  String get fingerprintDevice;

  /// No description provided for @clickToSuggestCorrection.
  ///
  /// In en, this message translates to:
  /// **'Click to suggest correction'**
  String get clickToSuggestCorrection;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @generalInformation.
  ///
  /// In en, this message translates to:
  /// **'General Information'**
  String get generalInformation;

  /// No description provided for @egyptian.
  ///
  /// In en, this message translates to:
  /// **'Egyptian'**
  String get egyptian;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
