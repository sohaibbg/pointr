import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/injector.dart';
import '../repositories/i_pedestrian_bridge_repo.dart';

part 'pedestrian_bridges_use_case.g.dart';

@riverpod
Future<Iterable<Marker>> pedestrianBridgeMarkers(
  PedestrianBridgeMarkersRef ref,
) async {
  final markerImage = await rootBundle.load(
    'assets/images/walk.png',
  );
  final bytes = markerImage.buffer.asUint8List();
  final markerIcon = BitmapDescriptor.bytes(
    bytes,
    height: 24,
  );
  final repo = getIt.call<IPedestrianBridgeRepo>();
  final pedestrianBridgeMarkers = repo.getPedestrianBridgeCoordinates().map(
        (e) => Marker(
          markerId: MarkerId(e.toString()),
          position: LatLng(e.latitude, e.longitude),
          icon: markerIcon,
        ),
      );
  return pedestrianBridgeMarkers;
}
