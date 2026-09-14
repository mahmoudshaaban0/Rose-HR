import 'package:rose_hr/l10n/app_localizations.dart';

class BereavementTypeModel {
  const BereavementTypeModel({required this.id});

  /// API value: `racines` or `sibling`.
  final String id;
}

/// Fixed options for the bereavement leave type (ids sent to the API).
const List<BereavementTypeModel> bereavementTypes = [
  BereavementTypeModel(id: 'racines'),
  BereavementTypeModel(id: 'sibling'),
];

extension BereavementTypeModelLocalization on BereavementTypeModel {
  String label(AppLocalizations l10n) {
    switch (id) {
      case 'racines':
        return l10n.bereavementTypeRacines;
      case 'sibling':
        return l10n.bereavementTypeSibling;
      default:
        return id;
    }
  }
}
