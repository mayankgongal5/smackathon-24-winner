// import 'package:easy_url_launcher/easy_url_launcher.dart';
// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:truckmitra/profile.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:async';
// import 'database_helper.dart';
// import 'history_screen.dart';
// import 'sessionmanager.dart';
// import 'stops.dart';
// import 'emergency.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   bool _isTracking = false;
//   Location _location = Location();
//   late StreamSubscription<LocationData> _locationSubscription;
//   String _latitude = 'Unknown';
//   String _longitude = 'Unknown';
//   String _timestamp = 'Unknown';
//   Database? _database;
//   final SessionManager _sessionManager = SessionManager();
//
//   Widget _buildServiceColumn(IconData icon, String label, String url) {
//     return InkWell(
//       onTap: () async {
//         final Uri uri = Uri.parse(url);
//         if (await canLaunchUrl(uri)) {
//           await launchUrl(uri);
//         } else {
//           throw 'Could not launch $url';
//         }
//       },
//       child: Column(
//         children: [
//           Icon(icon, size: 30.0, color: Colors.blue),
//           SizedBox(height: 8.0),
//           Text(label, style: TextStyle(fontSize: 16.0)),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _initDatabase();
//     _retrieveSession();
//   }
//
//   Future<void> _initDatabase() async {
//     _database = await DatabaseHelper().database;
//   }
//
//   Future<void> _retrieveSession() async {
//     String? isTracking = await _sessionManager.getSession('isTracking');
//     if (isTracking == 'true') {
//       setState(() {
//         _isTracking = true;
//       });
//       _startTracking();
//     }
//   }
//
//   Future<void> _saveSession() async {
//     await _sessionManager.saveSession('isTracking', _isTracking.toString());
//   }
//
//   void _startTracking() async {
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;
//
//     _serviceEnabled = await _location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await _location.requestService();
//       if (!_serviceEnabled) return;
//     }
//
//     _permissionGranted = await _location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await _location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) return;
//     }
//
//     setState(() {
//       _isTracking = true;
//     });
//
//     _locationSubscription = _location.onLocationChanged.listen((LocationData locationData) async {
//       setState(() {
//         _latitude = locationData.latitude.toString();
//         _longitude = locationData.longitude.toString();
//         _timestamp = DateTime.now().toIso8601String();
//       });
//
//       await DatabaseHelper().insertLocation(locationData.latitude!, locationData.longitude!, _timestamp);
//
//       print('Latitude: $_latitude, Longitude: $_longitude, Timestamp: $_timestamp');
//     });
//
//     Timer.periodic(Duration(seconds: 2), (timer) {
//       if (!_isTracking) {
//         timer.cancel();
//       } else {
//         _location.getLocation().then((locationData) async {
//           setState(() {
//             _latitude = locationData.latitude.toString();
//             _longitude = locationData.longitude.toString();
//             _timestamp = DateTime.now().toIso8601String();
//           });
//
//           await DatabaseHelper().insertLocation(locationData.latitude!, locationData.longitude!, _timestamp);
//
//           print('Latitude: ${locationData.latitude}, Longitude: ${locationData.longitude}, Timestamp: $_timestamp');
//         });
//       }
//     });
//
//     _saveSession();
//   }
//
//   void _stopTracking() {
//     setState(() {
//       _isTracking = false;
//     });
//     _locationSubscription.cancel();
//     // Update the database when tracking stops
//     DatabaseHelper().insertLocation(
//       double.parse(_latitude),
//       double.parse(_longitude),
//       _timestamp,
//     );
//     _saveSession();
//   }
//
//   void _showHistory(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const HistoryScreen()),
//     );
//   }
//
//   // void _showEmergency(BuildContext context) {
//   //   Navigator.push(
//   //     context,
//   //     MaterialPageRoute(builder: (context) => const Emergency()),
//   //   );
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         title: const Text('Truck Mitra',style: TextStyle(fontFamily: 'SAMAN___'),),
//         backgroundColor: Colors.yellow[700],
//         actions: [
//           IconButton(
//             icon: Icon(Icons.account_circle),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ProfileScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             SizedBox(height: 20), // Space between status bar and button
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                 onPressed: () async {
//                   await EasyLauncher.call(number: "9405900799");
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   minimumSize: Size(double.infinity, 60), // Full width and height of 60
//                 ),
//                 child: const Text(
//                   'Emergency',
//                   style: TextStyle(fontSize: 20),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 15.0),
//               child: Column(
//                 children: [
//                   Text('Latitude: $_latitude'),
//                   Text('Longitude: $_longitude'),
//                   Text('Timestamp: $_timestamp'),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   side: BorderSide(color: Colors.yellow.shade700, width: 2.0),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('Next stop available:', style: TextStyle(fontSize: 20.0)),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => const StopsScreen()),
//                               );
//                               // Handle "View all" button press
//                             },
//                             child: Text('View all', style: TextStyle(color: Colors.black)),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Icon(Icons.location_on, color: Colors.red, size: 30.0),
//                           SizedBox(width: 8.0),
//                           Text(
//                             'CodeQuest',
//                             style: TextStyle(
//                               fontSize: 20.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8.0),
//                       Text(
//                         'Contact : YCCE',
//                         style: TextStyle(fontSize: 16.0),
//                       ),
//                       SizedBox(height: 16.0),
//                       Center(
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             const url = 'https://maps.app.goo.gl/y5ByWharSbW1Arto8';
//                             final Uri uri = Uri.parse(url);
//                             if (await canLaunchUrl(uri)) {
//                               await launchUrl(uri);
//                             } else {
//                               throw 'Could not launch $url';
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             side: BorderSide(color: Colors.blue),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                           ),
//                           child: Text(
//                             'View in Map',
//                             style: TextStyle(color: Colors.blue, fontSize: 16.0),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   side: BorderSide(color: Colors.yellow.shade700, width: 2.0),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.location_on, color: Colors.red, size: 30.0),
//                           SizedBox(width: 8.0),
//                           Text(
//                             'Nearest',
//                             style: TextStyle(
//                               fontSize: 20.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 16.0),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           _buildServiceColumn(Icons.local_gas_station, 'Fuel Station', 'https://maps.app.goo.gl/7fzgKLCLRGo4ejgn7'),
//                           VerticalDivider(color: Colors.yellow.shade700),
//                           _buildServiceColumn(Icons.restaurant, 'Food Stop', 'https://maps.app.goo.gl/qz9PeEpnnYPXEVqe8'),
//                           VerticalDivider(color: Colors.yellow.shade700),
//                           _buildServiceColumn(Icons.build, 'Auto Repair', 'https://maps.app.goo.gl/S16zBnPYzcJNC4jH6'),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10), // Space between cards and buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: _isTracking ? null : _startTracking,
//                   child: const Text('Start Tracking'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: _isTracking ? _stopTracking : null,
//                   child: const Text('Stop Tracking'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.yellow[700],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 5), // Space between buttons and history button
//             ElevatedButton(
//               onPressed: () {
//                 _showHistory(context);
//               },
//               child: const Text('History'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:icons_launcher/cli_commands.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as pHandler;
import 'package:sqflite/sqflite.dart';
import 'package:truckmitra/profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'database_helper.dart';
import 'history_screen.dart';
import 'sessionmanager.dart';
import 'stops.dart';
import 'emergency.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isTracking = false;
  Location _location = Location();
  late StreamSubscription<LocationData> _locationSubscription;
  String _latitude = 'Unknown';
  String _longitude = 'Unknown';
  String _timestamp = 'Unknown';
  Database? _database;
  final SessionManager _sessionManager = SessionManager();
  final TextEditingController _otpController = TextEditingController();

  Widget _buildServiceColumn(IconData icon, String label, String url) {
    return InkWell(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Column(
        children: [
          Icon(icon, size: 30.0, color: Colors.blue),
          SizedBox(height: 8.0),
          Text(label, style: TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
   
    _initDatabase();
    _retrieveSession();
    _startTracking();
  }

  Future<void> _initDatabase() async {
    _database = await DatabaseHelper().database;
  }

  Future<void> _retrieveSession() async {
    String? isTracking = await _sessionManager.getSession('isTracking');
    if (isTracking == 'true') {
      setState(() {
        _isTracking = true;
      });
      _startTracking();
    }
  }

  Future<void> _saveSession() async {
    await _sessionManager.saveSession('isTracking', _isTracking.toString());
  }

// void _tracker(ServiceInstance service) async {
//   _location.getLocation().then((locationData) async {
//       setState(() {
//         _latitude = locationData.latitude.toString();
//         _longitude = locationData.longitude.toString();
//         _timestamp = DateTime.now().toIso8601String();
//       });

//       await DatabaseHelper().insertLocation(locationData.latitude!, locationData.longitude!, _timestamp);

//       print('Latitude: ${locationData.latitude}, Longitude: ${locationData.longitude}, Timestamp: $_timestamp');
  

//     if (service is AndroidServiceInstance) {
//       if (await service.isForegroundService()) {
//         service.setForegroundNotificationInfo(
//           title: "title", 
//           content: "content + ${DateTime.now()}");
//       }
//     }}
//     );
//   }

  void _startTracking() async {
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

    setState(() {
      _isTracking = true;
    });

    _locationSubscription = _location.onLocationChanged.listen((LocationData locationData) async {
      setState(() {
        _latitude = locationData.latitude.toString();
        _longitude = locationData.longitude.toString();
        _timestamp = DateTime.now().toIso8601String();
      });

      await DatabaseHelper().insertLocation(locationData.latitude!, locationData.longitude!, _timestamp);

      print('Latitude: $_latitude, Longitude: $_longitude, Timestamp: $_timestamp');
    });

    Timer.periodic(Duration(seconds: 2), (timer) {
      if (!_isTracking) {
        timer.cancel();
      } else {
        _location.getLocation().then((locationData) async {
          setState(() {
            _latitude = locationData.latitude.toString();
            _longitude = locationData.longitude.toString();
            _timestamp = DateTime.now().toIso8601String();
          });

          await DatabaseHelper().insertLocation(locationData.latitude!, locationData.longitude!, _timestamp);

          print('Latitude: ${locationData.latitude}, Longitude: ${locationData.longitude}, Timestamp: $_timestamp');
        });
      }
    });

    _saveSession();
  }

  void _stopTracking() {
    setState(() {
      _isTracking = false;
    });
    _locationSubscription.cancel();
    // Update the database when tracking stops
    DatabaseHelper().insertLocation(
      double.parse(_latitude),
      double.parse(_longitude),
      _timestamp,
    );
    _saveSession();
  }

  void _showOtpDialog(BuildContext context, Function onSubmit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter OTP'),
          content: TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter OTP'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSubmit();
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Truck Mitra',style: TextStyle(fontFamily: 'SAMAN___', fontSize: 24),),
        backgroundColor: Colors.yellow[700],
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20), // Space between status bar and button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  await EasyLauncher.call(number: "9405900799");
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize:const Size(double.infinity, 60), // Full width and height of 60
                ),
                child: const Text(
                  'EMERGENCY',
                  style: TextStyle(fontSize: 32 ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 15.0),
              child: Column(
                children: [
                  Text('Latitude: $_latitude'),
                  Text('Longitude: $_longitude'),
                  Text('Timestamp: $_timestamp'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.yellow.shade700, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Next stop available:', style: TextStyle(fontSize: 20.0)),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const StopsScreen()),
                              );
                              // Handle "View all" button press
                            },
                            child: Text('View all', style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.red, size: 30.0),
                          SizedBox(width: 8.0),
                          Text(
                            'CodeQuest',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Contact : YCCE',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 16.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            const url = 'https://maps.app.goo.gl/y5ByWharSbW1Arto8';
                            final Uri uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'View in Map',
                            style: TextStyle(color: Colors.blue, fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.yellow.shade700, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.red, size: 30.0),
                          SizedBox(width: 8.0),
                          Text(
                            'Nearest',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildServiceColumn(Icons.local_gas_station, 'Fuel Station', 'https://maps.app.goo.gl/7fzgKLCLRGo4ejgn7'),
                          VerticalDivider(color: Colors.yellow.shade700),
                          _buildServiceColumn(Icons.restaurant, 'Food Stop', 'https://maps.app.goo.gl/qz9PeEpnnYPXEVqe8'),
                          VerticalDivider(color: Colors.yellow.shade700),
                          _buildServiceColumn(Icons.build, 'Auto Repair', 'https://maps.app.goo.gl/S16zBnPYzcJNC4jH6'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10), // Space between cards and buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isTracking ? null : () => _showOtpDialog(context, _startTracking),
                  child: const Text('Start Tracking'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                ElevatedButton(
                  onPressed: _isTracking ? () => _showOtpDialog(context, _stopTracking) : null,
                  child: const Text('Stop Tracking'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5), // Space between buttons and history button
            ElevatedButton(
              onPressed: () {
                _showHistory(context);
              },
              child: const Text('History'),
            ),
          ],
        ),
      ),
    );
  }
}