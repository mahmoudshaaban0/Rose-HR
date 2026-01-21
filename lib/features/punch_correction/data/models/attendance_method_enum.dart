enum AttendanceMethod {
  manual(id: 'manual', name: 'Manual'),
  attendanceLog(id: 'attendance_log', name: 'Attendance Log');

  const AttendanceMethod({required this.id, required this.name});
  final String id;
  final String name;
}
