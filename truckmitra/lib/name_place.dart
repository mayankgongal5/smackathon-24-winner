import 'dart:async';
import 'package:location/location.dart';
import 'database_helper.dart';

class LocationService {
  final Location _location = Location();
  late StreamSubscription<LocationData> _locationSubscription;
  bool _isTracking = false;
  String _latitude = 'Unknown';
  String _longitude = 'Unknown';
  String _timestamp = 'Unknown';

  bool get isTracking => _isTracking;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get timestamp => _timestamp;

  Future<void> startTracking() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    _isTracking = true;

    _locationSubscription = _location.onLocationChanged.listen((LocationData locationData) async {
      _latitude = locationData.latitude.toString();
      _longitude = locationData.longitude.toString();
      _timestamp = DateTime.now().toIso8601String();

      await DatabaseHelper().insertLocation(locationData.latitude!, locationData.longitude!, _timestamp);

      print('Latitude: $_latitude, Longitude: $_longitude, Timestamp: $_timestamp');
    });

    Timer.periodic(Duration(seconds: 2), (timer) {
      if (!_isTracking) {
        timer.cancel();
      } else {
        _location.getLocation().then((locationData) async {
          _latitude = locationData.latitude.toString();
          _longitude = locationData.longitude.toString();
          _timestamp = DateTime.now().toIso8601String();

          await DatabaseHelper().insertLocation(locationData.latitude!, locationData.longitude!, _timestamp);

          print('Latitude: ${locationData.latitude}, Longitude: ${locationData.longitude}, Timestamp: $_timestamp');
        });
      }
    });
  }

  void stopTracking() {
    _isTracking = false;
    _locationSubscription.cancel();
    // Update the database when tracking stops
    DatabaseHelper().insertLocation(
      double.parse(_latitude),
      double.parse(_longitude),
      _timestamp,
    );
  }
}