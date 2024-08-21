import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config/my_theme.dart';
import '../../infrastructure/services/packages/hooks.dart';
import 'space.dart';

class MapWithPinAndBanner extends HookConsumerWidget {
  final CameraPosition initialCameraPosition;
  final MapCreatedCallback? onMapCreated;
  final Set<Polyline>? polylines;
  final Set<Marker>? markers;
  final EdgeInsets? padding;
  final bool hidePin;
  final Color? primaryColor;
  final IconData topIconData;

  const MapWithPinAndBanner({
    super.key,
    required this.initialCameraPosition,
    this.padding,
    this.hidePin = false,
    this.onMapCreated,
    this.markers,
    this.polylines,
    this.primaryColor,
    this.topIconData = Icons.not_listed_location_sharp,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMoving = useState<bool>(false);
    final mapCtlCompleter = useMemoized(
      () => Completer<GoogleMapController>(),
      [context],
    );
    final googleMap = GestureDetector(
      onDoubleTap: () async {
        final mapCtl = await mapCtlCompleter.future;
        mapCtl.animateCamera(
          CameraUpdate.zoomIn(),
        );
      },
      child: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (mapCtl) {
          if (onMapCreated == null) return;
          mapCtlCompleter.complete(mapCtl);
          onMapCreated!(mapCtl);
        },
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        padding: padding ?? EdgeInsets.zero,
        markers: markers ?? {},
        polylines: polylines ?? {},
        onCameraMoveStarted: () => isMoving.value = true,
        onCameraIdle: () => isMoving.value = false,
      ),
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        googleMap,
        AnimatedSize(
          duration: kThemeAnimationDuration,
          child: hidePin
              ? const SizedBox.shrink()
              : FractionallySizedBox(
                  heightFactor: 0.5,
                  alignment: Alignment.topCenter,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _Pin(
                      key: const ValueKey('map moving pin'),
                      isStationary: !isMoving.value,
                      primaryColor: primaryColor ?? MyTheme.primaryColor,
                      iconData: topIconData,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _Pin extends HookConsumerWidget {
  const _Pin({
    super.key,
    required this.isStationary,
    required this.primaryColor,
    required this.iconData,
  });

  final bool isStationary;
  final Color primaryColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPinExpanded = useBoolWhereTruthyDebounced(
      isStationary,
      kThemeAnimationDuration * 2,
    );
    final blackDot = SizedBox.square(
      dimension: 8,
      child: CircleAvatar(
        backgroundColor: MyTheme.secondaryColor.shade900,
      ),
    );
    final stationaryMarker = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          color: primaryColor,
          shadows: const [Shadow()],
          size: 48,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          child: const SizedBox.square(
            dimension: 3,
          ),
        ),
        4.verticalSpace,
        DecoratedBox(
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          child: const SizedBox.square(
            dimension: 5,
          ),
        ),
        4.verticalSpace,
        DecoratedBox(
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          child: const SizedBox.square(
            dimension: 8,
          ),
        ),
      ],
    );
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        blackDot,
        AnimatedScale(
          scale: isPinExpanded ? 1 : 0,
          alignment: Alignment.bottomCenter,
          duration: kThemeAnimationDuration,
          child: stationaryMarker,
        ),
      ],
    );
  }
}
