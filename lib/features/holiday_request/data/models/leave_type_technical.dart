/// Stable identifiers for special leave types, matched against the
/// `technical_name` field returned by the leave-types API rather than the
/// localized display name (which changes between English and Arabic).
abstract final class LeaveTypeTechnical {
  /// Annual (paid) leave. Shows the "advance salary" and
  /// "exit/re-entry visa" options.
  static const String annual = 'annual';

  /// Compensatory (time-off in lieu) leave. Shows the "advance salary" /
  /// "exit/re-entry visa" options, like annual leave.
  static const String compensatory = 'compensatory';

  /// Compensatory-off leave. Shows the compensated-day field.
  static const String compensatoryOff = 'compensatory_off';

  static bool isAnnual(String? technicalName) => technicalName == annual;

  static bool isCompensatory(String? technicalName) =>
      technicalName == compensatory;

  static bool isCompensatoryOff(String? technicalName) =>
      technicalName == compensatoryOff;
}
