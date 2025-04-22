import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapSearchProvider extends ChangeNotifier {
  final MapController mapController = MapController();
  LatLng? searchedLocation;
  bool isMapReady = false;
  bool _pendingLocationMove = false;
  double _pendingZoomLevel = 14.0;

  // For routing
  List<LatLng> routePoints = [];

  /// Puducherry bounds check
  bool _isWithinPuducherryBounds(double lat, double lon) {
    return lat >= 11.8 && lat <= 12.1 && lon >= 79.7 && lon <= 79.9;
  }

  /// Get current location
  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (_isWithinPuducherryBounds(position.latitude, position.longitude)) {
      searchedLocation = LatLng(position.latitude, position.longitude);
      _pendingLocationMove = true;
      _pendingZoomLevel = 14.0;
      _applyPendingLocationMoveIfReady();
      notifyListeners();
    } else {
      searchedLocation = null;
      print('Current location is not within Puducherry bounds');
      notifyListeners();
    }
  }

  /// Search by place name
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

      if (_isWithinPuducherryBounds(lat, lon)) {
        searchedLocation = LatLng(lat, lon);
        _pendingLocationMove = true;
        _pendingZoomLevel = 16.0;
        _applyPendingLocationMoveIfReady();
        notifyListeners();
      } else {
        searchedLocation = null;
        print('Location is not in Puducherry');
        notifyListeners();
      }
    } else {
      searchedLocation = null;
      print('No results found');
      notifyListeners();
    }
  }

  /// Map readiness handler
  void onMapReady() {
    isMapReady = true;
    _applyPendingLocationMoveIfReady();
    notifyListeners();
  }

  /// Apply pending camera move
  void _applyPendingLocationMoveIfReady() {
    if (isMapReady && _pendingLocationMove && searchedLocation != null) {
      try {
        mapController.move(searchedLocation!, _pendingZoomLevel);
        _pendingLocationMove = false;
      } catch (e) {
        print('Error moving map: $e');
      }
    }
  }

  /// Zoom manually
  void zoomTo(double zoomLevel) {
    if (isMapReady && searchedLocation != null) {
      try {
        mapController.move(searchedLocation!, zoomLevel);
      } catch (e) {
        print('Error zooming map: $e');
      }
    } else {
      _pendingZoomLevel = zoomLevel;
      _pendingLocationMove = true;
    }
  }

  /// Get shortest route using OSRM
  Future<void> findRoute(LatLng from, LatLng to) async {
    final url =
        'https://router.project-osrm.org/route/v1/driving/${from.longitude},${from.latitude};${to.longitude},${to.latitude}?overview=full&geometries=geojson';

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['routes'] != null &&
          data['routes'].isNotEmpty) {
        final route = data['routes'][0]['geometry']['coordinates'] as List;

        routePoints =
            route
                .map(
                  (point) => LatLng(point[1].toDouble(), point[0].toDouble()),
                )
                .toList();

        notifyListeners();
      } else {
        print('No route found');
        routePoints = [];
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching route: $e');
      routePoints = [];
      notifyListeners();
    }
  }

  /// Clear route
  void clearRoute() {
    routePoints = [];
    notifyListeners();
  }
}
