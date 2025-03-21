import 'package:go_find_taxi/core/services/LocationService/google_map_impl.dart';
import 'package:go_find_taxi/core/services/LocationService/models/geo_coding_response.dart';
import 'package:google_maps_widget/google_maps_widget.dart';

import '../../utils/index.dart';
import 'gebeta_maps_impl.dart';
import 'package:geolocator/geolocator.dart';

import 'models/direction.dart';
import 'models/reverse_geocoding_response.dart';

/// A service class that provides location-related functionality including geocoding,
/// reverse geocoding, getting current location, and directions.
///
/// This class follows the Singleton pattern and can be instantiated with either
/// Gebeta Maps or Google Maps implementation.
abstract class LocationService {
  static LocationService? _instance;

  /// Gets an instance of LocationService.
  ///
  /// [instance] parameter determines which implementation to use:
  /// - "GEBETA" for Gebeta Maps implementation (default)
  /// - Any other value for Google Maps implementation
  static LocationService getInstance([String instance = "GEBETA"]) {
    try {
      // Return existing instance if available
      if (_instance != null) {
        return _instance!;
      }

      // Initialize the appropriate implementation
      try {
        if (instance == "GEBETA") {
          _instance = GebetaMapsImpl();
        } else {
          _instance = GoogleMapImpl();
        }

        // Verify instance was created successfully
        if (_instance == null) {
          //  throw NotInitializedError('Failed to initialize LocationService implementation');
        }

        return _instance!;
      } catch (initError) {
        printError('Failed to initialize location service: $initError');
        // Default to Google Maps implementation if Gebeta fails
        if (instance == "GEBETA") {
          _instance = GoogleMapImpl();
          return _instance!;
        }
        rethrow;
      }
    } catch (e) {
      printError('Error getting location service instance: $e');
      rethrow;
    }
  }

  /// Converts a place name to geographic coordinates.
  ///
  /// Returns a list of [GeoCoding] objects containing location information.
  Future<List<GeoCoding>> geoCoding(String placeName);

  /// Converts geographic coordinates to place information.
  ///
  /// Returns a list of [ReverseGeocoding] objects containing place details.
  Future<List<ReverseGeocoding>> reverseGeoCoding(LatLng latLng);

  /// Gets the current device location after handling permissions.
  ///
  /// Returns a [LatLng] object containing the current coordinates.
  /// Throws an error if location permissions are denied or if there's an error
  /// getting the location.
  Future<LatLng> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          printError('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        printError('Location permissions are permanently denied');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      printError('Error getting current location: $e');
      rethrow;
    }
  }

  /// Gets directions between two locations.
  ///
  /// [origin] is the starting point coordinates
  /// [destination] is the end point coordinates
  /// Returns a [Direction] object containing route information.
  Future<Direction?> geDirection(
      {required LatLng origin, required LatLng destination});

  /// Gets place names for given coordinates.
  ///
  /// Returns a list of place names near the given coordinates.
  Future<List<String>> getPlaceNameByLatLng(LatLng latLng);
}
