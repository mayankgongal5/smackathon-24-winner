import 'package:flutter/material.dart';
import 'database_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _locationHistory = [];

  @override
  void initState() {
    super.initState();
    _loadLocationHistory();
  }

  Future<void> _loadLocationHistory() async {
    final data = await DatabaseHelper().fetchLocations();
    setState(() {
      _locationHistory = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLocationHistory,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _locationHistory.length,
        itemBuilder: (context, index) {
          final location = _locationHistory[index];
          return ListTile(
            title: Text('Latitude: ${location['lat']}, Longitude: ${location['long']}'),
            subtitle: Text('Timestamp: ${location['timestamp']}'),
          );
        },
      ),
    );
  }
}