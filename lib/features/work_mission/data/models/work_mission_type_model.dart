enum WorkMissionTypeModel {
  hours(id: 'hours', name: 'ساعات'),
  days(id: 'days', name: 'أيام');

  const WorkMissionTypeModel({required this.id, required this.name});
  final String id;
  final String name;
}
