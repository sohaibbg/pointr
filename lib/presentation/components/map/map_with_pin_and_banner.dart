import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../config/my_theme.dart';
import '../../../infrastructure/services/packages/hooks.dart';
import '../space.dart';

class MapWithPinAndBanner extends HookConsumerWidget {
  final CameraPosition initialCameraPosition;
  final MapCreatedCallback? onMapCreated;
  final Set<Polyline>? polylines;
  final Set<Marker>? markers;
  final EdgeInsets? padding;
  final bool hidePin;
  final Color? primaryColor;
  final IconData topIconData;
  final CameraPositionCallback? onCameraMove;

  /// makes tapped polyline opaque and the rest transparent on tap
  final bool emphasizePolylineOnTap;

  const MapWithPinAndBanner({
    super.key,
    required this.initialCameraPosition,
    this.padding,
    this.hidePin = false,
    this.onMapCreated,
    this.markers,
    this.polylines,
    this.primaryColor,
    this.topIconData = Icons.location_pin,
    this.onCameraMove,
    this.emphasizePolylineOnTap = true,
  });

  Set<Polyline> getTappablePolylines(
    Set<Polyline>? polylines,
    ValueNotifier<Polyline?> selection,
  ) {
    if (!emphasizePolylineOnTap) return polylines ?? {};
    if (polylines == null) return {};
    if (polylines.isEmpty) return {};
    final result = <Polyline>{};
    for (int i = 0; i < polylines.length; i++) {
      final e = polylines.elementAt(i);
      final originalColor = e.color;
      final isSelected = selection.value == e;
      final newColor = selection.value == null
          ? originalColor
          : isSelected
              ? originalColor.withOpacity(1)
              : originalColor.withOpacity(0.5);
      final newE = e.copyWith(
        onTapParam: () => selection.value = e,
        colorParam: newColor,
        consumeTapEventsParam: true,
        zIndexParam: isSelected ? 1 : 0,
      );
      result.add(newE);
    }
    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMoving = useState<bool>(false);
    final mapCtlCompleter = useRef(Completer<GoogleMapController>()).value;
    final selectedPolylineState = useState<Polyline?>(null);
    final googleMap = GestureDetector(
      onDoubleTap: () async {
        final mapCtl = await mapCtlCompleter.future;
        mapCtl.animateCamera(
          CameraUpdate.zoomIn(),
        );
      },
      child: GoogleMap(
        onCameraMove: onCameraMove,
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (mapCtl) {
          mapCtlCompleter.complete(mapCtl);
          if (onMapCreated == null) return;
          onMapCreated!(mapCtl);
        },
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        padding: padding ?? EdgeInsets.zero,
        markers: markers ?? {},
        polylines: getTappablePolylines(polylines, selectedPolylineState),
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
