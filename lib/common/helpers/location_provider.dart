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

  /// Reverse geocode coordinates into a city name and ISO country code.
  ///
  /// Never throws: returns nulls if geocoding fails.
  static Future<({String? city, String? countryCode})> _reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return (city: null, countryCode: null);
      final placemark = placemarks.first;
      return (
        city: placemark.administrativeArea,
        countryCode: placemark.isoCountryCode?.toUpperCase(),
      );
    } on Exception catch (_) {
      return (city: null, countryCode: null);
    }
  }

  /// IANA timezone for countries where the app may be used.
  ///
  /// All of these are single-timezone countries, so the country code alone
  /// identifies the correct zone (including DST rules).
  static const Map<String, String> countryTimezones = {
    'EG': 'Africa/Cairo',
    'SA': 'Asia/Riyadh',
    'JO': 'Asia/Amman',
    'AE': 'Asia/Dubai',
    'KW': 'Asia/Kuwait',
    'QA': 'Asia/Qatar',
    'BH': 'Asia/Bahrain',
    'OM': 'Asia/Muscat',
    'IQ': 'Asia/Baghdad',
    'LB': 'Asia/Beirut',
    'SY': 'Asia/Damascus',
    'YE': 'Asia/Aden',
    'SD': 'Africa/Khartoum',
    'LY': 'Africa/Tripoli',
    'TR': 'Europe/Istanbul',
  };

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
  /// `ianaName` is the real IANA timezone of the country the user is in
  /// (e.g. "Asia/Amman"), or null if the country could not be determined
  /// or is not in [countryTimezones].
  static Future<
    ({AppTimezone timezone, String? ianaName, String locationName})
  >
  getTimezoneWithLocationName() async {
    try {
      final location = await getCurrentLocation();
      final geo = await _reverseGeocode(
        latitude: location.latitude,
        longitude: location.longitude,
      );
      final ianaName = countryTimezones[geo.countryCode];

      final AppTimezone timezone;
      if (ianaName == AppTimezone.egypt.locationName) {
        timezone = AppTimezone.egypt;
      } else if (ianaName == AppTimezone.saudiArabia.locationName) {
        timezone = AppTimezone.saudiArabia;
      } else {
        timezone = getTimezoneFromCoordinates(
          location.latitude,
          location.longitude,
        );
      }

      return (
        timezone: timezone,
        ianaName: ianaName,
        locationName: geo.city ?? 'No Location Name',
      );
    } on Exception catch (_) {
      return (
        timezone: AppTimezone.saudiArabia,
        ianaName: null,
        locationName: 'No Location',
      );
    }
  }
}
