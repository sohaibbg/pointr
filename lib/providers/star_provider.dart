import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointr/classes/my_db.dart';
import 'package:pointr/classes/star.dart';
import 'package:sqflite/sqflite.dart';

class StarProvider with ChangeNotifier {
  List<Star> _all = [];
  List<Star> get all => _all;

  Future<void> readAll() async {
    final List<Map<String, dynamic>> maps = await MyDb.db.query('star');
    _all = List.generate(
      maps.length,
      (i) => Star(
        maps[i]['id'],
        maps[i]['name'],
        LatLng(maps[i]['lat'], maps[i]['lng']),
      ),
    );
    notifyListeners();
  }

  Future<Star> create(Star star) async {
    int id = await MyDb.db.insert(
      'star',
      star.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _all.add(Star(id, star.title, star.latLng));
    notifyListeners();
    return Star(id, star.title, star.latLng);
  }

  Future<void> delete(Star star) async {
    await MyDb.db.delete(
      'star',
      where: 'id = ?',
      whereArgs: [star.id],
    );
    _all.removeWhere((element) => element.id == star.id);
    notifyListeners();
  }
}
