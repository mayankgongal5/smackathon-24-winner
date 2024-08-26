
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:truckmitra/database_helper.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:truckmitra/listen_location.dart';

import 'auth.dart';
import 'creds.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Credentials.SUPABASE_URL,
    anonKey: Credentials.SUPABASE_ANON_KEY,
  );

    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    }); 
    await initializeService();

  runApp(const MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart, 
      autoStart: true,
      autoStartOnBoot: true,
      isForegroundMode: true
    )
  );
  debugPrint("SERVICE CONFIGURED");
  await service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
    final DatabaseHelper dbHelper = DatabaseHelper();
    
    
  if (service is AndroidServiceInstance) {
    // service.on('setAsForeground').listen((event){
    //   service.setAsForegroundService();
    // });
    service.on('setAsBackgroundService').listen((event){
      print("Order for background serivce");
      service.setAsBackgroundService();
    });
  } 

  service.on('stopService').listen((event){
    print("Stopped service for upload");
    service.stopSelf();
  }); 

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    ListenLocation().listenLocation();
    final unsyncedLocations = await dbHelper.getUnsyncedLocations();
    print('dataSynced');
    try {
      await Supabase.initialize(
        url: Credentials.SUPABASE_URL,
        anonKey: Credentials.SUPABASE_ANON_KEY,
      );
    } catch (e) {
      print(e.toString());
    }
    final supabase = Supabase.instance.client;
    if (supabase.auth.currentUser != null) {

      final List<Map<String, dynamic>> response = await supabase.from('locations').insert(unsyncedLocations).select('timestamp');

      for (var location in response) {
        // supabase.from('locations').insert()
        await dbHelper.updateLocationSyncStatus(location['timestamp'], 1);
      }
      // print(data);
    }
  });
  if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: "TruckMitra", 
          content: "Location:  + ${DateTime.now()}, ${DateTime.now()}");
      }
    }

}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) => const Scaffold(
            body: Center(
              child: Text(
                'Not Found',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}