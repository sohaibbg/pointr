import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'space.dart';

class MapWithPinAndBanner extends HookConsumerWidget {
  final CameraPosition initialCameraPosition;
  final MapCreatedCallback? onMapCreated;
  final Set<Polyline>? polylines;
  final Set<Marker>? markers;
  final EdgeInsets? padding;
  final bool hidePin;

  const MapWithPinAndBanner({
    super.key,
    required this.initialCameraPosition,
    this.padding,
    this.hidePin = false,
    this.onMapCreated,
    this.markers,
    this.polylines,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMoving = useState<bool>(false);
    final googleMap = GoogleMap(
      initialCameraPosition: initialCameraPosition,
      onMapCreated: onMapCreated,
      padding: padding ?? EdgeInsets.zero,
      markers: markers ?? {},
      polylines: polylines ?? {},
      onCameraMoveStarted: () => isMoving.value = true,
      onCameraIdle: () => isMoving.value = false,
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
  });

  final bool isStationary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const blackDot = SizedBox.square(
      dimension: 8,
      child: CircleAvatar(
        backgroundColor: Colors.black,
      ),
    );
    final stationaryMarker = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.not_listed_location_sharp,
          color: Theme.of(context).primaryColor,
          shadows: const [Shadow()],
          size: 48,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: const SizedBox.square(
            dimension: 3,
          ),
        ),
        4.verticalSpace,
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: const SizedBox.square(
            dimension: 5,
          ),
        ),
        4.verticalSpace,
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
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
          scale: isStationary ? 1 : 0,
          alignment: Alignment.bottomCenter,
          duration: kThemeAnimationDuration,
          child: stationaryMarker,
        ),
      ],
    );
  }
}
