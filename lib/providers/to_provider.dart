import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointr/providers/route_provider.dart';
import 'package:provider/provider.dart';

class ToProvider with ChangeNotifier {
  LatLng? _selected;
  String? _name;

  void select({
    required LatLng latLng,
    required String name,
    required BuildContext context,
  }) {
    _selected = latLng;
    _name = name;
    var routeProvider = Provider.of<RouteProvider>(context, listen: false);
    routeProvider.calculateViability(context);
    notifyListeners();
  }

  void clear() {
    if (_name == null && _selected == null) return;
    _selected = null;
    _name = null;
    notifyListeners();
  }

  String? get title => _name;
  LatLng? get selected => _selected;
}
