import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorite {
  String name;
  LatLng latLng;
  Favorite(this.name, this.latLng);

  static Future<List<Favorite>> favorites() async {
    final prefs = await SharedPreferences.getInstance();
    Map result = jsonDecode(prefs.getString('favorites') ?? '{}');
    List<Favorite> favorites = [];
    result.forEach(
      (key, value) => favorites.add(
        Favorite(
          key,
          LatLng(value.first, value.last),
        ),
      ),
    );
    return favorites;
  }

  static Future<Favorite?> setFavorite(
    String name,
    double latitude,
    double longitude,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String names = prefs.getString('favorites') ?? '{}';
    Map favorites = jsonDecode(names);
    if (favorites.containsKey(name)) return null;
    favorites[name] = [latitude, longitude];
    prefs.setString('favorites', jsonEncode(favorites));
    return Favorite(name, LatLng(latitude, longitude));
  }

  static Future removeFavorite(String name) async {
    final prefs = await SharedPreferences.getInstance();
    String names = prefs.getString('favorites') ?? '{}';
    Map favorites = jsonDecode(names);
    favorites.removeWhere((key, value) => key == name);
    prefs.setString('favorites', jsonEncode(favorites));
  }
}
