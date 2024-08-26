import 'package:location/location.dart';

class BackgroundLocationService {
  final Location _location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  Future<void> initialize() async {
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

    _location.changeSettings(interval: 100, distanceFilter: 10);
    _location.onLocationChanged.listen((LocationData currentLocation) {
      // Handle location update
      print('Location: ${currentLocation.latitude}, ${currentLocation.longitude}');
      // Save to database or send to server
    });
  }
}