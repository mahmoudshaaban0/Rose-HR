class ReasonTypeModel {
  ReasonTypeModel({required this.id, required this.name});
  final String id;
  final String name;
}

List<ReasonTypeModel> reasonTypes = [
  ReasonTypeModel(id: 'شخصي', name: 'شخصي'),
  ReasonTypeModel(id: 'عمل', name: 'عمل'),
];
