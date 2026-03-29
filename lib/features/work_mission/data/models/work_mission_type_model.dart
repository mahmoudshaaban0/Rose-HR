import 'package:rose_hr/l10n/app_localizations.dart';

enum WorkMissionTypeModel {
  hours('hours'),
  days('days');

  const WorkMissionTypeModel(this.id);
  final String id;
}

extension WorkMissionTypeModelL10n on WorkMissionTypeModel {
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case WorkMissionTypeModel.hours:
        return l10n.workMissionTypeHours;
      case WorkMissionTypeModel.days:
        return l10n.workMissionTypeDays;
    }
  }
}
