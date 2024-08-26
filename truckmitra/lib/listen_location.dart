// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:location/location.dart';

// import 'package:truck_mitra/database/database_helper.dart';

// // class ListenLocationWidget extends StatefulWidget {
// //   const ListenLocationWidget({super.key});

// //   @override
// //   _ListenLocationState createState() => _ListenLocationState();
// // }

// // class _ListenLocationState extends State<ListenLocationWidget> {
// //   final Location location = Location();
// //   PermissionStatus? _permissionGranted;
// //   LocationData? _location;
// //   StreamSubscription<LocationData>? _locationSubscription;
// //   String? _error;

// //   Future<void> _checkPermissions() async {
// //     final permissionGrantedResult = await location.hasPermission();
// //     setState(() {
// //       _permissionGranted = permissionGrantedResult;
// //     });
// //   }

// //   Future<void> _requestPermission() async {
// //     if (_permissionGranted != PermissionStatus.granted) {
// //       final permissionRequestedResult = await location.requestPermission();
// //       setState(() {
// //         _permissionGranted = permissionRequestedResult;
// //       });
// //     }
// //   }

// //   Future<void> _listenLocation() async {
// //     _locationSubscription =
// //         location.onLocationChanged.handleError((dynamic err) {
// //       if (err is PlatformException) {
// //         setState(() {
// //           _error = err.code;
// //         });
// //       }
// //       _locationSubscription?.cancel();
// //       setState(() {
// //         _locationSubscription = null;
// //       });
// //     }).listen((currentLocation) {
// //       setState(() {
// //         _error = null;

// //         _location = currentLocation;
// //         print(_location);
// //       });
// //     });
// //     setState(() {});
// //   }

// //   Future<void> _stopListen() async {
// //     await _locationSubscription?.cancel();
// //     setState(() {
// //       _locationSubscription = null;
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _locationSubscription?.cancel();
// //     setState(() {
// //       _locationSubscription = null;
// //     });
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: <Widget>[
// //         Text(
// //           'Listen location: ${_error ?? '${_location ?? "unknown"}'}',
// //           style: Theme.of(context).textTheme.bodyLarge,
// //         ),
// //         Row(
// //           children: <Widget>[
// //             Container(
// //               margin: const EdgeInsets.only(right: 42),
// //               child: ElevatedButton(
// //                 onPressed:
// //                     _locationSubscription == null ? _listenLocation : null,
// //                 child: const Text('Listen'),
// //               ),
// //             ),
// //             ElevatedButton(
// //               onPressed: _locationSubscription != null ? _stopListen : null,
// //               child: const Text('Stop'),
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// // }

// class ListenLocation {
//   final Location location = Location();
//   PermissionStatus? _permissionGranted;
//   LocationData? _location;
//   StreamSubscription<LocationData>? _locationSubscription;
//   String? _error;

//   Future<bool> checkPermissions() async {
//     final permissionGrantedResult = await location.hasPermission();
//     _permissionGranted = permissionGrantedResult;
//     return permissionGrantedResult == PermissionStatus.granted;
//   }

//   Future<void> requestPermission() async {
//     if (_permissionGranted != PermissionStatus.granted) {
//       final permissionRequestedResult = await location.requestPermission();
//       _permissionGranted = permissionRequestedResult;
//     }
//   }

//   Future<void> listenLocation() async {
//     _locationSubscription =
//         location.onLocationChanged.handleError((dynamic err) {
//       if (err is PlatformException) {
//         _error = err.code;
//       }
//       _locationSubscription?.cancel();
//       _locationSubscription = null;
//     }).listen((currentLocation) {
//       _error = null;
//       _location = currentLocation;
//       print(_location);
//     });
//   }

//   Future<void> stopListen() async {
//     await _locationSubscription?.cancel();
//     _locationSubscription = null;
//   }

//   void dispose() {
//     _locationSubscription?.cancel();
//     _locationSubscription = null;
//   }
// }


import 'dart:async';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:truckmitra/database_helper.dart';

class ListenLocation {
  final Location location = Location();
  final dbHelper = DatabaseHelper();

  PermissionStatus? _permissionGranted;
  LocationData? _location;
  StreamSubscription<LocationData>? _locationSubscription;
  String? _error;
  
  void _insertLocation(double lat, double long, String timestamp) async {
    try {
      await dbHelper.insertLocation(lat, long, timestamp);
      print('Location inserted successfully');
    } catch (e) {
      print('Error inserting location: $e');
    }
  }

  Future<bool> checkPermissions() async {
    
    final permissionGrantedResult = await location.hasPermission();
    _permissionGranted = permissionGrantedResult;
    return permissionGrantedResult == PermissionStatus.granted;
  }

  Future<void> requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final permissionRequestedResult = await location.requestPermission();
      _permissionGranted = permissionRequestedResult;
    }
  }

  Future<void> listenLocation() async {
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      if (err is PlatformException) {
        _error = err.code;
      }
      _locationSubscription?.cancel();
      _locationSubscription = null;
    }).listen((currentLocation) async {
      _error = null;
      _location = currentLocation;
      // await sendDataToCloud(_location!.latitude!, _location!.longitude!);
      _insertLocation(
        _location!.latitude!,
        _location!.longitude!,
        DateTime.now().toString()
      );
      print(_location);
      print(DateTime.now().toString());
    });
  }

  // Future<void> stopListen() async {
  //   await _locationSubscription?.cancel();
  //   dbHelper.getUnsyncedLocations();
  //   _locationSubscription = null;
  // }

  void dispose() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }
}