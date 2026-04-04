import 'package:rose_hr/l10n/app_localizations.dart';

class PermissionTypeModel {
  const PermissionTypeModel({required this.id});

  /// API value, e.g. `early_out`, `late_in`, `mid_day`.
  final String id;
}

/// Options shown in the permission-type picker (ids match [PermissionType]).
const List<PermissionTypeModel> permissionTypes = [
  PermissionTypeModel(id: 'early_out'),
  PermissionTypeModel(id: 'late_in'),
  PermissionTypeModel(id: 'mid_day'),
];

enum PermissionType {
  earlyOut(id: 'early_out'),
  lateIn(id: 'late_in'),
  midDay(id: 'mid_day'),
  fullDay(id: 'full_day');

  const PermissionType({required this.id});

  final String id;
}

extension PermissionTypeModelLocalization on PermissionTypeModel {
  String label(AppLocalizations l10n) {
    switch (id) {
      case 'early_out':
        return l10n.earlyCheckout;
      case 'late_in':
        return l10n.lateAttendance;
      case 'mid_day':
        return l10n.midDay;
      default:
        return id;
    }
  }
}
