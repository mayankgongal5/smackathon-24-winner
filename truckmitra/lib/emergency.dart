import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Emergency extends StatefulWidget {

  const Emergency({super.key });

  @override
  State<Emergency> createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  Future<void> _dialEmergencyNumber() async {
    const emergencyNumber = 'tel:9405900799';
    if (await canLaunch(emergencyNumber)) {
      await launch(emergencyNumber);
    } else {
      throw 'Could not launch $emergencyNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _dialEmergencyNumber,
          child: const Text('Call Emergency'),
        ),
      ),
    );
  }
}