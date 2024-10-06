import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../config/my_theme.dart';
import '../../../domain/entities/coordinates_entity.dart';
import '../../../domain/entities/route_entity.dart';
import '../../../domain/repositories/i_location_repo.dart';
import '../../../infrastructure/services/packages/iterable.dart';
import '../../components/dialogs.dart';
import '../../components/header_footer.dart';
import '../../components/map/gmap_buttons.dart';
import '../../components/map/map_with_pin_and_banner.dart';
import '../../components/map/routes_legend_list_view.dart';
import '../../components/space.dart';

class DisplayRouteScreen extends HookWidget {
  const DisplayRouteScreen(this.routes, {super.key});

  final Set<RouteEntity> routes;

  Set<Polyline> _segmentToPolylines(Set<RouteEntity> routes) {
    final polylines = <Polyline>{};
    for (int i = 0; i < routes.length; i++) {
      final route = routes.elementAt(i);
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
  }

  @override
  Widget build(BuildContext context) {
    final selectedSegmentIndex = useState(0);
    final routeSegments = routes
        .splitByLength(4)
        .map(
          (segment) => segment.toSet(),
        )
        .toList();
    final legend = RoutesLegendListView(
      routeSegments,
      onScrollToNewSegment: (index) => selectedSegmentIndex.value = index,
    );
    final polylines = _segmentToPolylines(
      routeSegments[selectedSegmentIndex.value],
    );
    final mapCtlCompleter = useRef(Completer<GoogleMapController>()).value;
    mapCtlCompleter.future.then(
      (ctl) {
        final allRoutesBounds = routes.map(
          (route) {
            final bounds = route.getBounds();
            return [bounds.northEast, bounds.southWest];
          },
        ).fold(
          <CoordinatesEntity>[],
          (prev, e) => [...e, ...prev],
        );
        final collectiveBounds = RouteEntity(
          name: '',
          mode: RouteMode.minibus,
          points: allRoutesBounds,
        ).getBounds();
        ctl.moveCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(
                collectiveBounds.southWest.latitude,
                collectiveBounds.southWest.longitude,
              ),
              northeast: LatLng(
                collectiveBounds.northEast.latitude,
                collectiveBounds.northEast.longitude,
              ),
            ),
            0,
          ),
        );
      },
    );
    final arePedBridgesVisible = useState(false);
    final googleMap = MapWithPinAndBanner(
      polylines: polylines,
      onMapCreated: (controller) => mapCtlCompleter.complete(controller),
      initialCameraPosition: CameraPosition(
        target: LatLng(
          karachiLatLng.latitude,
          karachiLatLng.longitude,
        ),
      ),
      arePedBridgesVisible: arePedBridgesVisible,
      // zoomControlsEnabled: false,
      // myLocationEnabled: true,
      // myLocationButtonEnabled: false,
      padding: const EdgeInsets.symmetric(
        vertical: 148,
        horizontal: 36,
      ),
    );
    final copyAndUpdateButton = ElevatedButton.icon(
      icon: const Icon(Icons.copy),
      label: const Text('Copy and update'),
      onPressed: () => context.loaderWithErrorDialog(
        () {},
      ),
      style: MyTheme.primaryElevatedButtonStyle,
    );
    final backBtn = ElevatedButton(
      onPressed: context.pop,
      style: MyTheme.secondaryButtonStyle,
      child: const Icon(
        Icons.arrow_back_ios_new_outlined,
      ),
    );
    final footer = Footer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            legend,
            12.verticalSpace,
            Row(
              children: [
                backBtn,
                12.horizontalSpace,
                // TODO copy and update
                if (false)
                  // ignore: dead_code
                  Expanded(
                    child: copyAndUpdateButton,
                  ),
              ],
            ),
            kBottomNavigationBarHeight.verticalSpace,
          ],
        ),
      ),
    );
    final overlay = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
              bottom: 48,
              end: 12,
            ),
            child: GmapButtons(
              mapCtlCompleter,
              arePedBridgesVisible: arePedBridgesVisible,
            ),
          ),
        ),
        footer,
      ],
    );
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          googleMap,
          overlay,
        ],
      ),
    );
  }
}
