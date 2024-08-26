import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  final _locationStreamController = StreamController<List<Map<String, dynamic>>>.broadcast();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE IF NOT EXISTS locations (
            truck_id STRING,
            lat REAL,
            long REAL,
            timestamp TIMESTAMP PRIMARY KEY ,
            isSynced INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<void> insertLocation(double lat, double long, String timestamp) async {
    final db = await database;
    final time = DateTime.parse(timestamp).toIso8601String();
    await db.insert(
      'locations',
      {
        'truck_id': "MH31AB2308",
        'lat': lat,
        'long': long,
        'timestamp': time,
      },
    );
    _locationStreamController.add(await fetchLocations());
  }

  // Future<void> insertLocation(double latitude, double longitude, String timestamp) async {
  //   final db = await database;
  //   await db.insert(
  //     'locations',
  //     {
  //       'latitude': latitude,
  //       'longitude': longitude,
  //       'timestamp': timestamp,
  //     },
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
    // _locationStreamController.add(await fetchLocations());
  // }

  Future<List<Map<String, dynamic>>> fetchLocations() async {
    final db = await database;
    return await db.query('locations', orderBy: 'timestamp DESC');
  }

  void dispose() {
    _locationStreamController.close();
  }

  Future<List<Map<String, dynamic>>> getUnsyncedLocations() async {
    final db = await database;
    final res = await db.query(
      'locations',
      columns: ['truck_id', 'timestamp', 'lat', 'long', 'isSynced'],
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    print("UNSYNCED LOCATIONS:");
    print(res);
    return res;  
  }

  Future<void> updateLocationSyncStatus(String timestamp, int isSynced) async {
    final db = await database;
    print("Is Updating");
    print(timestamp);
    final time = DateTime.parse(timestamp).toIso8601String().substring(0, "2024-08-24T03:45:35.809342".length);
    print(time);
    final res = await db.rawUpdate(
      // 'locations',
      // {'isSynced': isSynced},
      // where: 'timestamp = ?',
      // whereArgs: [timestamp],
      'UPDATE locations SET isSynced = ? WHERE timestamp = ?',
      [isSynced, time]
    );
    print("res");
    print(res);
  }

}