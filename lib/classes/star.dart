import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointr/classes/my_db.dart';
import 'package:sqflite/sqflite.dart';

class Star {
  int id;
  String name;
  LatLng latLng;

  Star(this.id, this.name, this.latLng);
  static late List<Star> all;

  @override
  String toString() => name;
  static get nextId =>
      all.fold<int>(0, (prevId, star) => star.id > prevId ? star.id : prevId) +
      1;

  static Future<void> updateAll() async {
    final List<Map<String, dynamic>> maps = await MyDb.db.query('star');
    all = List.generate(
      maps.length,
      (i) => Star(
        maps[i]['id'],
        maps[i]['name'],
        LatLng(maps[i]['lat'], maps[i]['lng']),
      ),
    );
  }

  Future<void> insert() async => MyDb.db.insert(
        'star',
        toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  Future<void> delete() async => MyDb.db.delete(
        'star',
        where: 'id = ?',
        whereArgs: [id],
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'lat': latLng.latitude,
        'lng': latLng.longitude,
      };
}
