enum CorrectionType {
  checkIn(id: 'in', name: 'In'),
  checkOut(id: 'out', name: 'Out'),
  both(id: 'both', name: 'Both');

  const CorrectionType({required this.id, required this.name});
  final String id;
  final String name;
}
