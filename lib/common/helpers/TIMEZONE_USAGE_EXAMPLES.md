# Timezone Helper - Usage Guide

This guide shows you how to use the `TimezoneHelper` class for accurate time tracking across Egypt and Saudi Arabia in your HR app.

## Quick Start

The timezone system is already initialized in `main.dart` and ready to use throughout the app.

## Common Use Cases

### 1. Clock In/Out for Attendance

```dart
import 'package:rose_hr/common/helpers/timezone_helper.dart';

// Employee in Egypt clocks in
final egyptClockIn = TimezoneHelper.now(AppTimezone.egypt);

// Employee in Saudi Arabia clocks in
final saudiClockIn = TimezoneHelper.now(AppTimezone.saudiArabia);

// Convert to UTC for storage in database
final utcTimestamp = TimezoneHelper.toUtc(egyptClockIn);

// Save to database (always store in UTC)
await attendanceRepository.save(
  employeeId: employeeId,
  clockInTime: utcTimestamp,
  timezone: 'Africa/Cairo', // Store timezone for reference
);
```

### 2. Display Attendance Records

```dart
// Retrieve UTC timestamp from database
final utcTimestamp = attendanceRecord.clockInTime; // DateTime in UTC

// Convert to Egypt timezone for display
final egyptTime = TimezoneHelper.fromUtc(utcTimestamp, AppTimezone.egypt);

// Format for display
final formattedTime = TimezoneHelper.format(
  egyptTime,
  pattern: 'hh:mm a', // "09:00 AM"
);

// Or with timezone abbreviation
final withTimezone = TimezoneHelper.formatWithTimezone(
  egyptTime,
  pattern: 'hh:mm a', // "09:00 AM EET"
);
```

### 3. Compare Times Across Timezones

```dart
// Employee in Egypt clocked in at 9:00 AM Egypt time
final egyptTime = TimezoneHelper.now(AppTimezone.egypt);

// Check what time it is in Saudi Arabia at the same moment
final saudiTime = TimezoneHelper.convertTimezone(
  egyptTime,
  AppTimezone.saudiArabia,
);

// Compare two timestamps (works even if they're in different timezones)
final comparison = TimezoneHelper.compare(egyptTime, saudiTime);
// Returns: 0 (they represent the same moment in time)
```

### 4. Calculate Work Hours

```dart
// Get clock in and clock out times
final clockIn = TimezoneHelper.fromUtc(
  record.clockInTimeUtc,
  AppTimezone.egypt,
);

final clockOut = TimezoneHelper.fromUtc(
  record.clockOutTimeUtc,
  AppTimezone.egypt,
);

// Calculate duration
final duration = clockOut.difference(clockIn);
final hoursWorked = duration.inHours;
final minutesWorked = duration.inMinutes % 60;

print('Worked: $hoursWorked hours and $minutesWorked minutes');
```

### 5. Check if Clocked In Today

```dart
final now = TimezoneHelper.now(AppTimezone.egypt);
final lastClockIn = TimezoneHelper.fromUtc(
  record.lastClockInUtc,
  AppTimezone.egypt,
);

final isSameDay = TimezoneHelper.isSameDay(now, lastClockIn);

if (isSameDay) {
  print('Already clocked in today');
} else {
  print('Need to clock in');
}
```

### 6. Get Day Boundaries

```dart
// Get start and end of today in Egypt timezone
final now = TimezoneHelper.now(AppTimezone.egypt);
final startOfDay = TimezoneHelper.startOfDay(now); // 00:00:00
final endOfDay = TimezoneHelper.endOfDay(now);     // 23:59:59.999

// Useful for queries: "Get all attendance records for today"
final todayRecords = await attendanceRepository.getRecordsBetween(
  start: TimezoneHelper.toUtc(startOfDay),
  end: TimezoneHelper.toUtc(endOfDay),
);
```

### 7. Create Specific Timestamps

```dart
// Create a specific date/time in Egypt timezone
final shiftStart = TimezoneHelper.toTimezone(
  DateTime(2025, 11, 10, 9, 0), // 9:00 AM
  AppTimezone.egypt,
);

// Or from an existing DateTime
final regularDateTime = DateTime(2025, 11, 10, 14, 30);
final egyptTime = TimezoneHelper.createTimestamp(
  AppTimezone.egypt,
  regularDateTime,
);
```

## Best Practices

### ✅ DO:

1. **Always store timestamps in UTC** in your database
   ```dart
   final utc = TimezoneHelper.toUtc(localTime);
   ```

2. **Store the timezone identifier** with each record
   ```dart
   timezone: 'Africa/Cairo' or 'Asia/Riyadh'
   ```

3. **Convert to local timezone** only for display
   ```dart
   final local = TimezoneHelper.fromUtc(utcTime, AppTimezone.egypt);
   ```

4. **Use TimezoneHelper.now()** instead of DateTime.now() for attendance tracking
   ```dart
   final clockIn = TimezoneHelper.now(AppTimezone.egypt);
   ```

### ❌ DON'T:

1. **Don't store local times** directly without timezone info
   ```dart
   // BAD
   clockIn: DateTime.now()
   
   // GOOD
   clockIn: TimezoneHelper.toUtc(TimezoneHelper.now(AppTimezone.egypt))
   ```

2. **Don't use DateTime.now()** for attendance records
   ```dart
   // BAD - uses device timezone
   final time = DateTime.now();
   
   // GOOD - uses specific timezone
   final time = TimezoneHelper.now(AppTimezone.egypt);
   ```

3. **Don't compare DateTime and TZDateTime** directly
   ```dart
   // BAD
   if (dateTime == tzDateTime) { }
   
   // GOOD
   if (TimezoneHelper.compare(tzDateTime1, tzDateTime2) == 0) { }
   ```

## Database Schema Example

```dart
class AttendanceRecord {
  final String id;
  final String employeeId;
  final DateTime clockInUtc;      // Always UTC
  final DateTime? clockOutUtc;    // Always UTC
  final String timezone;          // 'Africa/Cairo' or 'Asia/Riyadh'
  final String location;          // Optional: 'Egypt' or 'Saudi Arabia'
  
  // Helper to get local time
  TZDateTime getClockInLocal() {
    final tz = timezone == 'Africa/Cairo' 
        ? AppTimezone.egypt 
        : AppTimezone.saudiArabia;
    return TimezoneHelper.fromUtc(clockInUtc, tz);
  }
}
```

## Timezone Information

| Location | Timezone ID | UTC Offset | DST |
|----------|-------------|------------|-----|
| Egypt | Africa/Cairo | UTC+2 | May observe DST |
| Saudi Arabia | Asia/Riyadh | UTC+3 | No DST |

### Example Times

When it's **9:00 AM** in Egypt:
- Egypt: 9:00 AM (UTC+2)
- Saudi Arabia: 10:00 AM (UTC+3)
- UTC: 7:00 AM

## Troubleshooting

### Issue: "TimezoneHelper not initialized"

**Solution:** Make sure `TimezoneHelper.initialize()` is called in `main.dart` before `runApp()`.

### Issue: Times are wrong

**Solution:** 
1. Ensure you're storing times in UTC
2. Verify the correct timezone is being used for display
3. Check that the timezone database is initialized

### Issue: Different times for same moment

**Solution:** This is expected! Same moment = different local times
```dart
// Same moment in time
final egyptTime = TimezoneHelper.now(AppTimezone.egypt);     // 9:00 AM
final saudiTime = TimezoneHelper.convertTimezone(
  egyptTime, 
  AppTimezone.saudiArabia,
); // 10:00 AM

// But they represent the SAME moment:
TimezoneHelper.compare(egyptTime, saudiTime); // Returns 0
```

## Need More Timezones?

To add more countries (e.g., UAE, Kuwait):

1. Add to the `AppTimezone` enum in `timezone_helper.dart`:
```dart
enum AppTimezone {
  egypt('Africa/Cairo'),
  saudiArabia('Asia/Riyadh'),
  uae('Asia/Dubai'),        // Add new timezone
  kuwait('Asia/Kuwait'),    // Add new timezone
}
```

2. Use the new timezone:
```dart
final uaeTime = TimezoneHelper.now(AppTimezone.uae);
```

## Further Reading

- [IANA Timezone Database](https://www.iana.org/time-zones)
- [Dart timezone package](https://pub.dev/packages/timezone)
- [List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

