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
  LatLng? _fromLatLng;
  LatLng? _toLatLng;

  double? _calculatedDistance;

  double? get calculatedDistance => _calculatedDistance;

  bool isMapReady = false;
  bool _pendingLocationMove = false;
  double _pendingZoomLevel = 14.0;

  final fromController = TextEditingController();
  final toController = TextEditingController();

  List<LatLng> routePoints = [];
  List<Hospital> nearbyHospitals = [];

  Hospital? _selectedHospital;
  LatLng? selectedHospitalLocation;

  Hospital? get selectedHospital => _selectedHospital;

  void selectHospitalAndFindRoute(LatLng hospitalLocation) {
    selectedHospitalLocation = hospitalLocation;
    if (searchedLocation != null) {
      findRouteFromTo(searchedLocation!, hospitalLocation);
    }
    notifyListeners();
  }

  /// --------------------------
  /// Address to LatLng
  /// --------------------------
  Future<void> convertAddressToLatLng(
      String address, {
        bool isFrom = true,
      }) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        LatLng latLng = LatLng(locations[0].latitude, locations[0].longitude);

        if (isFrom) {
          _fromLatLng = latLng;
        } else {
          _toLatLng = latLng;
        }

        if (_fromLatLng != null && _toLatLng != null) {
          await findRouteFromTo(_fromLatLng!, _toLatLng!);
          calculateDistance();
        }

        notifyListeners();
      }
    } catch (e) {
      print("Error converting address to LatLng: $e");
    }
  }

  /// --------------------------
  /// Route Calculation
  /// --------------------------
  Future<void> findRouteFromTo(LatLng from, LatLng to) async {
    final url =
        'https://router.project-osrm.org/route/v1/driving/${from.longitude},${from.latitude};${to.longitude},${to.latitude}?overview=full&geometries=geojson';

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['routes'] != null &&
          data['routes'].isNotEmpty) {
        final route = data['routes'][0]['geometry']['coordinates'] as List;
        routePoints = route.map((point) => LatLng(point[1], point[0])).toList();
      } else {
        print('No route found');
        routePoints = [];
      }
    } catch (e) {
      print('Error fetching route: $e');
      routePoints = [];
    }
    notifyListeners();
  }

  /// --------------------------
  /// Distance Calculation
  /// --------------------------
  void calculateDistance() {
    if (_fromLatLng != null && _toLatLng != null) {
      final Distance distance = Distance();
      _calculatedDistance = distance.as(
        LengthUnit.Kilometer,
        _fromLatLng!,
        _toLatLng!,
      );
      notifyListeners();
    }
  }

  /// --------------------------
  /// Search Inputs → Route
  /// --------------------------
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

        _fromLatLng = fromLatLng;
        _toLatLng = toLatLng;

        await findRouteFromTo(fromLatLng, toLatLng);
        calculateDistance();
        notifyListeners();
      } else {
        routePoints = [];
        _calculatedDistance = null;
        notifyListeners();
      }
    } catch (e) {
      print('Error in searchRouteFromInputs: $e');
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

  /// --------------------------
  /// Current Location
  /// --------------------------
  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (_isWithinPuducherryBounds(position.latitude, position.longitude)) {
      searchedLocation = LatLng(position.latitude, position.longitude);
      _pendingLocationMove = true;
      _pendingZoomLevel = 14.0;
      _applyPendingLocationMoveIfReady();
    } else {
      searchedLocation = null;
      print('Location not in Puducherry');
    }
    notifyListeners();
  }

  bool _isWithinPuducherryBounds(double lat, double lon) {
    return lat >= 11.8 && lat <= 12.1 && lon >= 79.7 && lon <= 79.9;
  }

  /// --------------------------
  /// Search Place
  /// --------------------------
  Future<void> searchPlace(String query) async {
    if (query.isEmpty) return;

    final url =
        "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=1";
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
      } else {
        searchedLocation = null;
        print('Search result not in Puducherry');
      }
      notifyListeners();
    }
  }

  /// --------------------------
  /// Map Movement
  /// --------------------------
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
      mapController.move(searchedLocation!, zoomLevel);
    } else {
      _pendingZoomLevel = zoomLevel;
      _pendingLocationMove = true;
    }
  }

  /// --------------------------
  /// Hospital Logic
  /// --------------------------
  Future<void> fetchNearbyHospitals() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final double lat = position.latitude;
      final double lon = position.longitude;

      final url =
          'https://nominatim.openstreetmap.org/search?format=json&limit=50&q=hospital&bounded=1&viewbox=${lon - 0.2},${lat + 0.2},${lon + 0.2},${lat - 0.2}';
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      nearbyHospitals.clear();

      if (response.statusCode == 200 && data.isNotEmpty) {
        for (var item in data) {
          final hospLat = double.parse(item['lat']);
          final hospLon = double.parse(item['lon']);
          final name = item['display_name'];

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
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching hospitals: $e');
    }
  }

  Future<void> setSelectedHospital(Hospital hospital) async {
    _selectedHospital = hospital;
    notifyListeners();

    if (searchedLocation != null) {
      await findRouteFromTo(
        searchedLocation!,
        LatLng(hospital.latitude, hospital.longitude),
      );
    }
  }

  void clearSelectedHospital() {
    _selectedHospital = null;
    routePoints = [];
    notifyListeners();
  }

  void clearRoute() {
    routePoints = [];
    _calculatedDistance = null;
    notifyListeners();
  }
}
