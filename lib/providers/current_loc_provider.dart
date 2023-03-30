import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pointr/providers/nearby_provider.dart';
import 'package:provider/provider.dart';

class CurrentLocProvider with ChangeNotifier {
  PermissionStatus? _permissionStatus;
  PermissionStatus? get permissionStatus => _permissionStatus;
  LatLng? _latLng;
  LatLng? get latLng => _latLng;

  Future<void> fetchCurrentLocation(BuildContext context) async {
    // check permission
    if (await Permission.location.request() == PermissionStatus.denied) {
      _permissionStatus = PermissionStatus.denied;
      notifyListeners();
      return;
    }
    // get current loc
    Position p = await Geolocator.getCurrentPosition();
    _latLng = LatLng(p.latitude, p.longitude);
    notifyListeners();
    // fetch nearby suggestions
    if (context.mounted) {
      Provider.of<NearbyProvider>(context, listen: false).fetch(context);
    }
  }
}
