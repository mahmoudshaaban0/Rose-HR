# Location Helper - Complete Documentation

## Overview

`LocationHelper` is a centralized utility class for handling all geolocation-related operations in the Rose HR application. It provides a clean, type-safe API for GPS operations, office location verification, and timezone detection based on geographic coordinates.

## Table of Contents

- [Core Features](#core-features)
- [Data Models](#data-models)
- [Permission Management](#permission-management)
- [Location Operations](#location-operations)
- [Office Management](#office-management)
- [Distance Calculations](#distance-calculations)
- [Timezone Detection](#timezone-detection)
- [Error Handling](#error-handling)
- [Usage Examples](#usage-examples)
- [Best Practices](#best-practices)

---

## Core Features

✅ **Permission Management**: Check and request location permissions  
✅ **GPS Location**: Get current user location with configurable accuracy  
✅ **Office Verification**: Check if user is within office premises  
✅ **Distance Calculations**: Calculate distances between coordinates  
✅ **Timezone Detection**: Automatically determine timezone from GPS  
✅ **Error Handling**: Comprehensive exception handling  
✅ **Settings Integration**: Open location/app settings when needed

---

## Data Models

### 1. LocationPermissionStatus

Enum representing the location permission state:

```dart
enum LocationPermissionStatus {
  granted,                    // User granted permission
  denied,                     // User denied permission (can ask again)
  deniedForever,             // User permanently denied (must use settings)
  locationServiceDisabled,   // GPS is disabled on device
}
```

### 2. LocationResult

Contains location data with utility methods:

```dart
class LocationResult {
  final Position position;      // Full Geolocator position object
  final double latitude;        // Latitude coordinate
  final double longitude;       // Longitude coordinate
  final double accuracy;        // Accuracy in meters
  final String? address;        // Optional address (if geocoding used)
  
  // Helper methods
  String get coordinates;       // Formatted as "(lat, lng)"
  bool isWithinRadius(...);     // Check if within radius of target
  double distanceTo(...);       // Distance to target location
}
```

### 3. OfficeLocation

Configuration for office locations:

```dart
class OfficeLocation {
  final String name;                 // Office name (e.g., "Cairo Office")
  final double latitude;             // Office latitude
  final double longitude;            // Office longitude
  final double allowedRadiusMeters;  // Allowed check-in radius (default: 100m)
  
  // Helper methods
  bool isLocationInOffice(LocationResult location);
  double distanceFromOffice(LocationResult location);
}
```

**Predefined Offices:**
- `LocationHelper.cairoOffice` - Cairo Office (Egypt)
- `LocationHelper.riyadhOffice` - Riyadh Office (Saudi Arabia)

---

## Permission Management

### Check Permission Status

Check current permission without requesting:

```dart
final status = await LocationHelper.checkPermission();

switch (status) {
  case LocationPermissionStatus.granted:
    // Permission granted, can get location
    break;
  case LocationPermissionStatus.denied:
    // Can request permission again
    break;
  case LocationPermissionStatus.deniedForever:
    // Must open settings
    break;
  case LocationPermissionStatus.locationServiceDisabled:
    // GPS is turned off
    break;
}
```

### Request Permission

Request permission from user:

```dart
final status = await LocationHelper.requestPermission();

if (status == LocationPermissionStatus.granted) {
  // Permission granted, proceed with location operations
}
```

### Open Settings

When permission is denied forever or GPS is disabled:

```dart
// Open location settings (to enable GPS)
await LocationHelper.openLocationSettings();

// Open app settings (to enable permission)
await LocationHelper.openAppSettings();
```

### Check if GPS is Enabled

```dart
final isEnabled = await LocationHelper.isLocationServiceEnabled();
if (!isEnabled) {
  // Prompt user to enable GPS
}
```

---

## Location Operations

### Get Current Location

Get user's current GPS location:

```dart
try {
  final location = await LocationHelper.getCurrentLocation();
  print('Latitude: ${location.latitude}');
  print('Longitude: ${location.longitude}');
  print('Accuracy: ${location.accuracy}m');
} on LocationServiceDisabledException {
  // GPS is disabled
} on PermissionDeniedException {
  // Permission denied
}
```

**With Custom Settings:**

```dart
final location = await LocationHelper.getCurrentLocation(
  accuracy: LocationAccuracy.high,    // Medium accuracy (faster)
  timeLimit: Duration(seconds: 5),    // 5 second timeout
);
```

**Accuracy Levels:**
- `LocationAccuracy.best` - Highest accuracy (default, ~0-100m)
- `LocationAccuracy.high` - High accuracy (~100m)
- `LocationAccuracy.medium` - Medium accuracy (~100-500m)
- `LocationAccuracy.low` - Low accuracy (~1-3km)
- `LocationAccuracy.lowest` - Lowest accuracy (~3km+)

### Get Last Known Location

Faster but may be outdated:

```dart
final location = await LocationHelper.getLastKnownLocation();

if (location != null) {
  print('Last known: ${location.coordinates}');
} else {
  print('No last known location available');
}
```

### Request Permission and Get Location

Convenience method combining both operations:

```dart
final location = await LocationHelper.requestPermissionAndGetLocation();

if (location != null) {
  // Permission granted and location obtained
  print('Location: ${location.coordinates}');
} else {
  // Permission denied or location unavailable
}
```

---

## Office Management

### Configure Office Locations

Update office coordinates in `location_helper.dart`:

```dart
static const OfficeLocation cairoOffice = OfficeLocation(
  name: 'Cairo Office',
  latitude: 30.0444,          // YOUR ACTUAL LATITUDE
  longitude: 31.2357,         // YOUR ACTUAL LONGITUDE
  allowedRadiusMeters: 100,   // Check-in radius
);
```

### Check if User is at Office

```dart
// Check if at specific office
final isAtCairo = await LocationHelper.isUserAtOffice(
  LocationHelper.cairoOffice,
);

if (isAtCairo) {
  // User is within office radius
}
```

### Get Distance to Office

```dart
final distance = await LocationHelper.getDistanceToOffice(
  LocationHelper.riyadhOffice,
);

if (distance != null) {
  print('Distance: ${LocationHelper.formatDistance(distance)}');
  // Output: "250m" or "1.5km"
}
```

### Get Closest Office

Determine which office the user is closest to:

```dart
final closestOffice = await LocationHelper.getClosestOffice();
print('Closest office: ${closestOffice.name}');

// Use closest office for operations
final isAtOffice = await LocationHelper.isUserAtOffice(closestOffice);
```

### Manual Distance Check

Using a `LocationResult` object:

```dart
final location = await LocationHelper.getCurrentLocation();
final office = LocationHelper.cairoOffice;

// Check if within office radius
if (office.isLocationInOffice(location)) {
  print('Inside office!');
}

// Get exact distance
final distance = office.distanceFromOffice(location);
print('Distance: ${distance}m');
```

---

## Distance Calculations

### Between Two Coordinates

```dart
final distance = LocationHelper.calculateDistance(
  startLat: 30.0444,
  startLng: 31.2357,
  endLat: 24.7136,
  endLng: 46.6753,
);
print('Distance: ${distance}m');
```

### In Kilometers

```dart
final distanceKm = LocationHelper.calculateDistanceInKm(
  startLat: 30.0444,
  startLng: 31.2357,
  endLat: 24.7136,
  endLng: 46.6753,
);
print('Distance: ${distanceKm}km');
```

### Format Distance String

```dart
final distance = 1500.0; // meters

final formatted = LocationHelper.formatDistance(distance);
print(formatted); // "1.50km"

final shortDistance = LocationHelper.formatDistance(250.0);
print(shortDistance); // "250m"
```

### Using LocationResult

```dart
final userLocation = await LocationHelper.getCurrentLocation();

// Distance to a target
final distance = userLocation.distanceTo(
  targetLat: 30.0444,
  targetLng: 31.2357,
);

// Check if within radius
final isNearby = userLocation.isWithinRadius(
  targetLat: 30.0444,
  targetLng: 31.2357,
  radiusInMeters: 500, // 500m radius
);
```

---

## Timezone Detection

### Get Timezone from Current Location

Automatically detects timezone based on proximity to offices:

```dart
final timezone = await LocationHelper.getTimezoneFromLocation();

// Returns AppTimezone.egypt or AppTimezone.saudiArabia
// based on which office is closer

final now = TimezoneHelper.now(timezone);
print('Current time in detected timezone: $now');
```

### Get Timezone from Coordinates

```dart
final timezone = LocationHelper.getTimezoneFromCoordinates(
  30.0444, // latitude
  31.2357, // longitude
);

// Returns: AppTimezone.egypt (closer to Cairo)
```

**How it Works:**
- Calculates distance to Cairo Office and Riyadh Office
- Returns timezone of the closer office
- Cairo Office → `AppTimezone.egypt` (Africa/Cairo, UTC+2)
- Riyadh Office → `AppTimezone.saudiArabia` (Asia/Riyadh, UTC+3)

### Get Timezone with Location Name

Get both timezone and Arabic location name:

```dart
final result = await LocationHelper.getTimezoneWithLocationName();

print('Timezone: ${result.timezone}');      // AppTimezone.egypt
print('Location: ${result.locationName}');  // "القاهرة" or "الرياض"

// Use with TimezoneHelper
final now = TimezoneHelper.now(result.timezone);
```

**Use Cases:**
- Display current timezone to user
- Show location badge in UI
- Automatic timezone selection for attendance
- Time conversion based on user location

---

## Error Handling

### Exceptions

The helper uses Geolocator's built-in exceptions:

```dart
try {
  final location = await LocationHelper.getCurrentLocation();
} on LocationServiceDisabledException {
  // GPS is disabled on device
  print('Please enable location services');
  await LocationHelper.openLocationSettings();
} on PermissionDeniedException catch (e) {
  // Permission denied
  print('Location permission denied: ${e.message}');
  final status = await LocationHelper.checkPermission();
  
  if (status == LocationPermissionStatus.deniedForever) {
    // Must use settings
    await LocationHelper.openAppSettings();
  }
} on TimeoutException {
  // Location request timed out
  print('Location request timed out');
} catch (e) {
  // Other errors
  print('Location error: $e');
}
```

### Safe Operations

Methods that return null instead of throwing:

```dart
// Returns null if location unavailable
final lastKnown = await LocationHelper.getLastKnownLocation();

// Returns null if location or permission unavailable
final location = await LocationHelper.requestPermissionAndGetLocation();

// Returns null if location unavailable
final distance = await LocationHelper.getDistanceToOffice(office);

// Returns false if location unavailable
final isAtOffice = await LocationHelper.isUserAtOffice(office);
```

### Timezone Detection Fallback

Timezone methods default to Saudi Arabia if location fails:

```dart
// Falls back to AppTimezone.saudiArabia on error
final timezone = await LocationHelper.getTimezoneFromLocation();

// Falls back to (AppTimezone.saudiArabia, 'الرياض') on error
final result = await LocationHelper.getTimezoneWithLocationName();

// Falls back to riyadhOffice on error
final office = await LocationHelper.getClosestOffice();
```

---

## Usage Examples

### Example 1: Complete Clock-In Flow

```dart
Future<void> handleClockIn() async {
  // 1. Check permission
  final permissionStatus = await LocationHelper.checkPermission();
  
  if (permissionStatus != LocationPermissionStatus.granted) {
    // Request permission
    final newStatus = await LocationHelper.requestPermission();
    
    if (newStatus == LocationPermissionStatus.deniedForever) {
      // Open settings
      await LocationHelper.openAppSettings();
      return;
    }
    
    if (newStatus != LocationPermissionStatus.granted) {
      print('Permission denied');
      return;
    }
  }
  
  try {
    // 2. Get location
    final location = await LocationHelper.getCurrentLocation();
    
    // 3. Get timezone
    final result = await LocationHelper.getTimezoneWithLocationName();
    
    // 4. Check if at office
    final closestOffice = await LocationHelper.getClosestOffice();
    final isAtOffice = closestOffice.isLocationInOffice(location);
    final distance = closestOffice.distanceFromOffice(location);
    
    // 5. Create attendance record
    final attendance = AttendanceRecord(
      id: uuid.v4(),
      employeeId: currentUser.id,
      clockInUtc: TimezoneHelper.toUtc(
        TimezoneHelper.now(result.timezone),
      ),
      clockInTimezone: result.timezone.locationName,
      clockInLatitude: location.latitude,
      clockInLongitude: location.longitude,
      officeName: closestOffice.name,
      isLocationVerified: isAtOffice,
      distanceFromOfficeMeters: distance,
    );
    
    // 6. Save to database
    await attendanceRepository.save(attendance);
    
    print('Clock in successful!');
    print('Office: ${closestOffice.name}');
    print('Distance: ${LocationHelper.formatDistance(distance)}');
    
  } on LocationServiceDisabledException {
    print('Please enable GPS');
    await LocationHelper.openLocationSettings();
  } on PermissionDeniedException {
    print('Location permission required');
  }
}
```

### Example 2: Location Verification with UI

```dart
class ClockInScreen extends StatefulWidget {
  @override
  _ClockInScreenState createState() => _ClockInScreenState();
}

class _ClockInScreenState extends State<ClockInScreen> {
  LocationResult? _location;
  OfficeLocation? _nearestOffice;
  double? _distance;
  bool _isAtOffice = false;
  
  @override
  void initState() {
    super.initState();
    _checkLocation();
  }
  
  Future<void> _checkLocation() async {
    try {
      final location = await LocationHelper.getCurrentLocation();
      final office = await LocationHelper.getClosestOffice();
      final distance = office.distanceFromOffice(location);
      final isAtOffice = office.isLocationInOffice(location);
      
      setState(() {
        _location = location;
        _nearestOffice = office;
        _distance = distance;
        _isAtOffice = isAtOffice;
      });
    } catch (e) {
      print('Location error: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (_location != null) ...[
            Text('Location: ${_location!.coordinates}'),
            Text('Accuracy: ${_location!.accuracy}m'),
            Text('Nearest: ${_nearestOffice?.name}'),
            Text('Distance: ${LocationHelper.formatDistance(_distance ?? 0)}'),
            
            if (_isAtOffice)
              Text('✓ In Office', style: TextStyle(color: Colors.green))
            else
              Text('✗ Out of Office', style: TextStyle(color: Colors.red)),
          ],
          
          ElevatedButton(
            onPressed: _isAtOffice ? _clockIn : null,
            child: Text('Clock In'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _clockIn() async {
    // Implement clock-in logic
  }
}
```

### Example 3: Dynamic Timezone Display

```dart
class TimezoneWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocationHelper.getTimezoneWithLocationName(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        
        final result = snapshot.data!;
        final now = TimezoneHelper.now(result.timezone);
        final formatted = TimezoneHelper.format(
          now,
          pattern: 'hh:mm a',
        );
        
        return Column(
          children: [
            Text(formatted, style: TextStyle(fontSize: 24)),
            Row(
              children: [
                Icon(Icons.location_on),
                Text(result.locationName),
              ],
            ),
          ],
        );
      },
    );
  }
}
```

---

## Best Practices

### 1. **Always Check Permissions First**

```dart
// ✅ Good
final status = await LocationHelper.checkPermission();
if (status == LocationPermissionStatus.granted) {
  final location = await LocationHelper.getCurrentLocation();
}

// ❌ Bad - May throw exception
final location = await LocationHelper.getCurrentLocation();
```

### 2. **Handle All Permission States**

```dart
final status = await LocationHelper.requestPermission();

switch (status) {
  case LocationPermissionStatus.granted:
    // Proceed with location operations
    break;
  case LocationPermissionStatus.denied:
    // Show explanation and ask again later
    break;
  case LocationPermissionStatus.deniedForever:
    // Direct user to settings
    await LocationHelper.openAppSettings();
    break;
  case LocationPermissionStatus.locationServiceDisabled:
    // Direct user to enable GPS
    await LocationHelper.openLocationSettings();
    break;
}
```

### 3. **Use Try-Catch for Location Operations**

```dart
try {
  final location = await LocationHelper.getCurrentLocation();
  // Use location
} on LocationServiceDisabledException {
  // Handle GPS disabled
} on PermissionDeniedException {
  // Handle permission denied
} catch (e) {
  // Handle other errors
}
```

### 4. **Configure Appropriate Accuracy**

```dart
// For attendance (high accuracy needed)
final location = await LocationHelper.getCurrentLocation(
  accuracy: LocationAccuracy.best,
  timeLimit: Duration(seconds: 10),
);

// For general location display (faster)
final location = await LocationHelper.getCurrentLocation(
  accuracy: LocationAccuracy.medium,
  timeLimit: Duration(seconds: 5),
);
```

### 5. **Store Timezone with Location Data**

```dart
// ✅ Good - Store timezone for accurate time display later
final result = await LocationHelper.getTimezoneWithLocationName();
final attendance = AttendanceRecord(
  clockInUtc: TimezoneHelper.toUtc(TimezoneHelper.now(result.timezone)),
  clockInTimezone: result.timezone.locationName, // Store timezone
  clockInLatitude: location.latitude,
  clockInLongitude: location.longitude,
);

// ❌ Bad - Hard to display correct time later
final attendance = AttendanceRecord(
  clockInUtc: DateTime.now().toUtc(), // Missing timezone context
);
```

### 6. **Update Office Coordinates**

Before deployment, update with actual office coordinates:

```dart
static const OfficeLocation cairoOffice = OfficeLocation(
  name: 'Cairo Office',
  latitude: 30.0444,  // ← UPDATE THIS
  longitude: 31.2357, // ← UPDATE THIS
  allowedRadiusMeters: 100,
);
```

### 7. **Use Safe Methods for Optional Operations**

```dart
// Use safe methods when location might be unavailable
final lastKnown = await LocationHelper.getLastKnownLocation();
if (lastKnown != null) {
  // Use cached location
}

// Or provide fallback
final timezone = await LocationHelper.getTimezoneFromLocation();
// Automatically falls back to Saudi Arabia if GPS unavailable
```

### 8. **Combine with TimezoneHelper**

Always use together for timezone-aware operations:

```dart
// Get timezone from location
final result = await LocationHelper.getTimezoneWithLocationName();

// Use with TimezoneHelper for accurate time
final now = TimezoneHelper.now(result.timezone);
final formatted = TimezoneHelper.format(now, pattern: 'hh:mm a');
```

---

## Integration with Other Helpers

### With TimezoneHelper

```dart
// Get location-based timezone
final timezone = await LocationHelper.getTimezoneFromLocation();

// Use with TimezoneHelper
final now = TimezoneHelper.now(timezone);
final utc = TimezoneHelper.toUtc(now);
```

### With AttendanceRecord

```dart
final location = await LocationHelper.getCurrentLocation();
final result = await LocationHelper.getTimezoneWithLocationName();
final closestOffice = await LocationHelper.getClosestOffice();

final record = AttendanceRecord(
  clockInUtc: TimezoneHelper.toUtc(TimezoneHelper.now(result.timezone)),
  clockInTimezone: result.timezone.locationName,
  clockInLatitude: location.latitude,
  clockInLongitude: location.longitude,
  officeName: closestOffice.name,
  isLocationVerified: closestOffice.isLocationInOffice(location),
  distanceFromOfficeMeters: closestOffice.distanceFromOffice(location),
);
```

---

## Platform Configuration

### Android (android/app/src/main/AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS (ios/Runner/Info.plist)

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Rose HR needs your location to verify attendance at office</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Rose HR needs your location to verify attendance at office</string>
```

---

## Dependencies

```yaml
dependencies:
  geolocator: ^10.0.0  # GPS location functionality
```

---

## Quick Reference

| Task | Method |
|------|--------|
| Check permission | `await LocationHelper.checkPermission()` |
| Request permission | `await LocationHelper.requestPermission()` |
| Get current location | `await LocationHelper.getCurrentLocation()` |
| Get last known location | `await LocationHelper.getLastKnownLocation()` |
| Check if at office | `await LocationHelper.isUserAtOffice(office)` |
| Get distance to office | `await LocationHelper.getDistanceToOffice(office)` |
| Get closest office | `await LocationHelper.getClosestOffice()` |
| Get timezone | `await LocationHelper.getTimezoneFromLocation()` |
| Get timezone + name | `await LocationHelper.getTimezoneWithLocationName()` |
| Calculate distance | `LocationHelper.calculateDistance(...)` |
| Format distance | `LocationHelper.formatDistance(meters)` |
| Open location settings | `await LocationHelper.openLocationSettings()` |
| Open app settings | `await LocationHelper.openAppSettings()` |

---

## Summary

`LocationHelper` provides a complete, production-ready solution for location-based operations in the Rose HR app. It handles permissions, GPS operations, office verification, and timezone detection with comprehensive error handling and a clean API.

**Key Advantages:**
- ✅ Type-safe API
- ✅ Comprehensive error handling
- ✅ Built-in fallbacks
- ✅ Integration with timezone system
- ✅ Production-ready
- ✅ Well-documented
- ✅ Easy to test

For timezone-specific operations, see [TimezoneHelper Documentation](TIMEZONE_USAGE_EXAMPLES.md).

