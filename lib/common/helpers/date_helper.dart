// change dateTime to string in format yyyy-MM-dd
import 'package:intl/intl.dart';

String dateTimeToString(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd', 'en').format(dateTime.toUtc());
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

/// Converts time from API format (list or string) to Arabic time format
/// Examples:
/// - [05:00:00] or "05:00:00" → "٥ صباحاً"
/// - [14:00:00] or "14:00:00" → "٢ مساءاً"
/// - [00:30:00] or "00:30:00" → "١٢:٣٠ صباحاً"
/// - "2026-01-15 13:38:19" → "١:٣٨ مساءاً"
String formatTimeToArabic(dynamic timeData) {
  try {
    // Extract time string from list or use directly if string
    String? timeString;
    if (timeData is List && timeData.isNotEmpty) {
      timeString = extractTimeFromDateTime(timeData.first);
    } else {
      timeString = extractTimeFromDateTime(timeData);
    }

    if (timeString == null) return '--:--';

    // Parse the time string (format: HH:mm:ss)
    final parts = timeString.split(':');
    if (parts.length < 2) return '--:--';

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    // Determine period (صباحاً/مساءاً)
    final String period;
    final int displayHour;

    if (hour == 0) {
      displayHour = 12;
      period = 'صباحاً';
    } else if (hour < 12) {
      displayHour = hour;
      period = 'صباحاً';
    } else if (hour == 12) {
      displayHour = 12;
      period = 'مساءاً';
    } else {
      displayHour = hour - 12;
      period = 'مساءاً';
    }

    // Convert numbers to Arabic numerals
    final arabicHour = _convertToArabicNumerals(displayHour.toString());

    // If minutes are zero, show only hour
    if (minute == 0) {
      return '$arabicHour $period';
    } else {
      final arabicMinute = _convertToArabicNumerals(minute.toString().padLeft(2, '0'));
      return '$arabicHour:$arabicMinute $period';
    }
  } on FormatException {
    return '--:--';
  }
}

/// Converts decimal hours to Arabic hours and minutes format
/// Examples:
/// - [7.9] or 7.9 → "٧ ساعات ٥٤ دقيقة"
/// - [1.1] or 1.1 → "١ ساعة ٦ دقائق"
/// - [0.5] or 0.5 → "٣٠ دقيقة"
/// - [-1.5] or -1.5 → "- ١ ساعة ٣٠ دقيقة"
String formatHoursToArabic(dynamic hoursData) {
  try {
    // Extract hours value from list or use directly if number
    final hoursValue = hoursData is List && hoursData.isNotEmpty
        ? hoursData.first
        : hoursData is num
        ? hoursData
        : null;

    if (hoursValue == null) return '--';

    // Convert to double
    final totalHours = (hoursValue is num) ? hoursValue.toDouble() : double.parse(hoursValue.toString());

    // Handle negative values
    final isNegative = totalHours < 0;
    final absoluteHours = totalHours.abs();

    // Calculate hours and minutes
    final hours = absoluteHours.floor();
    final minutes = ((absoluteHours - hours) * 60).round();

    // Build the result string
    final parts = <String>[];

    if (hours > 0) {
      final arabicHours = _convertToArabicNumerals(hours.toString());
      final hourWord = hours == 1
          ? 'ساعة'
          : hours == 2
          ? 'ساعتان'
          : 'ساعات';
      parts.add('$arabicHours $hourWord');
    }

    if (minutes > 0) {
      final arabicMinutes = _convertToArabicNumerals(minutes.toString());
      final minuteWord = minutes == 1
          ? 'دقيقة'
          : minutes == 2
          ? 'دقيقتان'
          : 'دقائق';
      parts.add('$arabicMinutes $minuteWord');
    }

    if (parts.isEmpty) {
      return '--:--';
    }

    final result = parts.join(' ');
    return isNegative ? '- $result' : result;
  } on FormatException {
    return '--';
  }
}

/// Converts decimal hours to time format (HH:mm) and formats to Arabic
/// Examples:
/// - 11.5 → "١١:٣٠ صباحاً" (Arabic)
/// - 14.75 → "٢:٤٥ مساءاً" (Arabic)
/// - 0.5 → "١٢:٣٠ صباحاً" (Arabic)
String formatDecimalHoursToTime(double hours, {bool useArabic = true}) {
  try {
    // Calculate hours and minutes
    final hoursPart = hours.floor();
    final minutesPart = ((hours - hoursPart) * 60).round();

    // Determine period (صباحاً/مساءاً or AM/PM)
    final String period;
    final int displayHour;

    if (hoursPart == 0) {
      displayHour = 12;
      period = useArabic ? 'صباحاً' : 'AM';
    } else if (hoursPart < 12) {
      displayHour = hoursPart;
      period = useArabic ? 'صباحاً' : 'AM';
    } else if (hoursPart == 12) {
      displayHour = 12;
      period = useArabic ? 'مساءاً' : 'PM';
    } else {
      displayHour = hoursPart - 12;
      period = useArabic ? 'مساءاً' : 'PM';
    }

    // Format the time string
    final hourStr = displayHour.toString();
    final minuteStr = minutesPart.toString().padLeft(2, '0');

    if (useArabic) {
      // Convert to Arabic numerals
      final arabicHour = _convertToArabicNumerals(hourStr);
      final arabicMinute = _convertToArabicNumerals(minuteStr);
      return '$arabicHour:$arabicMinute $period';
    } else {
      return '$hourStr:$minuteStr $period';
    }
  } catch (e) {
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
