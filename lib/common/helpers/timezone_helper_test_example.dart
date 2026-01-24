// /// Example test file showing how to use and test the new GPS-based TimezoneHelper
// /// 
// /// This file demonstrates the new API and shows how timezone detection works.
// /// You can run these examples in your app to verify everything works correctly.

// import 'package:rose_hr/common/helpers/timezone_helper.dart';

// /// Example: Test timezone detection from coordinates
// void testTimezoneDetection() {
//   print('=== Testing Timezone Detection from Coordinates ===\n');

//   // Test Cairo coordinates
//   final cairoTimezone = TimezoneHelper.detectTimezoneFromCoordinates(
//     latitude: 30.0444,
//     longitude: 31.2357,
//   );
//   print('Cairo (30.0444, 31.2357):');
//   print('  Detected timezone: $cairoTimezone');
//   print('  Expected: AppTimezone.egypt');
//   print('  ✓ Test ${cairoTimezone == AppTimezone.egypt ? "PASSED" : "FAILED"}\n');

//   // Test Riyadh coordinates
//   final riyadhTimezone = TimezoneHelper.detectTimezoneFromCoordinates(
//     latitude: 24.7136,
//     longitude: 46.6753,
//   );
//   print('Riyadh (24.7136, 46.6753):');
//   print('  Detected timezone: $riyadhTimezone');
//   print('  Expected: AppTimezone.saudiArabia');
//   print('  ✓ Test ${riyadhTimezone == AppTimezone.saudiArabia ? "PASSED" : "FAILED"}\n');

//   // Test Alexandria (should be Egypt as it's closer to Cairo)
//   final alexTimezone = TimezoneHelper.detectTimezoneFromCoordinates(
//     latitude: 31.2001,
//     longitude: 29.9187,
//   );
//   print('Alexandria (31.2001, 29.9187):');
//   print('  Detected timezone: $alexTimezone');
//   print('  Expected: AppTimezone.egypt');
//   print('  ✓ Test ${alexTimezone == AppTimezone.egypt ? "PASSED" : "FAILED"}\n');

//   // Test Jeddah (should be Saudi Arabia as it's closer to Riyadh)
//   final jeddahTimezone = TimezoneHelper.detectTimezoneFromCoordinates(
//     latitude: 21.4858,
//     longitude: 39.1925,
//   );
//   print('Jeddah (21.4858, 39.1925):');
//   print('  Detected timezone: $jeddahTimezone');
//   print('  Expected: AppTimezone.saudiArabia');
//   print('  ✓ Test ${jeddahTimezone == AppTimezone.saudiArabia ? "PASSED" : "FAILED"}\n');
// }

// /// Example: Get current GPS-detected timezone information
// void showCurrentTimezoneInfo() {
//   print('=== Current GPS-Detected Timezone Info ===\n');

//   final timezone = TimezoneHelper.getCurrentTimezone();
//   final timezoneName = TimezoneHelper.getCurrentTimezoneName();
//   final cityName = TimezoneHelper.getCurrentCityName();
//   final offset = TimezoneHelper.getTimezoneOffset();
//   final abbr = TimezoneHelper.getTimezoneAbbreviation();
//   final isDetecting = TimezoneHelper.isDetectingTimezone;

//   print('Timezone: $timezone');
//   print('IANA Name: $timezoneName');
//   print('City: ${cityName ?? "Not detected"}');
//   print('UTC Offset: ${offset > 0 ? "+" : ""}$offset hours');
//   print('Abbreviation: $abbr');
//   print('Currently detecting: ${isDetecting ? "Yes" : "No"}');
//   print('');
// }

// /// Example: Compare old vs new API
// void demonstrateApiComparison() {
//   print('=== API Comparison (Old vs New) ===\n');

//   // OLD WAY (Still works but not recommended)
//   print('❌ OLD WAY (Static - Not recommended):');
//   print('  TimezoneHelper.nowIn(AppTimezone.egypt)');
//   print('  TimezoneHelper.fromUtcTo(utc, AppTimezone.egypt)');
//   print('  TimezoneHelper.createTimestampIn(dateTime, AppTimezone.egypt)');
//   print('');

//   // NEW WAY (GPS-based - Recommended)
//   print('✅ NEW WAY (GPS-based - Recommended):');
//   print('  TimezoneHelper.now()  // Auto-detects timezone');
//   print('  TimezoneHelper.fromUtc(utc)  // Uses GPS timezone');
//   print('  TimezoneHelper.createTimestamp(dateTime)  // Uses GPS timezone');
//   print('');
// }

// /// Example: Working with dates and times
// void demonstrateDateTimeOperations() {
//   print('=== Date/Time Operations ===\n');

//   // Get current time in GPS-detected timezone
//   final now = TimezoneHelper.now();
//   print('Current time (GPS timezone):');
//   print('  DateTime: $now');
//   print('  Formatted: ${TimezoneHelper.format(now, pattern: 'yyyy-MM-dd HH:mm:ss')}');
//   print('  With timezone: ${TimezoneHelper.formatWithTimezone(now)}');
//   print('');

//   // Convert to UTC for storage
//   final utc = TimezoneHelper.toUtc(now);
//   print('Converted to UTC (for database):');
//   print('  DateTime: $utc');
//   print('  Formatted: ${utc.toIso8601String()}');
//   print('');

//   // Convert back to local for display
//   final local = TimezoneHelper.fromUtc(utc);
//   print('Converted back to local (for display):');
//   print('  DateTime: $local');
//   print('  Formatted: ${TimezoneHelper.format(local, pattern: 'hh:mm a')}');
//   print('');

//   // Create timestamp for specific date
//   final specificDate = DateTime(2026, 1, 23, 14, 30);
//   final timestamp = TimezoneHelper.createTimestamp(specificDate);
//   print('Created timestamp for 2026-01-23 14:30:');
//   print('  DateTime: $timestamp');
//   print('  Timezone: ${timestamp.timeZoneName}');
//   print('  Formatted: ${TimezoneHelper.format(timestamp, pattern: 'MMMM dd, yyyy hh:mm a')}');
//   print('');
// }

// /// Example: Cross-timezone operations
// void demonstrateCrossTimezoneOperations() {
//   print('=== Cross-Timezone Operations ===\n');

//   // Get current time in different timezones
//   final egyptNow = TimezoneHelper.nowIn(AppTimezone.egypt);
//   final saudiNow = TimezoneHelper.nowIn(AppTimezone.saudiArabia);

//   print('Current time in different timezones:');
//   print('  Egypt: ${TimezoneHelper.format(egyptNow, pattern: 'HH:mm:ss')} ${egyptNow.timeZoneName}');
//   print('  Saudi: ${TimezoneHelper.format(saudiNow, pattern: 'HH:mm:ss')} ${saudiNow.timeZoneName}');
//   print('');

//   // Convert between timezones
//   final egyptToSaudi = TimezoneHelper.convertTimezone(egyptNow, AppTimezone.saudiArabia);
//   print('Same moment in time, different timezone:');
//   print('  Egypt time: ${TimezoneHelper.format(egyptNow, pattern: 'HH:mm:ss')}');
//   print('  Converted to Saudi: ${TimezoneHelper.format(egyptToSaudi, pattern: 'HH:mm:ss')}');
//   print('');

//   // Compare times
//   final comparison = TimezoneHelper.compare(egyptNow, saudiNow);
//   print('Comparing Egypt and Saudi times:');
//   print('  Result: $comparison');
//   print('  Meaning: ${comparison == 0 ? "Same moment in time" : comparison < 0 ? "Egypt is earlier" : "Saudi is earlier"}');
//   print('');
// }

// /// Main function to run all examples
// /// 
// /// You can call this from your app to test the timezone system:
// /// ```dart
// /// import 'package:rose_hr/common/helpers/timezone_helper_test_example.dart';
// /// 
// /// // In your debug screen or during development:
// /// runTimezoneTests();
// /// ```
// void runTimezoneTests() {
//   print('\n╔════════════════════════════════════════════════════╗');
//   print('║  TimezoneHelper - GPS-Based System Tests          ║');
//   print('╚════════════════════════════════════════════════════╝\n');

//   // Run all test examples
//   testTimezoneDetection();
//   showCurrentTimezoneInfo();
//   demonstrateApiComparison();
//   demonstrateDateTimeOperations();
//   demonstrateCrossTimezoneOperations();

//   print('╔════════════════════════════════════════════════════╗');
//   print('║  All tests complete!                               ║');
//   print('╚════════════════════════════════════════════════════╝\n');
// }

// /// Quick test to verify timezone detection is working correctly
// /// 
// /// Returns true if all tests pass, false otherwise
// bool verifyTimezoneDetection() {
//   // Test Cairo → Egypt
//   final cairoTest = TimezoneHelper.detectTimezoneFromCoordinates(
//     latitude: 30.0444,
//     longitude: 31.2357,
//   ) == AppTimezone.egypt;

//   // Test Riyadh → Saudi Arabia
//   final riyadhTest = TimezoneHelper.detectTimezoneFromCoordinates(
//     latitude: 24.7136,
//     longitude: 46.6753,
//   ) == AppTimezone.saudiArabia;

//   return cairoTest && riyadhTest;
// }

