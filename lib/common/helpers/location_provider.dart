import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';

/// Result of a location permission request
enum LocationPermissionStatus {
  /// Permission granted
  granted,

  /// Permission denied by user
  denied,

  /// Permission permanently denied (user must enable in settings)
  deniedForever,

  /// Location services are disabled on device
  locationServiceDisabled,
}

/// Result of getting location with additional context
class LocationResult {
  const LocationResult({
    required this.position,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });

  /// The full Position object from geolocator
  final Position position;

  /// Latitude coordinate
  final double latitude;

  /// Longitude coordinate
  final double longitude;

  /// Accuracy of the position in meters
  final double accuracy;

  @override
  String toString() {
    return 'LocationResult(lat: $latitude, lng: $longitude, accuracy: ${accuracy}m)';
  }
}

/// Office location configuration
class OfficeLocation {
  const OfficeLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.allowedRadiusMeters = 100,
  });

  /// Office name (e.g., "Cairo Office", "Riyadh Office")
  final String name;

  /// Office latitude
  final double latitude;

  /// Office longitude
  final double longitude;

  /// Allowed radius from office center in meters (default 100m)
  final double allowedRadiusMeters;

  /// Check if a location is within office radius
  bool isLocationInOffice(LocationResult location) {
    final distance = Geolocator.distanceBetween(
      location.latitude,
      location.longitude,
      latitude,
      longitude,
    );
    return distance <= allowedRadiusMeters;
  }

  /// Get distance from office in meters
  double distanceFromOffice(LocationResult location) {
    return Geolocator.distanceBetween(
      location.latitude,
      location.longitude,
      latitude,
      longitude,
    );
  }
}

/// Centralized helper class for handling geolocation in the HR app
class LocationProvider {
  LocationProvider._();

  static const OfficeLocation cairoOffice = OfficeLocation(
    name: 'Cairo Office',
    latitude: 30.0444, // Example: Cairo coordinates
    longitude: 31.2357,
  );

  static const OfficeLocation riyadhOffice = OfficeLocation(
    name: 'Riyadh Office',
    latitude: 24.7136, // Example: Riyadh coordinates
    longitude: 46.6753,
  );

  /// Check if location services are enabled on the device
  static Future<bool> isLocationServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  /// Check current location permission status
  ///
  /// Returns [LocationPermissionStatus] indicating current permission state
  static Future<LocationPermissionStatus> checkPermission() async {
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionStatus.locationServiceDisabled;
    }

    // Check permission status
    final permission = await Geolocator.checkPermission();

    switch (permission) {
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return LocationPermissionStatus.granted;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.denied;
    }
  }

  /// Request location permission from user
  ///
  /// Returns [LocationPermissionStatus] after requesting permission
  static Future<LocationPermissionStatus> requestPermission() async {
    // First check if location services are enabled
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionStatus.locationServiceDisabled;
    }

    // Request permission
    final permission = await Geolocator.requestPermission();

    switch (permission) {
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return LocationPermissionStatus.granted;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.denied;
    }
  }

  /// Get current location of the user
  ///
  /// Throws [LocationServiceDisabledException] if location services are disabled
  /// Throws [PermissionDeniedException] if permission is denied
  ///
  /// Optional parameters:
  /// - [accuracy] Desired accuracy (default: best)
  /// - [timeLimit] Maximum time to wait for location (default: 10 seconds)
  static Future<LocationResult> getCurrentLocation({
    LocationAccuracy accuracy = LocationAccuracy.best,
    Duration timeLimit = const Duration(seconds: 10),
  }) async {
    // Check if services are enabled
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceDisabledException();
    }

    // Check permission
    final permissionStatus = await checkPermission();
    if (permissionStatus != LocationPermissionStatus.granted) {
      throw const PermissionDeniedException('Location permission denied');
    }

    // Get position with timeout
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        timeLimit: timeLimit,
      ),
    );

    return LocationResult(
      position: position,
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
    );
  }

  /// Open device location settings
  ///
  /// Useful when permission is denied forever or location services are disabled
  static Future<bool> openLocationSettings() async {
    return Geolocator.openLocationSettings();
  }

  /// Calculate distance between two coordinates in meters
  static double calculateDistance({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  /// Check if a given location is within the specified radius of a target point
  ///
  /// [userLat] - User's current latitude
  /// [userLng] - User's current longitude
  /// [targetLat] - Target location latitude (e.g., shift location)
  /// [targetLng] - Target location longitude (e.g., shift location)
  /// [radiusInMeters] - Allowed radius in meters
  ///
  /// Returns `true` if user is within radius, `false` otherwise
  static bool isWithinRadius({
    required double userLat,
    required double userLng,
    required double targetLat,
    required double targetLng,
    required double radiusInMeters,
  }) {
    final distance = calculateDistance(
      startLat: userLat,
      startLng: userLng,
      endLat: targetLat,
      endLng: targetLng,
    );
    return distance <= radiusInMeters;
  }

  /// Check if user's current location is within the specified radius of a target point
  ///
  /// [targetLat] - Target location latitude (e.g., shift location)
  /// [targetLng] - Target location longitude (e.g., shift location)
  /// [radiusInMeters] - Allowed radius in meters
  ///
  /// Returns a record with:
  /// - `isWithin`: Whether user is within radius
  /// - `distance`: Distance from target in meters
  ///
  /// Throws exceptions if location cannot be obtained
  static Future<({bool isWithin, double distance})> isCurrentLocationWithinRadius({
    required double targetLat,
    required double targetLng,
    required double radiusInMeters,
  }) async {
    final location = await getCurrentLocation();
    final distance = calculateDistance(
      startLat: location.latitude,
      startLng: location.longitude,
      endLat: targetLat,
      endLng: targetLng,
    );
    return (isWithin: distance <= radiusInMeters, distance: distance);
  }

  /// Get city name from coordinates using reverse geocoding
  ///
  /// Returns the city/locality name, trying multiple placemark fields
  static Future<String?> _getCityFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) return null;

      final placemark = placemarks.first.administrativeArea;

      if (placemark == null) return null;

      return placemark;
    } on Exception catch (_) {
      throw Exception('Failed Geocoding Getting City Name');
    }
  }

  /// Determine timezone based on given coordinates
  ///
  /// Returns [AppTimezone] based on which office is closer to the coordinates.
  /// Uses Cairo Office for Egypt timezone and Riyadh Office for Saudi Arabia timezone.
  static AppTimezone getTimezoneFromCoordinates(double latitude, double longitude) {
    final distanceToCairo = calculateDistance(
      startLat: latitude,
      startLng: longitude,
      endLat: cairoOffice.latitude,
      endLng: cairoOffice.longitude,
    );

    final distanceToRiyadh = calculateDistance(
      startLat: latitude,
      startLng: longitude,
      endLat: riyadhOffice.latitude,
      endLng: riyadhOffice.longitude,
    );

    return distanceToCairo < distanceToRiyadh ? AppTimezone.egypt : AppTimezone.saudiArabia;
  }

  /// Get timezone and location name based on current GPS location
  ///
  /// Returns a record with timezone and city name from geocoding
  static Future<({AppTimezone timezone, String locationName})> getTimezoneWithLocationName() async {
    try {
      final location = await getCurrentLocation();
      final timezone = getTimezoneFromCoordinates(location.latitude, location.longitude);

      // Try to get real city name from geocoding
      final cityName = await _getCityFromCoordinates(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      // Use geocoded city name if available, otherwise fallback based on timezone
      final locationName = cityName ?? 'No Location Name';

      return (timezone: timezone, locationName: locationName);
    } on Exception catch (_) {
      // Default to Riyadh if location cannot be obtained
      return (timezone: AppTimezone.saudiArabia, locationName: 'No Location');
    }
  }
}
