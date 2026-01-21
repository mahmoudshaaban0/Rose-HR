class PunchCorrectionReasonsModel {
  PunchCorrectionReasonsModel({required this.id, required this.name});
  final String id;
  final String name;
}

List<PunchCorrectionReasonsModel> punchCorrectionReasons = [
  PunchCorrectionReasonsModel(id: 'forgotten_fingerprint', name: 'نسيان البصمة'),
  PunchCorrectionReasonsModel(id: 'mobile_app_issue', name: 'مشكلة في تطبيق الجوال'),
  PunchCorrectionReasonsModel(id: 'fingerprint_issue', name: 'مشكلة في البصمة'),
  PunchCorrectionReasonsModel(id: 'internet_issue', name: 'مشكلة في الإتصال بالإنترنت'),
  PunchCorrectionReasonsModel(id: 'remote_work', name: 'العمل عن بعد'),
  PunchCorrectionReasonsModel(id: 'shift_swap', name: 'تبديل الدوام مع موظف آخر'),
  PunchCorrectionReasonsModel(id: 'extra_work', name: 'عمل إضافي بعد فترة بصمة الخروج'),
  PunchCorrectionReasonsModel(id: 'site_visit', name: 'زيارة موقع خارجي'),
  PunchCorrectionReasonsModel(id: 'other', name: 'أخرى'),
];
