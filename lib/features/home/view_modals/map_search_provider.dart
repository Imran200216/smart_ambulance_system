import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:smart_ambulance_system/features/home/home_exports.dart';

class MapSearchProvider extends ChangeNotifier {
  final MapController mapController = MapController();
  LatLng? searchedLocation;
  bool isMapReady = false;
  bool _pendingLocationMove = false;
  double _pendingZoomLevel = 14.0;

  final fromController = TextEditingController();
  final toController = TextEditingController();

  LatLng? _fromLatLng;
  LatLng? _toLatLng;

  double? _calculatedDistance;

  List<LatLng> routePoints = [];
  List<Hospital> nearbyHospitals = [];

  double? get calculatedDistance => _calculatedDistance;

  Future<void> convertAddressToLatLng(
    String address, {
    bool isFrom = true,
  }) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final latLng = LatLng(locations[0].latitude, locations[0].longitude);
        if (isFrom) {
          _fromLatLng = latLng;
          fromController.text = address;
        } else {
          _toLatLng = latLng;
          toController.text = address;
        }
        calculateDistance();
      }
    } catch (e) {
      print('Geocoding error: $e');
    }
  }

  void updateFromLocation(LatLng latLng) {
    _fromLatLng = latLng;
    calculateDistance();
  }

  void updateToLocation(LatLng latLng) {
    _toLatLng = latLng;
    calculateDistance();
  }

  void calculateDistance() {
    if (_fromLatLng != null && _toLatLng != null) {
      final distance = const latlong.Distance();
      _calculatedDistance = distance.as(
        LengthUnit.Kilometer,
        _fromLatLng!,
        _toLatLng!,
      );
      notifyListeners();
    }
  }

  Future<Map<String, double>?> _fetchLocation(String query) async {
    final url =
        "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=1";
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data.isNotEmpty) {
      return {
        'lat': double.parse(data[0]['lat']),
        'lon': double.parse(data[0]['lon']),
      };
    }
    return null;
  }

  Future<void> searchRouteFromInputs() async {
    final fromQuery = fromController.text.trim();
    final toQuery = toController.text.trim();

    if (fromQuery.isEmpty || toQuery.isEmpty) return;

    try {
      final fromData = await _fetchLocation(fromQuery);
      final toData = await _fetchLocation(toQuery);

      if (fromData != null && toData != null) {
        final fromLatLng = LatLng(fromData['lat']!, fromData['lon']!);
        final toLatLng = LatLng(toData['lat']!, toData['lon']!);

        updateFromLocation(fromLatLng);
        updateToLocation(toLatLng);

        await findRoute(fromLatLng, toLatLng);
      } else {
        routePoints = [];
        _calculatedDistance = null;
        notifyListeners();
      }
    } catch (e) {
      print('Error in searchRouteFromInputs: $e');
    }
  }

  bool _isWithinPuducherryBounds(double lat, double lon) {
    return lat >= 11.8 && lat <= 12.1 && lon >= 79.7 && lon <= 79.9;
  }

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

  void onMapReady() {
    isMapReady = true;
    _applyPendingLocationMoveIfReady();
    notifyListeners();
  }

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

  /// Fetch nearby hospitals using current location and store in [nearbyHospitals]
  Future<void> fetchNearbyHospitals() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double lat = position.latitude;
      double lon = position.longitude;

      final url =
          'https://nominatim.openstreetmap.org/search?format=json&limit=50&q=hospital&bounded=1&viewbox=${lon - 0.2},${lat + 0.2},${lon + 0.2},${lat - 0.2}';

      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      nearbyHospitals.clear();

      if (response.statusCode == 200 && data.isNotEmpty) {
        for (var item in data) {
          final double hospLat = double.parse(item['lat']);
          final double hospLon = double.parse(item['lon']);
          final String name = item['display_name'];

          final distance = const latlong.Distance().as(
            LengthUnit.Kilometer,
            LatLng(lat, lon),
            LatLng(hospLat, hospLon),
          );

          if (distance <= 20) {
            nearbyHospitals.add(
              Hospital(
                name: name,
                latitude: hospLat,
                longitude: hospLon,
                distanceInKm: distance,
              ),
            );
          }
        }
        notifyListeners();
      } else {
        print('No hospitals found nearby');
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching nearby hospitals: $e');
    }
  }

  void clearRoute() {
    routePoints = [];
    _calculatedDistance = null;
    notifyListeners();
  }
}
