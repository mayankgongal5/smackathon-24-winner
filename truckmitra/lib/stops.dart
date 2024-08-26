import 'package:flutter/material.dart';
import 'package:truckmitra/profile.dart';
import 'package:url_launcher/url_launcher.dart';

class StopsScreen extends StatelessWidget {
  const StopsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stops = [
      {'title': 'CSE Dept', 'contact': 'gcoen'},
      {'title': 'ETC Dept', 'contact': 'gcoen'},
      {'title': 'Electrical Dept', 'contact': 'gcoen'},
      {'title': 'Mechanical Dept', 'contact': 'gcoen'},
      {'title': 'Civil Dept', 'contact': 'gcoen'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('STOPS'),
        backgroundColor: Colors.yellow.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: stops.length,
        itemBuilder: (context, index) {
          final stop = stops[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                        Text('Upcoming stop ${index + 1}:', style: TextStyle(fontSize: 20.0)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red, size: 30.0),
                        SizedBox(width: 8.0),
                        Text(
                          stop['title']!,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Contact: ${stop['contact']}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          const url = 'https://maps.app.goo.gl/cFM2p2JEJccZVcr86';
                          if (await canLaunch(url)) {
                            await launch(url);
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
          );
        },
      ),
    );
  }
}