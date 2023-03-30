import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ToProvider with ChangeNotifier {
  LatLng? _selected;
  String? _name;

  void select({required LatLng latLng, required String name}) {
    _selected = latLng;
    _name = name;
    notifyListeners();
  }

  String? get name => _name;
  LatLng? get selected => _selected;
}
