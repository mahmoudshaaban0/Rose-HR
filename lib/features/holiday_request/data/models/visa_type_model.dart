class VisaTypeModel {
  VisaTypeModel({required this.id, required this.name});
  final String id;
  final String name;
}

List<VisaTypeModel> visaTypes = [
  VisaTypeModel(id: 'single', name: 'تأشيرة دخول واحد'),
  VisaTypeModel(id: 'multiple', name: 'تأشيرة دخول متعدد'),
];

enum VisaType {
  single(id: 'single', name: 'تأشيرة دخول واحد'),
  multiple(id: 'multiple', name: 'تأشيرة دخول متعدد');

  const VisaType({required this.id, required this.name});
  final String id;
  final String name;
}
