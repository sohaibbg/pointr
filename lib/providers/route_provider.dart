import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointr/classes/viable_route.dart';
import 'package:pointr/providers/from_provider.dart';
import 'package:pointr/providers/to_provider.dart';
import 'package:provider/provider.dart';

import '../classes/catalogue.dart';

class RouteProvider with ChangeNotifier {
  final Map<double, Set<Polyline>> _all = {};
  Map<double, Set<Polyline>> get all => _all;
  double? _selectedScore;
  double? get selectedScore => _selectedScore;
  set selectedScore(double? score) {
    _selectedScore = score;
    notifyListeners();
  }

  Polyline get selected => _all.entries
      .firstWhere((entry) => entry.key == _selectedScore)
      .value
      .first;
  void calculateViability(BuildContext context) {
    // // fetch all routes
    // if (Catalogue.routes == null) {
    //   await Catalogue.loadRoutes();
    // }
    // fetch points
    LatLng? from;
    LatLng? to;
    if (context.mounted) {
      from = Provider.of<FromProvider>(context, listen: false).selected;
      to = Provider.of<ToProvider>(context, listen: false).selected;
    }
    if (from == null || to == null) return;
    // calculate viability
    List<ViableRoute> viableRoutes = Catalogue.routes!
        .map((route) => ViableRoute.between(from!, to!, route))
        .toList();
    // gather scores
    List<double> scoreOptions = [];
    // TODO better sort
    for (var route in viableRoutes) {
      scoreOptions.add(route.score);
    }
    // sort
    scoreOptions = scoreOptions.toSet().toList();
    scoreOptions.sort();
    _selectedScore = scoreOptions.first;
    // group
    for (int i = 0; i < scoreOptions.length; i++) {
      var score = scoreOptions[i];
      _all[score] = viableRoutes
          .where((vr) => vr.score == score)
          .map(
            (vr) => vr.polyline.copyWith(
              colorParam: Colors.primaries[i % Colors.primaries.length],
            ),
          )
          .toSet();
    }
    notifyListeners();
  }
}
