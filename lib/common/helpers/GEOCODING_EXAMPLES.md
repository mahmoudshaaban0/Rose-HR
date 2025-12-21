# Geocoding Examples - Address & City from GPS

## Overview

The `LocationHelper` now includes geocoding functionality to convert GPS coordinates into human-readable addresses and city names. This is automatically integrated into the `TimezoneCubit` for display.

---

## Quick Usage

### Get Current City Name

```dart
final city = await LocationHelper.getCurrentCity();
print('Current city: $city'); // e.g., "Riyadh", "Cairo"
```

### Get Location with Full Address

```dart
final location = await LocationHelper.getCurrentLocationWithAddress();

print('City: ${location.city}');
print('Country: ${location.country}');
print('Street: ${location.street}');
print('Full Address: ${location.formattedAddress}');
```

### Get Address from Coordinates

```dart
final placemark = await LocationHelper.getAddressFromCoordinates(
  latitude: 24.7136,
  longitude: 46.6753,
);

if (placemark != null) {
  print('City: ${placemark.locality}');
  print('Country: ${placemark.country}');
  print('Street: ${placemark.street}');
}
```

---

## Integration with TimezoneCubit

The geocoding is **automatically integrated** into the app:

```dart
class HeaderAndShiftSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimezoneCubit(), // Automatically fetches city
      child: BlocBuilder<TimezoneCubit, TimezoneState>(
        builder: (context, state) {
          if (state is TimezoneLoaded) {
            // City name from geocoding
            final cityName = state.cityName ?? state.locationName;
            
            return Text(cityName); // Shows real city like "Riyadh"
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
```

**How it works:**
1. User opens the app
2. `TimezoneCubit` gets GPS location
3. Determines timezone (Egypt/Saudi Arabia) based on proximity
4. **Calls geocoding API** to get real city name
5. Displays the actual city name in the UI

---

## Detailed Examples

### Example 1: Show City and Address in UI

```dart
class LocationDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationResult>(
      future: LocationHelper.getCurrentLocationWithAddress(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        
        if (!snapshot.hasData) {
          return Text('Location unavailable');
        }
        
        final location = snapshot.data!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('City: ${location.city ?? "Unknown"}'),
            Text('Country: ${location.country ?? "Unknown"}'),
            if (location.street != null)
              Text('Street: ${location.street}'),
            if (location.formattedAddress != null)
              Text('Address: ${location.formattedAddress}'),
            Text('Coordinates: ${location.coordinates}'),
            Text('Accuracy: ${location.accuracy}m'),
          ],
        );
      },
    );
  }
}
```

### Example 2: Get City for Attendance Record

```dart
Future<void> clockIn() async {
  try {
    // Get location with address
    final location = await LocationHelper.getCurrentLocationWithAddress();
    final result = await LocationHelper.getTimezoneWithLocationName();
    
    // Create attendance with city info
    final attendance = AttendanceRecord(
      id: uuid.v4(),
      employeeId: currentUser.id,
      clockInUtc: TimezoneHelper.toUtc(TimezoneHelper.now(result.timezone)),
      clockInTimezone: result.timezone.locationName,
      clockInLatitude: location.latitude,
      clockInLongitude: location.longitude,
      officeName: location.city ?? 'Unknown', // City from geocoding
      notes: location.formattedAddress, // Full address
    );
    
    await saveAttendance(attendance);
    print('Clocked in from: ${location.city}');
  } catch (e) {
    print('Clock in failed: $e');
  }
}
```

### Example 3: Search Location by Address

```dart
// Forward geocoding: Address → Coordinates
Future<void> searchAddress(String address) async {
  final locations = await LocationHelper.getCoordinatesFromAddress(address);
  
  if (locations.isEmpty) {
    print('Address not found');
    return;
  }
  
  for (var location in locations) {
    print('Found: ${location.latitude}, ${location.longitude}');
  }
  
  // Use first result
  final first = locations.first;
  
  // Get detailed address for these coordinates
  final placemark = await LocationHelper.getAddressFromCoordinates(
    latitude: first.latitude,
    longitude: first.longitude,
  );
  
  print('City: ${placemark?.locality}');
  print('Country: ${placemark?.country}');
}

// Usage
await searchAddress('Cairo, Egypt');
await searchAddress('King Fahd Road, Riyadh');
```

### Example 4: Verify Office Location with Address

```dart
class OfficeVerificationWidget extends StatefulWidget {
  @override
  _OfficeVerificationWidgetState createState() => 
      _OfficeVerificationWidgetState();
}

class _OfficeVerificationWidgetState extends State<OfficeVerificationWidget> {
  LocationResult? _location;
  String? _status;
  
  @override
  void initState() {
    super.initState();
    _checkLocation();
  }
  
  Future<void> _checkLocation() async {
    try {
      // Get location with address
      final location = await LocationHelper.getCurrentLocationWithAddress();
      final closestOffice = await LocationHelper.getClosestOffice();
      final isAtOffice = closestOffice.isLocationInOffice(location);
      
      setState(() {
        _location = location;
        _status = isAtOffice 
            ? 'At ${closestOffice.name}' 
            : 'Away from office';
      });
    } catch (e) {
      setState(() {
        _status = 'Location unavailable';
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
            Text(
              'Location Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            
            if (_location != null) ...[
              Text('City: ${_location!.city ?? "Unknown"}'),
              Text('Address: ${_location!.formattedAddress ?? "Unknown"}'),
              Text('Coordinates: ${_location!.coordinates}'),
              SizedBox(height: 8),
              Text(
                _status ?? 'Checking...',
                style: TextStyle(
                  color: _status?.contains('At') == true 
                      ? Colors.green 
                      : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ] else
              CircularProgressIndicator(),
            
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkLocation,
              child: Text('Refresh Location'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Placemark Properties

The `Placemark` object from geocoding contains:

```dart
placemark.street           // "King Fahd Road"
placemark.subLocality      // Neighborhood/district
placemark.locality         // "Riyadh" (city)
placemark.subAdministrativeArea  // County/district
placemark.administrativeArea     // "Riyadh Province" (state/region)
placemark.postalCode       // Postal/ZIP code
placemark.country          // "Saudi Arabia"
placemark.isoCountryCode   // "SA"
```

---

## LocationResult Helper Properties

```dart
final location = await LocationHelper.getCurrentLocationWithAddress();

location.city              // locality or subAdministrativeArea
location.country           // country name
location.street            // street name
location.administrativeArea // state/province
location.formattedAddress  // full formatted address
location.coordinates       // "(lat, lng)" string
location.latitude          // latitude number
location.longitude         // longitude number
location.accuracy          // GPS accuracy in meters
location.placemark         // full Placemark object
```

---

## Error Handling

Geocoding can fail (no internet, API limits, etc.):

```dart
// Method 1: Returns null on failure
final city = await LocationHelper.getCurrentCity();
if (city == null) {
  print('Could not get city name');
}

// Method 2: Check placemark
final location = await LocationHelper.getCurrentLocationWithAddress();
if (location.placemark == null) {
  print('Geocoding failed, GPS only');
  print('Coordinates: ${location.coordinates}');
} else {
  print('City: ${location.city}');
  print('Address: ${location.formattedAddress}');
}
```

---

## How getTimezoneWithLocationName() Works

```dart
static Future<({AppTimezone timezone, String locationName})> 
    getTimezoneWithLocationName() async {
  
  // 1. Get GPS coordinates
  final location = await getCurrentLocation();
  
  // 2. Determine timezone by proximity to offices
  final timezone = getTimezoneFromCoordinates(
    location.latitude, 
    location.longitude
  );
  
  // 3. Try geocoding to get real city name
  String? cityName = await getCityFromCoordinates(
    latitude: location.latitude,
    longitude: location.longitude,
  );
  
  // 4. Fallback to default if geocoding failed
  final locationName = cityName ?? 
      (timezone == AppTimezone.egypt ? 'القاهرة' : 'الرياض');
  
  return (timezone: timezone, locationName: locationName);
}
```

**Flow:**
1. GPS → (24.7136, 46.6753)
2. Proximity check → Closer to Riyadh office → `AppTimezone.saudiArabia`
3. Geocoding API → "Riyadh" (real city name)
4. Returns: `(timezone: saudiArabia, locationName: "Riyadh")`

---

## Best Practices

### 1. Handle Geocoding Failures Gracefully

```dart
// ✅ Good - Provides fallback
final location = await LocationHelper.getCurrentLocationWithAddress();
final cityDisplay = location.city ?? 'Unknown Location';

// ❌ Bad - Could show null
final cityDisplay = location.city; // Might be null
```

### 2. Cache Results When Possible

```dart
class LocationCache {
  static LocationResult? _cachedLocation;
  static DateTime? _cacheTime;
  
  static Future<LocationResult> getLocationWithCache() async {
    // Cache for 5 minutes
    if (_cachedLocation != null && 
        _cacheTime != null &&
        DateTime.now().difference(_cacheTime!) < Duration(minutes: 5)) {
      return _cachedLocation!;
    }
    
    _cachedLocation = await LocationHelper.getCurrentLocationWithAddress();
    _cacheTime = DateTime.now();
    return _cachedLocation!;
  }
}
```

### 3. Show Loading State During Geocoding

```dart
// ✅ Good - Shows loading
FutureBuilder<LocationResult>(
  future: LocationHelper.getCurrentLocationWithAddress(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    return Text(snapshot.data?.city ?? 'Unknown');
  },
)
```

### 4. Use Appropriate Accuracy for Geocoding

```dart
// For general display (faster, less battery)
final location = await LocationHelper.getCurrentLocationWithAddress(
  accuracy: LocationAccuracy.medium,
  timeLimit: Duration(seconds: 5),
);

// For precise address (slower, more accurate)
final location = await LocationHelper.getCurrentLocationWithAddress(
  accuracy: LocationAccuracy.best,
  timeLimit: Duration(seconds: 10),
);
```

---

## Testing Geocoding

### Simulator/Emulator Testing

**iOS Simulator:**
```
Debug → Location → Custom Location
Latitude: 24.7136, Longitude: 46.6753 (Riyadh)
Latitude: 30.0444, Longitude: 31.2357 (Cairo)
```

**Android Emulator:**
```
Extended Controls (...)  → Location
Set: 24.7136, 46.6753 (Riyadh)
Set: 30.0444, 31.2357 (Cairo)
```

### Manual Testing

```dart
// Test with specific coordinates
final placemark = await LocationHelper.getAddressFromCoordinates(
  latitude: 24.7136,
  longitude: 46.6753,
);
print('City: ${placemark?.locality}'); // Should show "Riyadh"

// Test forward geocoding
final locations = await LocationHelper.getCoordinatesFromAddress('Cairo, Egypt');
if (locations.isNotEmpty) {
  print('Cairo coordinates: ${locations.first.latitude}, ${locations.first.longitude}');
}
```

---

## Platform Requirements

### Android

Add to `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS

Add to `Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to display your current city and verify attendance</string>
```

---

## Summary

✅ **Geocoding integrated** - Get real city names from GPS  
✅ **Automatic in TimezoneCubit** - No extra code needed  
✅ **Fallback handling** - Defaults if geocoding fails  
✅ **Multiple methods** - City, address, reverse/forward geocoding  
✅ **Production ready** - Error handling and null safety  

The city name is now **automatically fetched and displayed** in your header section! 🎉

