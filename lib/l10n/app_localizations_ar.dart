// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get pleaseEnterYourEmail =>
      'قم بإدخال البريد الإلكتروني الخاص بالمنشأة';

  @override
  String get password => 'كلمة المرور';

  @override
  String get pleaseEnterYourPassword => 'أدخل كلمة المرور الخاصة بك';

  @override
  String get forgetPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get sendForgetPasswordCode => 'إرسال كلمة المرور';

  @override
  String get enterOTP => 'أدخل رمز التحقق';

  @override
  String get enterOTPHint =>
      'تم إرسال رمز التحقق على البريد الإلكتروني، تحقق من علبة الوارد أو من الرسائل المهملة';

  @override
  String get didNotReceiveOTP => 'لم يصلك رمز التحقق؟';

  @override
  String get tryAgainAfter => 'حاول مجددًا بعد';

  @override
  String get checkForNewOTP => 'تحقق من الرمز';

  @override
  String get continueAction => 'متابعة';

  @override
  String get home => 'الرئيسية';

  @override
  String get requests => 'الطلبات';

  @override
  String get attendance => 'الحضور';

  @override
  String get account => 'الحساب';

  @override
  String get clockInClockOut => 'تسجيل الحضور/ الإنصراف';

  @override
  String get newRequest => 'طلب جديد';

  @override
  String get attendanceCorrection => 'تصحيح الحضور';

  @override
  String get workAssignment => 'مهمة عمل';

  @override
  String get leaveRequest => 'طلب إجازة';

  @override
  String get permissionRequest => 'طلب استئذان';

  @override
  String get accuredLeaveBalance => 'رصيد الإجازة المستحق';

  @override
  String get timeLeftUntilYourShiftEnds => 'تبقى على نهاية دوامك';

  @override
  String get hours => 'ساعات ';

  @override
  String get inRange => 'داخل النطاق';

  @override
  String get fingerPrintRegistration => 'تسجيل بصمة';
}
