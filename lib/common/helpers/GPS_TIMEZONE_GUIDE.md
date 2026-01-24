# GPS-Based Dynamic Timezone Detection Guide

## Overview

The `TimezoneHelper` class now uses **dynamic GPS-based timezone detection** instead of static enum selection. The timezone is automatically detected based on the user's GPS coordinates and updates throughout the app.

## How It Works

1. **GPS Detection**: The app gets the user's lat/lng coordinates using `LocationProvider`
2. **Timezone Calculation**: Compares distance to Cairo and Riyadh offices to determine timezone
3. **Automatic Update**: `TimezoneManager` singleton manages the app-wide timezone
4. **All Methods Use GPS**: Most `TimezoneHelper` methods now use the GPS-detected timezone by default

## Migration from Old Static Approach

### ❌ OLD WAY (Static Enum)
```dart
// Old: Had to specify timezone manually
final nowInEgypt = TimezoneHelper.now(AppTimezone.egypt);
final nowInSaudi = TimezoneHelper.now(AppTimezone.saudiArabia);
final utc = TimezoneHelper.toUtc(nowInEgypt);
final egyptTime = TimezoneHelper.fromUtc(utc, AppTimezone.egypt);
```

### ✅ NEW WAY (GPS Dynamic)
```dart
// New: Uses GPS-detected timezone automatically
final now = TimezoneHelper.now(); // Auto-detects Egypt or Saudi
final utc = TimezoneHelper.toUtc(now);
final localTime = TimezoneHelper.fromUtc(utc); // Auto-uses user's timezone
```

## Key Changes

### 1. `now()` - Now GPS-Based by Default
```dart
// Uses GPS-detected timezone (Egypt or Saudi Arabia)
final currentTime = TimezoneHelper.now();
```

### 2. New `nowIn()` - For Specific Timezones
```dart
// If you still need a specific timezone
final egyptTime = TimezoneHelper.nowIn(AppTimezone.egypt);
final saudiTime = TimezoneHelper.nowIn(AppTimezone.saudiArabia);
```

### 3. `fromUtc()` - Simplified, GPS-Based
```dart
// Old way - required timezone parameter
final old = TimezoneHelper.fromUtc(utcTime, AppTimezone.egypt);

// New way - uses GPS-detected timezone
final new = TimezoneHelper.fromUtc(utcTime);
```

### 4. New `fromUtcTo()` - For Specific Timezone
```dart
// If you need to convert to a specific timezone
final egyptTime = TimezoneHelper.fromUtcTo(utcTime, AppTimezone.egypt);
```

## New GPS-Based Features

### Detect Timezone from Coordinates
```dart
// Detect timezone from any lat/lng
final timezone = TimezoneHelper.detectTimezoneFromCoordinates(
  latitude: 30.0444,   // Cairo
  longitude: 31.2357,
);
print(timezone); // AppTimezone.egypt
```

### Get Current GPS-Detected Timezone
```dart
final currentTimezone = TimezoneHelper.getCurrentTimezone();
print(currentTimezone); // AppTimezone.egypt or AppTimezone.saudiArabia

final timezoneName = TimezoneHelper.getCurrentTimezoneName();
print(timezoneName); // "Africa/Cairo" or "Asia/Riyadh"

final cityName = TimezoneHelper.getCurrentCityName();
print(cityName); // "Cairo" or "Riyadh" (from geocoding)
```

### Refresh Timezone Detection
```dart
// After user grants location permission or travels to new location
await TimezoneHelper.refreshTimezoneFromGps();
```

### Check Detection Status
```dart
if (TimezoneHelper.isDetectingTimezone) {
  print('Detecting timezone from GPS...');
}
```

### Manually Override Timezone
```dart
// Override GPS detection if needed
TimezoneHelper.setTimezone(AppTimezone.egypt, cityName: 'Cairo');
```

## Complete Usage Examples

### Example 1: Clock In/Out (Attendance)
```dart
// Clock In - uses GPS-detected timezone
final clockInTime = TimezoneHelper.now();

// Convert to UTC for storage
final utcForDatabase = TimezoneHelper.toUtc(clockInTime);

// Save to database
await saveToDatabase(utcForDatabase);

// Later: Display to user (converts to their GPS timezone)
final utcFromDb = await getFromDatabase();
final localTime = TimezoneHelper.fromUtc(utcFromDb);
final formatted = TimezoneHelper.format(localTime, pattern: 'hh:mm a');
```

### Example 2: Timezone-Aware Scheduling
```dart
// Create a meeting time in user's timezone
final meetingTime = TimezoneHelper.create(
  year: 2026,
  month: 1,
  day: 23,
  hour: 14,
  minute: 30,
);

// Convert to UTC for storage
final utcMeeting = TimezoneHelper.toUtc(meetingTime);
```

### Example 3: Cross-Timezone Comparison
```dart
// User in Egypt creates a task
final taskCreated = TimezoneHelper.now(); // Egypt time

// Show what time it is in Saudi Arabia
final saudiTime = TimezoneHelper.convertTimezone(
  taskCreated,
  AppTimezone.saudiArabia,
);
```

### Example 4: Handle User Location Change
```dart
// User travels from Cairo to Riyadh
// Pull to refresh on home screen
await TimezoneHelper.refreshTimezoneFromGps();

// Now all times will use Saudi Arabia timezone
final now = TimezoneHelper.now(); // Saudi time
```

## Important Notes

### 1. Initialization (Already Done in main.dart)
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize timezone database
  await TimezoneHelper.initialize();
  
  // Initialize TimezoneManager with GPS detection
  await TimezoneManager.instance.initialize();
  
  runApp(MyApp());
}
```

### 2. Default Fallback
- If GPS is unavailable: Defaults to **Saudi Arabia** timezone
- If location permission denied: Uses Saudi Arabia timezone
- Timezone detection happens in background during app startup

### 3. Permissions
- Location permission is requested in `main.dart`
- Pull-to-refresh on home screen re-checks GPS location
- No user interaction needed - automatic

### 4. Always Store UTC in Database
```dart
// ✅ CORRECT
final now = TimezoneHelper.now();
final utc = TimezoneHelper.toUtc(now);
await database.save(utc); // Store UTC

// ❌ WRONG
await database.save(now); // Don't store timezone-aware time
```

### 5. Always Display in Local Timezone
```dart
// ✅ CORRECT
final utcFromDb = await database.get();
final local = TimezoneHelper.fromUtc(utcFromDb); // Convert to user's timezone
displayToUser(local);

// ❌ WRONG
displayToUser(utcFromDb); // Don't show UTC to users
```

## Backward Compatibility

Old methods still work but are deprecated:

```dart
// Deprecated but still works
final now = TimezoneHelper.nowLocal(); 
// Use TimezoneHelper.now() instead
```

Methods that required `AppTimezone` parameter now have two versions:

```dart
// GPS-based (new, recommended)
final offset = TimezoneHelper.getTimezoneOffset();
final abbr = TimezoneHelper.getTimezoneAbbreviation();

// Specific timezone (if needed)
final egyptOffset = TimezoneHelper.getTimezoneOffsetFor(AppTimezone.egypt);
final egyptAbbr = TimezoneHelper.getTimezoneAbbreviationFor(AppTimezone.egypt);
```

## Testing the GPS Detection

### Test Timezone Detection Manually
```dart
// Simulate being in Cairo
final cairoTz = TimezoneHelper.detectTimezoneFromCoordinates(
  latitude: 30.0444,
  longitude: 31.2357,
);
assert(cairoTz == AppTimezone.egypt);

// Simulate being in Riyadh
final riyadhTz = TimezoneHelper.detectTimezoneFromCoordinates(
  latitude: 24.7136,
  longitude: 46.6753,
);
assert(riyadhTz == AppTimezone.saudiArabia);
```

### Check Current Detection
```dart
print('Current timezone: ${TimezoneHelper.getCurrentTimezone()}');
print('Timezone name: ${TimezoneHelper.getCurrentTimezoneName()}');
print('City: ${TimezoneHelper.getCurrentCityName()}');
print('UTC offset: ${TimezoneHelper.getTimezoneOffset()}');
print('Abbreviation: ${TimezoneHelper.getTimezoneAbbreviation()}');
```

## Summary

**Before**: Had to manually specify `AppTimezone.egypt` or `AppTimezone.saudiArabia` everywhere

**Now**: GPS automatically detects timezone, all methods use it by default

**Result**: More accurate, less code, automatic timezone updates when user travels

Your app now truly supports dynamic timezone detection based on GPS coordinates! 🎉

