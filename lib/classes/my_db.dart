import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// TODO singleton pattern
class MyDb {
  static late Database db;
  static Future<Database> init() async {
    String databasesPath = await getDatabasesPath();
    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {}
    return await openDatabase(
      join(databasesPath, 'pointr.db'),
      onCreate: (db, version) => db.execute(
        'CREATE TABLE star(id INTEGER PRIMARY KEY, name TEXT, lat REAL, lng REAL)',
      ),
      version: 1,
    );
  }
}
