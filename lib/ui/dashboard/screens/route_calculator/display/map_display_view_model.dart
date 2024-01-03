import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../models/coordinates.dart';
import '../../../../../models/located_place.dart';
import '../../../../../repo/location.dart';
import '../route_calculator_view_model.dart';
import 'map_display.dart';

final gmapCtlProvider = StateProvider<Completer<GoogleMapController>>(
  (ref) => Completer<GoogleMapController>(),
);

class MapDisplayViewModel {
  final BuildContext context;
  final WidgetRef ref;

  const MapDisplayViewModel(this.context, this.ref);

  Coordinates get initialCoordinates {
    final pathCoordinates = (context.widget as MapDisplay).initialCoordinates;
    if (pathCoordinates != null) return pathCoordinates;
    final currentLoc = ref.read(currentLocProvider).valueOrNull;
    if (currentLoc != null) return currentLoc;
    return karachiLatLng;
  }

  void onMapCreated(GoogleMapController controller) => ref
      .read(
        gmapCtlProvider.notifier,
      )
      .state
      .complete(
        controller,
      );

  Set<Marker> get markers => ref
      .watch(fromToStopsProvider)
      .whereType<LocatedPlace>()
      .map(
        (stop) => Marker(
          markerId: MarkerId(stop.title),
          position: stop.coordinates.latLng,
        ),
      )
      .toSet();
}
