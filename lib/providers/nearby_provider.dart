import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointr/classes/google_api.dart';
import 'package:pointr/classes/located_google_place.dart';
import 'package:pointr/providers/current_loc_provider.dart';
import 'package:provider/provider.dart';

class NearbyProvider with ChangeNotifier {
  List<LocatedGooglePlace>? _suggestions;
  List<LocatedGooglePlace>? get suggestions => _suggestions;
  Future<void> fetch(BuildContext context) async {
    // get current loc
    LatLng? latLng =
        Provider.of<CurrentLocProvider>(context, listen: false).latLng;
    if (latLng == null) return;
    // get nearby results
    _suggestions = await GoogleApi.nearbyPlaces(latLng) ?? [];
    notifyListeners();
  }
}
