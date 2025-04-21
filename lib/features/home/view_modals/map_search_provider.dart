import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapSearchProvider extends ChangeNotifier {
  final MapController mapController = MapController();
  LatLng? searchedLocation;
  bool isMapReady = false; // Add a flag to check if map is ready

  // Define Puducherry bounds for location checking
  bool _isWithinPuducherryBounds(double lat, double lon) {
    return lat >= 11.8 && lat <= 12.1 && lon >= 79.7 && lon <= 79.9;
  }

  // Fetch the user's current location
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle accordingly
      return;
    }

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle permission denial
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle location permission denial
      return;
    }

    // Get the current position of the user
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Check if the current location is within Puducherry bounds
    if (_isWithinPuducherryBounds(position.latitude, position.longitude)) {
      searchedLocation = LatLng(position.latitude, position.longitude);

      // Only move the map if the map is ready
      if (isMapReady) {
        mapController.move(
          searchedLocation!,
          14, // Zoom into current location within Puducherry
        );
      } else {
        // If map is not ready, delay the move action
        WidgetsBinding.instance.addPostFrameCallback((_) {
          mapController.move(
            searchedLocation!,
            14, // Zoom into current location within Puducherry
          );
        });
      }

      notifyListeners();
    } else {
      searchedLocation = null;
      notifyListeners();
      print('Current location is not within Puducherry bounds');
    }
  }

  // Search for a place by name and update the map
  Future<void> searchPlace(String query) async {
    if (query.isEmpty) return;

    final encodedQuery = Uri.encodeComponent(query);
    final url =
        "https://nominatim.openstreetmap.org/search?q=$encodedQuery&format=json&limit=1";

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data.isNotEmpty) {
      final lat = double.parse(data[0]['lat']);
      final lon = double.parse(data[0]['lon']);

      // Check if the searched location is within Puducherry bounds
      if (_isWithinPuducherryBounds(lat, lon)) {
        searchedLocation = LatLng(lat, lon);

        // Only move the map if the map is ready
        if (isMapReady) {
          mapController.move(
            searchedLocation!,
            14, // Zoom into location within Puducherry
          );
        } else {
          // If map is not ready, delay the move action
          WidgetsBinding.instance.addPostFrameCallback((_) {
            mapController.move(
              searchedLocation!,
              14, // Zoom into location within Puducherry
            );
          });
        }

        notifyListeners();
      } else {
        searchedLocation = null;
        notifyListeners();
        print('Location is not in Puducherry');
      }
    } else {
      // Handle no results found
      searchedLocation = null;
      notifyListeners();
    }
  }

  // Method to notify when the map is ready
  void onMapReady() {
    isMapReady = true;
    notifyListeners();
  }
}
