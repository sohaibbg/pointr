import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../models/coordinates.dart';
import '../route_calculator_view_model.dart';
import 'map_display_view_model.dart';

final gmapCtlProvider = StateProvider<Completer<GoogleMapController>>(
  (ref) => Completer<GoogleMapController>(),
);

class MapDisplay extends ConsumerWidget {
  final Coordinates? initialCoordinates;

  const MapDisplay({super.key, required this.initialCoordinates});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = MapDisplayViewModel(context, ref);
    return GoogleMap(
      onMapCreated: vm.onMapCreated,
      initialCameraPosition: CameraPosition(
        target: vm.initialCoordinates.latLng,
      ),
      polylines: ref
          .watch(selectedRoutesProvider)
          .map(
            (e) => Polyline(
              polylineId: PolylineId(e.name),
              points: e.points.map((point) => point.latLng).toList(),
            ),
          )
          .toSet(),
      markers: vm.markers,
    );
  }
}
