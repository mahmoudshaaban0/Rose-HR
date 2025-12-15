# Location Helper - Complete Usage Guide

This guide shows how to use geolocation with timezone-aware timestamps for complete attendance tracking.

## Overview

The location system combines:
- **LocationHelper**: Get user location, verify office presence
- **TimezoneHelper**: Accurate timezone-aware timestamps
- **AttendanceRecord**: Complete model with location + time data

## Setup Office Locations

First, update office coordinates in `location_helper.dart`:

```dart
// Update with actual office coordinates
static const OfficeLocation cairoOffice = OfficeLocation(
  name: 'Cairo Office',
  latitude: 30.0444,  // YOUR ACTUAL LATITUDE
  longitude: 31.2357, // YOUR ACTUAL LONGITUDE
  allowedRadiusMeters: 100,
);

static const OfficeLocation riyadhOffice = OfficeLocation(
  name: 'Riyadh Office',
  latitude: 24.7136,  // YOUR ACTUAL LATITUDE
  longitude: 46.6753, // YOUR ACTUAL LONGITUDE
  allowedRadiusMeters: 100,
);
```

## Common Use Cases

### 1. Complete Clock In Flow

```dart
import 'package:rose_hr/common/helpers/location_helper.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/common/models/attendance_record.dart';

Future<AttendanceRecord?> handleClockIn(String employeeId) async {
  // Step 1: Check location permission
  final permissionStatus = await LocationHelper.checkPermission();
  
  if (permissionStatus != LocationPermissionStatus.granted) {
    // Request permission
    final requested = await LocationHelper.requestPermission();
    
    if (requested != LocationPermissionStatus.granted) {
      print('Location permission denied');
      return null;
    }
  }
  
  // Step 2: Get current location
  try {
    final location = await LocationHelper.getCurrentLocation();
    
    // Step 3: Verify at office (for Egypt employee)
    final office = LocationHelper.cairoOffice;
    final isAtOffice = office.isLocationInOffice(location);
    
    if (!isAtOffice) {
      final distance = office.distanceFromOffice(location);
      print('Not at office! Distance: ${LocationHelper.formatDistance(distance)}');
      // Optionally: Allow or deny based on business rules
    }
    
    // Step 4: Create attendance record with timezone + location
    final builder = AttendanceRecordBuilder(
      employeeId: employeeId,
      timezone: AppTimezone.egypt,
    );
    
    final record = await builder.clockIn(
      location: location,
      office: office,
    );
    
    print('Clocked in: ${record.getFormattedClockIn()}');
    print('Location: ${record.clockInCoordinates}');
    print('Verified: ${record.isLocationVerified}');
    
    // Step 5: Save to database/API
    // await attendanceRepository.save(record.toJson());
    
    return record;
  } catch (e) {
    print('Error getting location: $e');
    return null;
  }
}
```

### 2. Complete Clock Out Flow

```dart
Future<AttendanceRecord?> handleClockOut(
  String employeeId,
  AttendanceRecord existingRecord,
) async {
  // Get current location
  try {
    final location = await LocationHelper.getCurrentLocation();
    
    // Update record with clock out
    final builder = AttendanceRecordBuilder(
      employeeId: employeeId,
      timezone: AppTimezone.egypt,
    );
    
    final updatedRecord = builder.clockOut(
      record: existingRecord,
      location: location,
    );
    
    print('Clocked out: ${updatedRecord.getFormattedClockOut()}');
    print('Work duration: ${updatedRecord.getFormattedWorkDuration()}');
    
    // Save to database
    // await attendanceRepository.update(updatedRecord.toJson());
    
    return updatedRecord;
  } catch (e) {
    print('Error during clock out: $e');
    return null;
  }
}
```

### 3. Permission Handling UI Flow

```dart
class ClockInButton extends StatefulWidget {
  @override
  _ClockInButtonState createState() => _ClockInButtonState();
}

class _ClockInButtonState extends State<ClockInButton> {
  bool _isLoading = false;

  Future<void> _handleClockIn() async {
    setState(() => _isLoading = true);

    // Check permission
    final permissionStatus = await LocationHelper.checkPermission();

    if (permissionStatus == LocationPermissionStatus.locationServiceDisabled) {
      // Show dialog to enable location services
      _showLocationServiceDialog();
      setState(() => _isLoading = false);
      return;
    }

    if (permissionStatus == LocationPermissionStatus.deniedForever) {
      // Show dialog to open settings
      _showOpenSettingsDialog();
      setState(() => _isLoading = false);
      return;
    }

    if (permissionStatus == LocationPermissionStatus.denied) {
      // Request permission
      final requested = await LocationHelper.requestPermission();
      
      if (requested != LocationPermissionStatus.granted) {
        _showPermissionDeniedDialog();
        setState(() => _isLoading = false);
        return;
      }
    }

    // Permission granted, proceed with clock in
    final record = await handleClockIn('EMPLOYEE_ID');
    
    setState(() => _isLoading = false);

    if (record != null) {
      _showSuccessMessage(record);
    }
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Location Services Disabled'),
        content: Text('Please enable location services to clock in.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await LocationHelper.openLocationSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showOpenSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Location Permission Required'),
        content: Text(
          'Location permission is required for attendance. '
          'Please enable it in app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await LocationHelper.openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Denied'),
        content: Text('Location permission is required to clock in.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(AttendanceRecord record) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Clocked in at ${record.getFormattedClockIn()}\n'
          '${record.isLocationVerified ? "✓" : "⚠"} '
          '${record.isLocationVerified ? "At office" : "Away from office"}',
        ),
        backgroundColor: record.isLocationVerified ? Colors.green : Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleClockIn,
      child: _isLoading
          ? CircularProgressIndicator()
          : Text('Clock In'),
    );
  }
}
```

### 4. Check If At Office Before Allowing Clock In

```dart
Future<bool> verifyOfficeLocation() async {
  try {
    // Get current location
    final location = await LocationHelper.getCurrentLocation();
    
    // Check if at Cairo office
    final isAtCairoOffice = LocationHelper.cairoOffice.isLocationInOffice(location);
    
    // Check if at Riyadh office
    final isAtRiyadhOffice = LocationHelper.riyadhOffice.isLocationInOffice(location);
    
    if (isAtCairoOffice) {
      print('✓ At Cairo Office');
      return true;
    } else if (isAtRiyadhOffice) {
      print('✓ At Riyadh Office');
      return true;
    } else {
      // Calculate distance to nearest office
      final distanceToCairo = LocationHelper.cairoOffice.distanceFromOffice(location);
      final distanceToRiyadh = LocationHelper.riyadhOffice.distanceFromOffice(location);
      final nearestDistance = distanceToCairo < distanceToRiyadh 
          ? distanceToCairo 
          : distanceToRiyadh;
      
      print('⚠ Not at office. Distance: ${LocationHelper.formatDistance(nearestDistance)}');
      return false;
    }
  } catch (e) {
    print('Error verifying location: $e');
    return false;
  }
}
```

### 5. Display Location Status

```dart
class LocationStatusWidget extends StatefulWidget {
  @override
  _LocationStatusWidgetState createState() => _LocationStatusWidgetState();
}

class _LocationStatusWidgetState extends State<LocationStatusWidget> {
  LocationResult? _currentLocation;
  String? _statusMessage;
  bool _isAtOffice = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _updateLocation();
  }

  Future<void> _updateLocation() async {
    setState(() => _isLoading = true);

    try {
      final location = await LocationHelper.getCurrentLocation();
      final office = LocationHelper.cairoOffice; // Or determine based on employee
      final isAtOffice = office.isLocationInOffice(location);
      final distance = office.distanceFromOffice(location);

      setState(() {
        _currentLocation = location;
        _isAtOffice = isAtOffice;
        _statusMessage = isAtOffice
            ? '✓ At ${office.name}'
            : '⚠ ${LocationHelper.formatDistance(distance)} from ${office.name}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Unable to get location';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Location Status', style: TextStyle(fontSize: 18)),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _isLoading ? null : _updateLocation,
                ),
              ],
            ),
            SizedBox(height: 8),
            if (_isLoading)
              CircularProgressIndicator()
            else if (_statusMessage != null) ...[
              Row(
                children: [
                  Icon(
                    _isAtOffice ? Icons.check_circle : Icons.warning,
                    color: _isAtOffice ? Colors.green : Colors.orange,
                  ),
                  SizedBox(width: 8),
                  Expanded(child: Text(_statusMessage!)),
                ],
              ),
              if (_currentLocation != null) ...[
                SizedBox(height: 8),
                Text(
                  'Coordinates: ${_currentLocation!.coordinates}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'Accuracy: ±${_currentLocation!.accuracy.toStringAsFixed(0)}m',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
```

### 6. Get Today's Attendance with Location

```dart
Future<List<AttendanceRecord>> getTodayAttendance(String employeeId) async {
  // Get today's boundaries in employee timezone
  final now = TimezoneHelper.now(AppTimezone.egypt);
  final startOfDay = TimezoneHelper.startOfDay(now);
  final endOfDay = TimezoneHelper.endOfDay(now);
  
  // Convert to UTC for query
  final startUtc = TimezoneHelper.toUtc(startOfDay);
  final endUtc = TimezoneHelper.toUtc(endOfDay);
  
  // Query database
  // final records = await attendanceRepository.getRecordsBetween(
  //   employeeId: employeeId,
  //   startUtc: startUtc,
  //   endUtc: endUtc,
  // );
  
  // For each record, you can access:
  // - record.getClockInLocal() - Local time
  // - record.clockInCoordinates - Location
  // - record.isLocationVerified - Whether at office
  // - record.distanceFromOfficeMeters - Distance from office
  
  return []; // Replace with actual query
}
```

### 7. Background Location (Optional - for continuous tracking)

```dart
// For continuous background tracking, you might want to use
// geolocator's position stream

StreamSubscription<Position>? _positionStreamSubscription;

void startLocationTracking() {
  const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // Update every 10 meters
  );

  _positionStreamSubscription = Geolocator.getPositionStream(
    locationSettings: locationSettings,
  ).listen((Position position) {
    print('New position: ${position.latitude}, ${position.longitude}');
    
    // Check if still at office
    final location = LocationResult(
      position: position,
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
    );
    
    final isAtOffice = LocationHelper.cairoOffice.isLocationInOffice(location);
    
    if (!isAtOffice) {
      print('⚠ Employee left office area');
      // Trigger notification or alert
    }
  });
}

void stopLocationTracking() {
  _positionStreamSubscription?.cancel();
}
```

## Best Practices

### ✅ DO:

1. **Always request permission before accessing location**
   ```dart
   final status = await LocationHelper.checkPermission();
   if (status != LocationPermissionStatus.granted) {
     await LocationHelper.requestPermission();
   }
   ```

2. **Handle all permission states**
   - Granted: Proceed
   - Denied: Request again with explanation
   - Denied Forever: Direct to settings
   - Service Disabled: Prompt to enable location services

3. **Store both timezone and location data**
   ```dart
   final record = AttendanceRecord(
     clockInUtc: utcTimestamp,
     clockInTimezone: 'Africa/Cairo',
     clockInLatitude: location.latitude,
     clockInLongitude: location.longitude,
   );
   ```

4. **Verify location accuracy**
   ```dart
   if (location.accuracy > 50) {
     print('⚠ Low accuracy: ±${location.accuracy}m');
     // Maybe request location again
   }
   ```

5. **Use last known location as fallback**
   ```dart
   var location = await LocationHelper.getCurrentLocation();
   if (location == null) {
     location = await LocationHelper.getLastKnownLocation();
   }
   ```

### ❌ DON'T:

1. **Don't access location without permission**
   ```dart
   // BAD
   final location = await LocationHelper.getCurrentLocation();
   
   // GOOD
   if (await LocationHelper.checkPermission() == LocationPermissionStatus.granted) {
     final location = await LocationHelper.getCurrentLocation();
   }
   ```

2. **Don't store location without timezone**
   ```dart
   // BAD - no timezone context
   clockIn: DateTime.now()
   
   // GOOD - with timezone
   clockInUtc: TimezoneHelper.toUtc(localTime),
   clockInTimezone: 'Africa/Cairo'
   ```

3. **Don't block UI while getting location**
   ```dart
   // Use async/await and show loading indicator
   setState(() => _isLoading = true);
   final location = await LocationHelper.getCurrentLocation();
   setState(() => _isLoading = false);
   ```

## Office Location Configuration

Update office coordinates in `location_helper.dart`:

### How to Get Coordinates:

1. **Google Maps**: Right-click on location → First two numbers
2. **iOS Maps**: Drop a pin → Swipe up → Copy coordinates
3. **GPS apps**: Use any GPS app to get exact coordinates

### Recommended Radius:

- **Small office**: 50-100 meters
- **Large campus**: 200-500 meters
- **Remote work**: Can be more flexible

## Error Handling

```dart
Future<LocationResult?> safeGetLocation() async {
  try {
    return await LocationHelper.getCurrentLocation();
  } on LocationServiceDisabledException {
    print('Location services are disabled');
    return null;
  } on PermissionDeniedException {
    print('Location permission denied');
    return null;
  } catch (e) {
    print('Unknown error: $e');
    return null;
  }
}
```

## Testing

### Test Location in Emulator/Simulator:

**iOS Simulator:**
- Debug → Location → Custom Location → Enter coordinates

**Android Emulator:**
- Extended controls (•••) → Location → Enter coordinates

### Test Different Scenarios:

1. At office (within radius)
2. Near office (outside radius)
3. Far from office
4. Permission denied
5. Location services disabled
6. Poor GPS accuracy

## Complete Example: Clock In Screen

```dart
class ClockInScreen extends StatefulWidget {
  @override
  _ClockInScreenState createState() => _ClockInScreenState();
}

class _ClockInScreenState extends State<ClockInScreen> {
  bool _isLoading = false;
  LocationResult? _currentLocation;
  bool _isAtOffice = false;

  Future<void> _clockIn() async {
    setState(() => _isLoading = true);

    // 1. Check permission
    var permissionStatus = await LocationHelper.checkPermission();
    
    if (permissionStatus != LocationPermissionStatus.granted) {
      permissionStatus = await LocationHelper.requestPermission();
      
      if (permissionStatus != LocationPermissionStatus.granted) {
        _showError('Location permission required');
        setState(() => _isLoading = false);
        return;
      }
    }

    // 2. Get location
    try {
      final location = await LocationHelper.getCurrentLocation();
      final office = LocationHelper.cairoOffice;
      final isAtOffice = office.isLocationInOffice(location);

      setState(() {
        _currentLocation = location;
        _isAtOffice = isAtOffice;
      });

      // 3. Create attendance record
      final builder = AttendanceRecordBuilder(
        employeeId: 'EMP123',
        timezone: AppTimezone.egypt,
      );

      final record = await builder.clockIn(
        location: location,
        office: office,
      );

      // 4. Save to API
      // await api.clockIn(record.toJson());

      // 5. Show success
      _showSuccess(record);
      
    } catch (e) {
      _showError('Failed to get location: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccess(AttendanceRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('✓ Clocked In'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time: ${record.getFormattedClockIn()}'),
            Text('Location: ${record.isLocationVerified ? "At office" : "Away from office"}'),
            if (!record.isLocationVerified && record.distanceFromOfficeMeters != null)
              Text(
                'Distance: ${LocationHelper.formatDistance(record.distanceFromOfficeMeters!)}',
                style: TextStyle(color: Colors.orange),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clock In')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_currentLocation != null) ...[
              Icon(
                _isAtOffice ? Icons.check_circle : Icons.warning,
                size: 64,
                color: _isAtOffice ? Colors.green : Colors.orange,
              ),
              SizedBox(height: 16),
              Text(_isAtOffice ? 'At Office' : 'Away from Office'),
              SizedBox(height: 32),
            ],
            ElevatedButton(
              onPressed: _isLoading ? null : _clockIn,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Clock In'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Security Considerations

1. **Never expose office coordinates** in public APIs
2. **Validate location on backend** - don't trust client-side verification alone
3. **Store location encrypted** if sensitive
4. **Limit location access** - only when needed for attendance

## Further Reading

- [Geolocator Package](https://pub.dev/packages/geolocator)
- [Android Location Permissions](https://developer.android.com/training/location/permissions)
- [iOS Location Permissions](https://developer.apple.com/documentation/corelocation/requesting_authorization_to_use_location_services)

