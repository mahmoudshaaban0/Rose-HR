// change dateTime to string in format yyyy-MM-dd
import 'package:intl/intl.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/common/utility/logger.dart';

String dateTimeToString(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd', 'en').format(dateTime.toUtc());
}

/// Converts UTC time string to local timezone time string
/// This handles time strings that come from the backend in UTC format
/// and converts them to the user's local timezone
///
/// Examples:
/// - "2026-01-15 13:38:19" (UTC) → local time string
/// - "13:38:19" (UTC) → local time string (assumes today's date)
/// - false → null
String? convertUtcTimeToLocal(dynamic value) {
  if (value == null || value == false) return null;

  // Convert to string if it's not already
  String str;
  if (value is String) {
    str = value.trim();
  } else {
    str = value.toString().trim();
  }

  if (str.isEmpty) return null;

  try {
    DateTime utcDateTime;

    // Check if it contains a date (datetime format: "YYYY-MM-DD HH:mm:ss")
    if (str.contains(' ')) {
      // Full datetime string
      utcDateTime = DateTime.parse(str).toUtc();
    } else if (str.contains(':')) {
      // Time only string - assume today's date in UTC
      final parts = str.split(':');
      if (parts.length < 2) return null;

      final now = DateTime.now().toUtc();
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final second = parts.length > 2 ? int.parse(parts[2]) : 0;

      utcDateTime = DateTime.utc(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
        second,
      );
    } else {
      return null;
    }

    // Convert UTC to local timezone using TimezoneHelper
    final localTime = TimezoneHelper.fromUtc(utcDateTime);

    // Return formatted time string in HH:mm:ss format with English numerals
    return TimezoneHelper.format(localTime, pattern: 'HH:mm:ss', locale: 'en');
  } on Exception catch (e) {
    // Catch any errors during parsing or conversion
    AppLogger.instance.logError('Error in convertUtcTimeToLocal for value "$value": $e');
    return null;
  }
}

/// Extracts time part from a datetime string or returns the string if it's already a time
/// Examples:
/// - "2026-01-15 13:38:19" → "13:38:19"
/// - "13:38:19" → "13:38:19"
/// - false → null
String? extractTimeFromDateTime(dynamic value) {
  if (value == null || value == false) return null;
  if (value is! String) return null;

  final str = value.trim();
  if (str.isEmpty) return null;

  // Check if it contains a space (datetime format: "YYYY-MM-DD HH:mm:ss")
  if (str.contains(' ')) {
    final parts = str.split(' ');
    if (parts.length >= 2) {
      return parts[1]; // Return the time part
    }
  }

  // Already a time string
  return str;
}

/// Converts time from API format (list or string) to Arabic time format.
/// The backend sends times in UTC, so this function converts to local timezone first.
///
/// Pass [amLabel] and [pmLabel] from your localization context so the period
/// string is always displayed in the correct locale (e.g. "AM" in English,
/// "صباحًا" in Arabic). When omitted the Arabic strings are used as a fallback.
///
/// Examples:
/// - [05:00:00] or "05:00:00" (UTC) → "٥ صباحًا" (local time)
/// - [14:00:00] or "14:00:00" (UTC) → "٢ مساءً" (local time)
/// - [00:30:00] or "00:30:00" (UTC) → "١٢:٣٠ صباحًا" (local time)
/// - "2026-01-15 13:38:19" (UTC) → "١:٣٨ مساءً" (local time)
String formatTimeToArabic(
  dynamic timeData, {
  bool useArabicNumerals = true,
  String amLabel = 'صباحًا',
  String pmLabel = 'مساءً',
}) {
  try {
    // Extract time string from list or use directly if string
    String? timeString;
    if (timeData is List && timeData.isNotEmpty) {
      timeString = convertUtcTimeToLocal(timeData.first);
    } else {
      timeString = convertUtcTimeToLocal(timeData);
    }

    if (timeString == null) return '--:--';

    // Parse the time string (format: HH:mm:ss) - now in local time
    final parts = timeString.split(':');
    if (parts.length < 2) return '--:--';

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    // Determine period using the injected localized labels
    final String period;
    final int displayHour;

    if (hour == 0) {
      displayHour = 12;
      period = amLabel;
    } else if (hour < 12) {
      displayHour = hour;
      period = amLabel;
    } else if (hour == 12) {
      displayHour = 12;
      period = pmLabel;
    } else {
      displayHour = hour - 12;
      period = pmLabel;
    }

    final hourStr = displayHour.toString();
    final minuteStr = minute.toString().padLeft(2, '0');

    final displayHourStr = useArabicNumerals ? _convertToArabicNumerals(hourStr) : hourStr;

    if (minute == 0) {
      return '$displayHourStr $period';
    } else {
      final displayMinuteStr = useArabicNumerals ? _convertToArabicNumerals(minuteStr) : minuteStr;
      return '$displayHourStr:$displayMinuteStr $period';
    }
  } on Exception catch (e) {
    AppLogger.instance.logError('Error in formatTimeToArabic: $e');
    return '--:--';
  }
}

/// Converts decimal hours to a human-readable duration string.
///
/// Pass the localized label strings so the output respects the active locale.
/// When [useArabicNumerals] is true (default), numbers are rendered as Arabic-Indic
/// digits (٥, ١٠, …); pass false for Western digits (5, 10, …).
///
/// Arabic plural forms are handled via [hourSingular] / [hourDual] / [hourPlural]
/// and the equivalent minute variants. English only uses [hourSingular] and
/// [minuteSingular] (e.g. "1 hour 30 minutes").
///
/// Handles all API shapes:
/// - String "0.0" / "0"  → "--:--"  (no data)
/// - String "5.83"       → "5 hours 49 minutes"  (en) / "٥ ساعات ٤٩ دقيقة" (ar)
/// - num    7.9          → "7 hours 54 minutes"  (en) / "٧ ساعات ٥٤ دقيقة" (ar)
/// - null / false        → "--"
String formatHoursToArabic(
  dynamic hoursData, {
  bool useArabicNumerals = true,
  // Hour labels
  String hourSingular = 'ساعة',
  String hourDual = 'ساعتان',
  String hourPlural = 'ساعات',
  // Minute labels
  String minuteSingular = 'دقيقة',
  String minuteDual = 'دقيقتان',
  String minutePlural = 'دقائق',
}) {
  try {
    // Unwrap list
    final raw = hoursData is List && hoursData.isNotEmpty ? hoursData.first : hoursData;

    if (raw == null || raw == false) return '--';

    // Convert to double
    final double? totalHours;
    if (raw is num) {
      totalHours = raw.toDouble();
    } else {
      totalHours = double.tryParse(raw.toString().trim());
    }

    // Treat missing / zero as "no data"
    if (totalHours == null || totalHours == 0.0) return '--:--';

    // Handle negative values
    final isNegative = totalHours < 0;
    final absoluteHours = totalHours.abs();

    // Calculate hours and minutes
    final hours = absoluteHours.floor();
    final minutes = ((absoluteHours - hours) * 60).round();

    // Build the result string
    final parts = <String>[];

    if (hours > 0) {
      final hourStr = useArabicNumerals ? _convertToArabicNumerals(hours.toString()) : hours.toString();
      final hourWord = hours == 1
          ? hourSingular
          : hours == 2
          ? hourDual
          : hourPlural;
      parts.add('$hourStr $hourWord');
    }

    if (minutes > 0) {
      final minuteStr = useArabicNumerals ? _convertToArabicNumerals(minutes.toString()) : minutes.toString();
      final minuteWord = minutes == 1
          ? minuteSingular
          : minutes == 2
          ? minuteDual
          : minutePlural;
      parts.add('$minuteStr $minuteWord');
    }

    if (parts.isEmpty) return '--:--';

    final result = parts.join(' ');
    return isNegative ? '- $result' : result;
  } on FormatException {
    return '--';
  }
}

/// Converts decimal hours to time format (HH:mm) and formats it.
///
/// Pass [amLabel] and [pmLabel] from your localization context so the period
/// string is always displayed in the correct locale. When omitted, falls back
/// to Arabic or English strings depending on [useArabic].
///
/// Examples:
/// - 11.5  → "١١:٣٠ صباحًا" (Arabic) / "11:30 AM" (English)
/// - 14.75 → "٢:٤٥ مساءً"  (Arabic) / "2:45 PM"  (English)
/// - 0.5   → "١٢:٣٠ صباحًا" (Arabic) / "12:30 AM" (English)
String formatDecimalHoursToTime(
  double hours, {
  bool useArabic = true,
  String? amLabel,
  String? pmLabel,
}) {
  try {
    // Calculate hours and minutes
    final hoursPart = hours.floor();
    final minutesPart = ((hours - hoursPart) * 60).round();

    // Resolve period labels: prefer injected localized strings, then fallback.
    final resolvedAm = amLabel ?? (useArabic ? 'صباحًا' : 'AM');
    final resolvedPm = pmLabel ?? (useArabic ? 'مساءً' : 'PM');

    // Determine period
    final String period;
    final int displayHour;

    if (hoursPart == 0) {
      displayHour = 12;
      period = resolvedAm;
    } else if (hoursPart < 12) {
      displayHour = hoursPart;
      period = resolvedAm;
    } else if (hoursPart == 12) {
      displayHour = 12;
      period = resolvedPm;
    } else {
      displayHour = hoursPart - 12;
      period = resolvedPm;
    }

    // Format the time string
    final hourStr = displayHour.toString();
    final minuteStr = minutesPart.toString().padLeft(2, '0');

    if (useArabic) {
      final arabicHour = _convertToArabicNumerals(hourStr);
      final arabicMinute = _convertToArabicNumerals(minuteStr);
      return '$arabicHour:$arabicMinute $period';
    } else {
      return '$hourStr:$minuteStr $period';
    }
  } on Exception catch (e) {
    AppLogger.instance.logError('  ❌ Error in formatDecimalHoursToTime: $e');
    return '--:--';
  }
}

/// Converts English numerals to Arabic numerals
String _convertToArabicNumerals(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  var result = input;
  for (var i = 0; i < english.length; i++) {
    result = result.replaceAll(english[i], arabic[i]);
  }
  return result;
}
