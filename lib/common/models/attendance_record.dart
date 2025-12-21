import 'package:rose_hr/common/helpers/location_provider.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:timezone/timezone.dart' as tz;

/// Attendance record model that combines timezone-aware timestamps
/// with geolocation data for comprehensive attendance tracking
class AttendanceRecord {
  const AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.clockInUtc,
    required this.clockInTimezone,
    required this.clockInLatitude,
    required this.clockInLongitude,
    this.clockOutUtc,
    this.clockOutLatitude,
    this.clockOutLongitude,
    this.officeName,
    this.isLocationVerified = false,
    this.distanceFromOfficeMeters,
    this.notes,
  });

  /// Create from JSON
  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      clockInUtc: DateTime.parse(json['clockInUtc'] as String),
      clockInTimezone: json['clockInTimezone'] as String,
      clockInLatitude: (json['clockInLatitude'] as num).toDouble(),
      clockInLongitude: (json['clockInLongitude'] as num).toDouble(),
      clockOutUtc: json['clockOutUtc'] != null ? DateTime.parse(json['clockOutUtc'] as String) : null,
      clockOutLatitude: json['clockOutLatitude'] != null ? (json['clockOutLatitude'] as num).toDouble() : null,
      clockOutLongitude: json['clockOutLongitude'] != null ? (json['clockOutLongitude'] as num).toDouble() : null,
      officeName: json['officeName'] as String?,
      isLocationVerified: json['isLocationVerified'] as bool? ?? false,
      distanceFromOfficeMeters: json['distanceFromOfficeMeters'] != null
          ? (json['distanceFromOfficeMeters'] as num).toDouble()
          : null,
      notes: json['notes'] as String?,
    );
  }

  /// Unique ID for the attendance record
  final String id;

  /// Employee ID
  final String employeeId;

  /// Clock in time in UTC (always store in UTC)
  final DateTime clockInUtc;

  /// Timezone identifier for clock in (e.g., 'Africa/Cairo', 'Asia/Riyadh')
  final String clockInTimezone;

  /// Clock in location - latitude
  final double clockInLatitude;

  /// Clock in location - longitude
  final double clockInLongitude;

  /// Clock out time in UTC (null if still clocked in)
  final DateTime? clockOutUtc;

  /// Clock out location - latitude (null if not clocked out)
  final double? clockOutLatitude;

  /// Clock out location - longitude (null if not clocked out)
  final double? clockOutLongitude;

  /// Name of office (e.g., "Cairo Office", "Riyadh Office")
  final String? officeName;

  /// Whether location was verified to be at office
  final bool isLocationVerified;

  /// Distance from office in meters (for tracking purposes)
  final double? distanceFromOfficeMeters;

  /// Optional notes or remarks
  final String? notes;

  /// Check if user is still clocked in
  bool get isClockedIn => clockOutUtc == null;

  /// Get clock in time in local timezone
  tz.TZDateTime getClockInLocal() {
    final timezone = _getTimezoneFromString(clockInTimezone);
    return TimezoneHelper.fromUtc(clockInUtc, timezone);
  }

  /// Get clock out time in local timezone (null if not clocked out)
  tz.TZDateTime? getClockOutLocal() {
    if (clockOutUtc == null) return null;
    final timezone = _getTimezoneFromString(clockInTimezone);
    return TimezoneHelper.fromUtc(clockOutUtc!, timezone);
  }

  /// Get formatted clock in time
  String getFormattedClockIn({String pattern = 'hh:mm a'}) {
    final localTime = getClockInLocal();
    return TimezoneHelper.format(localTime, pattern: pattern);
  }

  /// Get formatted clock out time
  String? getFormattedClockOut({String pattern = 'hh:mm a'}) {
    final localTime = getClockOutLocal();
    if (localTime == null) return null;
    return TimezoneHelper.format(localTime, pattern: pattern);
  }

  /// Calculate work duration
  Duration? getWorkDuration() {
    if (clockOutUtc == null) return null;
    return clockOutUtc!.difference(clockInUtc);
  }

  /// Get formatted work duration (e.g., "8h 30m")
  String? getFormattedWorkDuration() {
    final duration = getWorkDuration();
    if (duration == null) return null;

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  /// Get clock in coordinates as string
  String get clockInCoordinates => '($clockInLatitude, $clockInLongitude)';

  /// Get clock out coordinates as string (if clocked out)
  String? get clockOutCoordinates {
    if (clockOutLatitude == null || clockOutLongitude == null) return null;
    return '($clockOutLatitude, $clockOutLongitude)';
  }

  /// Convert to JSON for API/database storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'clockInUtc': clockInUtc.toIso8601String(),
      'clockInTimezone': clockInTimezone,
      'clockInLatitude': clockInLatitude,
      'clockInLongitude': clockInLongitude,
      'clockOutUtc': clockOutUtc?.toIso8601String(),
      'clockOutLatitude': clockOutLatitude,
      'clockOutLongitude': clockOutLongitude,
      'officeName': officeName,
      'isLocationVerified': isLocationVerified,
      'distanceFromOfficeMeters': distanceFromOfficeMeters,
      'notes': notes,
    };
  }

  /// Create a copy with updated fields
  AttendanceRecord copyWith({
    String? id,
    String? employeeId,
    DateTime? clockInUtc,
    String? clockInTimezone,
    double? clockInLatitude,
    double? clockInLongitude,
    DateTime? clockOutUtc,
    double? clockOutLatitude,
    double? clockOutLongitude,
    String? officeName,
    bool? isLocationVerified,
    double? distanceFromOfficeMeters,
    String? notes,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      clockInUtc: clockInUtc ?? this.clockInUtc,
      clockInTimezone: clockInTimezone ?? this.clockInTimezone,
      clockInLatitude: clockInLatitude ?? this.clockInLatitude,
      clockInLongitude: clockInLongitude ?? this.clockInLongitude,
      clockOutUtc: clockOutUtc ?? this.clockOutUtc,
      clockOutLatitude: clockOutLatitude ?? this.clockOutLatitude,
      clockOutLongitude: clockOutLongitude ?? this.clockOutLongitude,
      officeName: officeName ?? this.officeName,
      isLocationVerified: isLocationVerified ?? this.isLocationVerified,
      distanceFromOfficeMeters: distanceFromOfficeMeters ?? this.distanceFromOfficeMeters,
      notes: notes ?? this.notes,
    );
  }

  /// Helper to convert timezone string to AppTimezone enum
  AppTimezone _getTimezoneFromString(String timezoneStr) {
    switch (timezoneStr) {
      case 'Africa/Cairo':
        return AppTimezone.egypt;
      case 'Asia/Riyadh':
        return AppTimezone.saudiArabia;
      default:
        return AppTimezone.egypt; // Default fallback
    }
  }

  @override
  String toString() {
    return 'AttendanceRecord(id: $id, employee: $employeeId, '
        'clockIn: ${getFormattedClockIn()}, '
        'clockOut: ${getFormattedClockOut() ?? "Not clocked out"}, '
        'location: $clockInCoordinates, verified: $isLocationVerified)';
  }
}

/// Builder class to create attendance records easily
class AttendanceRecordBuilder {
  AttendanceRecordBuilder({
    required this.employeeId,
    required this.timezone,
  });

  final String employeeId;
  final AppTimezone timezone;
  String? id;
  String? notes;

  /// Create clock in record with location
  Future<AttendanceRecord> clockIn({
    required LocationResult location,
    OfficeLocation? office,
  }) async {
    // Calculate distance from office if provided
    double? distanceFromOffice;
    var isVerified = false;
    String? officeName;

    if (office != null) {
      distanceFromOffice = office.distanceFromOffice(location);
      isVerified = office.isLocationInOffice(location);
      officeName = office.name;
    }

    final now = TimezoneHelper.now(timezone);
    final utc = TimezoneHelper.toUtc(now);

    return AttendanceRecord(
      id: id ?? _generateId(),
      employeeId: employeeId,
      clockInUtc: utc,
      clockInTimezone: timezone.locationName,
      clockInLatitude: location.latitude,
      clockInLongitude: location.longitude,
      officeName: officeName,
      isLocationVerified: isVerified,
      distanceFromOfficeMeters: distanceFromOffice,
      notes: notes,
    );
  }

  /// Add clock out to existing record
  AttendanceRecord clockOut({
    required AttendanceRecord record,
    required LocationResult location,
  }) {
    final now = TimezoneHelper.now(timezone);
    final utc = TimezoneHelper.toUtc(now);

    return record.copyWith(
      clockOutUtc: utc,
      clockOutLatitude: location.latitude,
      clockOutLongitude: location.longitude,
    );
  }

  String _generateId() {
    return 'ATT_${DateTime.now().millisecondsSinceEpoch}';
  }
}
