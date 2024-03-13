import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../config/injector.dart';
import '../../../domain/entities/address_entity.dart';
import '../../../domain/entities/route_entity.dart' as pointr;
import '../../../domain/repositories/i_location_repo.dart';
import '../../../domain/repositories/i_places_repo.dart';
import '../../../domain/use_cases/location_use_case.dart';
import '../../../domain/use_cases/routes_use_case.dart';
import '../../../infrastructure/services/packages/google_map_controller.dart';
import '../../../infrastructure/services/packages/view_model.dart';
import '../../components/dialogs.dart';
import 'route_calculator.dart';

part 'route_calculator_view_model.g.dart';

enum DirectionType { from, to }

final fromStopProvider = StateProvider<AddressEntity?>((ref) => null);
final toStopProvider = StateProvider<AddressEntity?>((ref) => null);

@riverpod
DirectionType? currentlyPickingDirectionType(
  CurrentlyPickingDirectionTypeRef ref,
) {
  final from = ref.watch(fromStopProvider);
  if (from == null) return DirectionType.from;
  final to = ref.watch(toStopProvider);
  if (to == null) return DirectionType.to;
  return null;
}

final selectedRouteModesProvider = StateProvider<ISet<pointr.RouteMode>>(
  (ref) => ISet<pointr.RouteMode>(pointr.RouteMode.values),
);

@riverpod
List<Set<pointr.RouteEntity>>? routeSegments(RouteSegmentsRef ref) {
  final from = ref.watch(fromStopProvider);
  final to = ref.watch(toStopProvider);
  if (from == null && to == null) return null;
  final selectedRouteModes = ref.watch(selectedRouteModesProvider);
  final routes = ref.watch(scoredRoutesProvider).valueOrNull;
  if (routes == null) return null;
  return routes.keys
      .where(
        (route) => selectedRouteModes.contains(route.mode),
      )
      .toList()
      .splitByLength(4)
      .map((e) => e.toSet())
      .toList();
}

final selectedSegmentIndexProvider = StateProvider<int>(
  (ref) => 0,
);

@riverpod
Future<Map<pointr.RouteEntity, double>> scoredRoutes(
  ScoredRoutesRef ref,
) async {
  final storedRoutes = await ref.watch(
    routesUseCaseProvider.future,
  );
  final from = ref.watch(fromStopProvider)!.coordinates;
  final to = ref.watch(toStopProvider)!.coordinates;
  final scoredRoutes = <pointr.RouteEntity, double>{};
  for (int i = 0; i < storedRoutes.length; i++) {
    final route = storedRoutes.elementAt(i);
    final score = route.distanceScore(from, to);
    scoredRoutes[route] = score;
  }
  final sortedResult = Map.fromEntries(
    scoredRoutes.entries.toList()
      ..sort(
        (e1, e2) => e1.value.compareTo(e2.value),
      ),
  );
  return sortedResult;
}

class RouteCalculatorViewModel extends ViewModel<RouteCalculator> {
  const RouteCalculatorViewModel(
    super.context,
    super.ref, {
    required this.focusNode,
    required this.gmapCtlCompleter,
  });

  void onPopInvoked(bool didPop) {
    if (focusNode.hasFocus) return focusNode.unfocus();
    final from = ref.read(fromStopProvider);
    final to = ref.read(toStopProvider);
    if (from != null && to != null) {
      return ref.read(toStopProvider.notifier).state = null;
    }
    if (to != null) {
      return ref.read(toStopProvider.notifier).state = null;
    }
    if (from != null) {
      return ref.read(fromStopProvider.notifier).state = null;
    }
    context.pop();
  }

  static const colorLegend = [
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.green,
  ];

  final FocusNode focusNode;
  final Completer<GoogleMapController> gmapCtlCompleter;

  bool get areBothStopsConfirmed =>
      ref.watch(
        currentlyPickingDirectionTypeProvider,
      ) ==
      null;

  Set<Marker> get markers => [
        fromStopProvider,
        toStopProvider,
      ]
          .map(
            (e) => ref.watch(e),
          )
          .where(
            (element) => element != null,
          )
          .map(
            (e) => Marker(
              markerId: MarkerId(e!.address),
              position: LatLng(
                e.coordinates.latitude,
                e.coordinates.longitude,
              ),
            ),
          )
          .toSet();

  Set<Polyline> get polylines {
    final segments = ref.watch(
      routeSegmentsProvider,
    );
    if (segments == null) return {};
    final index = ref.watch(
      selectedSegmentIndexProvider,
    );
    final segment = segments[index];
    final polylines = <Polyline>{};
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
        color: RouteCalculatorViewModel.colorLegend[i],
      );
      polylines.add(polyine);
    }
    return polylines;
  }

  LatLng get initialLatLng {
    final coordinates = widget.initialPlace?.coordinates ??
        ref.read(currentLocProvider).valueOrNull ??
        karachiLatLng;
    return LatLng(
      coordinates.latitude,
      coordinates.longitude,
    );
  }

  Future<void> onPlaceSelected(place) async {
    final mapCtl = await gmapCtlCompleter.future;
    mapCtl.animateCamera(
      CameraUpdate.newLatLngZoom(
        place.coordinates.latLng,
        15,
      ),
    );
  }

  /// only animates if both stops are set
  Future<void> _animateCameraToBoundsOfStops() async {
    final from = ref.read(fromStopProvider)?.coordinates;
    if (from == null) return;
    final to = ref.read(toStopProvider)?.coordinates;
    if (to == null) return;
    final southwest = LatLng(
      from.latitude < to.latitude ? from.latitude : to.latitude,
      from.longitude < to.longitude ? from.longitude : to.longitude,
    );
    final northeast = LatLng(
      from.latitude > to.latitude ? from.latitude : to.latitude,
      from.longitude > to.longitude ? from.longitude : to.longitude,
    );
    final latLngBounds = LatLngBounds(
      southwest: southwest,
      northeast: northeast,
    );
    final mapCtl = await gmapCtlCompleter.future;
    mapCtl.animateCamera(
      CameraUpdate.newLatLngBounds(
        latLngBounds,
        36,
      ),
    );
  }

  Future<void> onPlaceConfirmed() async {
    final mapCtl = await gmapCtlCompleter.future;
    final mapLatLng = await mapCtl.centerLatLng;
    return context.loaderWithErrorDialog(
      () async {
        final address = await getIt.call<IPlacesRepo>().getNameFrom(
              mapLatLng,
            );
        final newStop = AddressEntity(
          address: address,
          coordinates: mapLatLng,
        );
        final directionType = ref.read(
          currentlyPickingDirectionTypeProvider,
        );
        final stopProvider = switch (directionType!) {
          DirectionType.from => fromStopProvider,
          DirectionType.to => toStopProvider,
        };
        ref.read(stopProvider.notifier).state = newStop;
        _animateCameraToBoundsOfStops();
      },
    );
  }

  String get selectLocBtnLabel {
    final currentlyPickingStop = ref
            .watch(
              currentlyPickingDirectionTypeProvider,
            )
            ?.name
            .toUpperCase() ??
        "";
    return "Set $currentlyPickingStop location";
  }

  bool get isBottomInset => MediaQuery.of(context).viewInsets.bottom > 180;
}
