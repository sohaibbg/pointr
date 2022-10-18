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

  static Future<void> updateAll() async {
    all = [
      Star(
        0,
        'Home',
        const LatLng(0, 0),
      ),
      Star(
        1,
        'Work',
        const LatLng(0, 0),
      ),
      Star(
        2,
        'Uni',
        const LatLng(0, 0),
      ),
      Star(
        3,
        'Office',
        const LatLng(0, 0),
      ),
    ];
    // final List<Map<String, dynamic>> maps = await MyDb.db.query('dogs');
    // all = List.generate(maps.length, (i) {
    //   return Star(
    //     maps[i]['id'],
    //     maps[i]['name'],
    //     LatLng(maps[i]['lat'], maps[i]['lng']),
    //   );
    // });
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
