import 'package:rose_hr/l10n/app_localizations.dart';

class PunchCorrectionReasonsModel {
  const PunchCorrectionReasonsModel({required this.id});

  /// API / form value sent with the request.
  final String id;
}

/// Reasons offered in punch correction (ids must match backend).
const List<PunchCorrectionReasonsModel> punchCorrectionReasons = [
  PunchCorrectionReasonsModel(id: 'forgotten_fingerprint'),
  PunchCorrectionReasonsModel(id: 'mobile_app_issue'),
  PunchCorrectionReasonsModel(id: 'fingerprint_issue'),
  PunchCorrectionReasonsModel(id: 'internet_issue'),
  PunchCorrectionReasonsModel(id: 'remote_work'),
  PunchCorrectionReasonsModel(id: 'shift_swap'),
  PunchCorrectionReasonsModel(id: 'extra_work'),
  PunchCorrectionReasonsModel(id: 'site_visit'),
  PunchCorrectionReasonsModel(id: 'other'),
];

extension PunchCorrectionReasonsModelLocalization on PunchCorrectionReasonsModel {
  String label(AppLocalizations l10n) {
    switch (id) {
      case 'forgotten_fingerprint':
        return l10n.punchCorrectionReasonForgottenFingerprint;
      case 'mobile_app_issue':
        return l10n.punchCorrectionReasonMobileAppIssue;
      case 'fingerprint_issue':
        return l10n.punchCorrectionReasonFingerprintIssue;
      case 'internet_issue':
        return l10n.punchCorrectionReasonInternetIssue;
      case 'remote_work':
        return l10n.punchCorrectionReasonRemoteWork;
      case 'shift_swap':
        return l10n.punchCorrectionReasonShiftSwap;
      case 'extra_work':
        return l10n.punchCorrectionReasonExtraWork;
      case 'site_visit':
        return l10n.punchCorrectionReasonSiteVisit;
      case 'other':
        return l10n.punchCorrectionReasonOther;
      default:
        return id;
    }
  }
}
