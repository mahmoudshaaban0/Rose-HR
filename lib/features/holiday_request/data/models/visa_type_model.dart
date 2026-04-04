import 'package:rose_hr/l10n/app_localizations.dart';

class VisaTypeModel {
  const VisaTypeModel({required this.id});

  /// API value: `single` or `multiple`.
  final String id;
}

/// Fixed options for exit/entry visa type (ids sent to the API).
const List<VisaTypeModel> visaTypes = [
  VisaTypeModel(id: 'single'),
  VisaTypeModel(id: 'multiple'),
];

extension VisaTypeModelLocalization on VisaTypeModel {
  String label(AppLocalizations l10n) {
    switch (id) {
      case 'single':
        return l10n.visaTypeSingleEntry;
      case 'multiple':
        return l10n.visaTypeMultipleEntry;
      default:
        return id;
    }
  }
}
