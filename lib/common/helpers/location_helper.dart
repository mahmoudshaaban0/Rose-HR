import 'package:geolocator/geolocator.dart';

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
    this.address,
  });

  /// The full Position object from geolocator
  final Position position;

  /// Latitude coordinate
  final double latitude;

  /// Longitude coordinate
  final double longitude;

  /// Accuracy of the position in meters
  final double accuracy;

  /// Optional address (if geocoding is implemented)
  final String? address;

  /// Format coordinates as a string
  String get coordinates => '($latitude, $longitude)';

  /// Check if position is within a certain radius of target location
  /// [targetLat] Target latitude
  /// [targetLng] Target longitude
  /// [radiusInMeters] Radius in meters (default 100m)
  bool isWithinRadius({
    required double targetLat,
    required double targetLng,
    double radiusInMeters = 100,
  }) {
    final distance = Geolocator.distanceBetween(
      latitude,
      longitude,
      targetLat,
      targetLng,
    );
    return distance <= radiusInMeters;
  }

  /// Get distance in meters to another location
  double distanceTo({
    required double targetLat,
    required double targetLng,
  }) {
    return Geolocator.distanceBetween(
      latitude,
      longitude,
      targetLat,
      targetLng,
    );
  }

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
    return location.isWithinRadius(
      targetLat: latitude,
      targetLng: longitude,
      radiusInMeters: allowedRadiusMeters,
    );
  }

  /// Get distance from office in meters
  double distanceFromOffice(LocationResult location) {
    return location.distanceTo(
      targetLat: latitude,
      targetLng: longitude,
    );
  }
}

/// Centralized helper class for handling geolocation in the HR app
///
/// This class provides utilities for:
/// - Checking and requesting location permissions
/// - Getting current user location
/// - Verifying user is at office location
/// - Calculating distances
///
/// Usage:
/// ```dart
/// // Check permissions
/// final permissionStatus = await LocationHelper.checkPermission();
///
/// if (permissionStatus == LocationPermissionStatus.granted) {
///   // Get current location
///   final location = await LocationHelper.getCurrentLocation();
///   print('User at: ${location.coordinates}');
///
///   // Check if at office
///   final isAtOffice = LocationHelper.cairoOffice.isLocationInOffice(location);
/// }
/// ```
class LocationHelper {
  LocationHelper._();

  // Office locations - Update these with your actual office coordinates

  /// Cairo Office Location (Egypt)
  /// TODO: Replace with actual Cairo office coordinates
  static const OfficeLocation cairoOffice = OfficeLocation(
    name: 'Cairo Office',
    latitude: 30.0444, // Example: Cairo coordinates
    longitude: 31.2357,
  );

  /// Riyadh Office Location (Saudi Arabia)
  /// TODO: Replace with actual Riyadh office coordinates
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

  /// Get last known location (faster but may be outdated)
  ///
  /// Returns null if no last known position is available
  static Future<LocationResult?> getLastKnownLocation() async {
    final position = await Geolocator.getLastKnownPosition();

    if (position == null) {
      return null;
    }

    return LocationResult(
      position: position,
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
    );
  }

  /// Request permission and get location in one call
  ///
  /// Returns location if permission granted, null otherwise
  static Future<LocationResult?> requestPermissionAndGetLocation() async {
    final permissionStatus = await requestPermission();

    if (permissionStatus == LocationPermissionStatus.granted) {
      try {
        return await getCurrentLocation();
      } on Exception {
        return null;
      }
    }

    return null;
  }

  /// Open device location settings
  ///
  /// Useful when permission is denied forever or location services are disabled
  static Future<bool> openLocationSettings() async {
    return Geolocator.openLocationSettings();
  }

  /// Open app settings (for when permission is denied forever)
  static Future<bool> openAppSettings() async {
    return Geolocator.openAppSettings();
  }

  /// Check if user is at a specific office location
  ///
  /// Returns true if user is within the office radius, false otherwise
  static Future<bool> isUserAtOffice(OfficeLocation office) async {
    try {
      final location = await getCurrentLocation();
      return office.isLocationInOffice(location);
    } on Exception {
      return false;
    }
  }

  /// Get distance from user to office in meters
  ///
  /// Returns null if location cannot be obtained
  static Future<double?> getDistanceToOffice(OfficeLocation office) async {
    try {
      final location = await getCurrentLocation();
      return office.distanceFromOffice(location);
    } on Exception {
      return null;
    }
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

  /// Calculate distance between two coordinates in kilometers
  static double calculateDistanceInKm({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    final meters = calculateDistance(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );
    return meters / 1000;
  }

  /// Get formatted distance string
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)}m';
    } else {
      final km = meters / 1000;
      return '${km.toStringAsFixed(2)}km';
    }
  }
}
