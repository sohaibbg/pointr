part of '../go_screen.dart';

class _GoMap extends ConsumerWidget {
  const _GoMap({
    required this.mapCtlCompleter,
  });

  final Completer<GoogleMapController> mapCtlCompleter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = _GoMapViewModel(context, ref);
    return MapWithPinAndBanner(
      initialCameraPosition: CameraPosition(
        target: vm.initialLatLng,
        zoom: 15,
      ),
      hidePin: vm.areBothStopsConfirmed,
      markers: vm.markers,
      polylines: vm.polylines.when(
        loading: () => null,
        error: (error, stackTrace) => null,
        data: (data) => data,
      ),
      onMapCreated: mapCtlCompleter.complete,
      padding: const EdgeInsets.symmetric(
        vertical: 350,
      ),
    );
  }
}

class _GoMapViewModel extends ViewModel<_GoMap> {
  const _GoMapViewModel(super.context, super.ref);

  LatLng get initialLatLng {
    final permission = ref.read(locPermissionProvider).valueOrNull;
    if (![
      LocationPermission.always,
      LocationPermission.whileInUse,
    ].contains(permission)) {
      return LatLng(
        karachiLatLng.latitude,
        karachiLatLng.longitude,
      );
    }
    final coordinates =
        ref.read(currentLocProvider).valueOrNull ?? karachiLatLng;
    return LatLng(
      coordinates.latitude,
      coordinates.longitude,
    );
  }

  bool get areBothStopsConfirmed =>
      ref.watch(
        currentlyPickingDirectionTypeProvider,
      ) ==
      null;

  Set<Marker> get markers {
    final result = <Marker>{};
    final from = ref.watch(fromStopProvider);
    if (from != null) {
      final fromMarker = Marker(
        markerId: const MarkerId('from'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue,
        ),
        position: LatLng(
          from.coordinates.latitude,
          from.coordinates.longitude,
        ),
      );
      result.add(fromMarker);
    }
    final to = ref.watch(toStopProvider);
    if (to != null) {
      final toMarker = Marker(
        markerId: const MarkerId('to'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
        position: LatLng(
          to.coordinates.latitude,
          to.coordinates.longitude,
        ),
      );
      result.add(toMarker);
    }
    return result;
  }

  AsyncValue<Set<Polyline>> get polylines => areBothStopsConfirmed
      ? ref
          .watch(
          scoredRouteGroupsProvider,
        )
          .whenData(
          (groups) {
            final index = ref.watch(
              selectedRouteGroupIndexProvider,
            );
            final segment = groups[index];
            final polylines = <Polyline>{};
            // loop index is used to set polyline colors
            for (int i = 0; i < segment.length; i++) {
              final route = segment.elementAt(i);
              final polyine = Polyline(
                polylineId: PolylineId(route.name),
                points: route.points
                    .map(
                      (point) => LatLng(
                        point.latitude,
                        point.longitude,
                      ),
                    )
                    .toList(),
                color: RoutesLegendListView.colorLegend[i].withOpacity(0.6),
              );
              polylines.add(polyine);
            }
            return polylines;
          },
        )
      : const AsyncData({});
}
