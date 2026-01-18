class PermissionTypeModel {
  PermissionTypeModel({required this.id, required this.name});
  final String id;
  final String name;
}

List<PermissionTypeModel> permissionTypes = [
  PermissionTypeModel(id: PermissionType.earlyOut.id, name: 'انصراف مبكر'),
  PermissionTypeModel(id: PermissionType.lateIn.id, name: 'حضور متأخر'),
  PermissionTypeModel(id: PermissionType.midDay.id, name: 'منتصف اليوم'),
  // PermissionTypeModel(id: 'full_day', name: 'يوم كامل'),
];

enum PermissionType {
  earlyOut(id: 'early_out', name: 'انصراف مبكر'),
  lateIn(id: 'late_in', name: 'حضور متأخر'),
  midDay(id: 'mid_day', name: 'منتصف اليوم'),
  fullDay(id: 'full_day', name: 'يوم كامل');

  const PermissionType({required this.id, required this.name});
  final String id;
  final String name;
}
