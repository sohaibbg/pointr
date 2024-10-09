import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../config/my_theme.dart';
import '../../../domain/use_cases/location_use_case.dart';
import '../blinking_loader.dart';
import '../dialogs.dart';
import '../space.dart';

class GmapButtons extends HookConsumerWidget {
  const GmapButtons(
    this.mapCtlCompleter, {
    super.key,
    this.arePedBridgesVisible,
  });

  final Completer<GoogleMapController> mapCtlCompleter;
  final ValueNotifier<bool>? arePedBridgesVisible;

  static final showPedestrianBridgeButtonGlobalKey = GlobalKey(
    debugLabel: 'usePedestrianBridgeButtonGlobalKey',
  );

  static final findMyLocationButtonGlobalKey = GlobalKey(
    debugLabel: 'findMyLocationButtonGlobalKey',
  );

  static final zoomInAndOutButtonGlobalKey = GlobalKey(
    debugLabel: 'zoomInAndOutButtonGlobalKey',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pedBridgeBtn = arePedBridgesVisible == null
        ? null
        : ElevatedButton(
            key: showPedestrianBridgeButtonGlobalKey,
            onPressed: () =>
                arePedBridgesVisible!.value = !arePedBridgesVisible!.value,
            style: MyTheme.secondaryButtonStyle,
            child: Stack(
              children: [
                Icon(
                  Icons.directions_walk,
                  size: 28,
                  color: arePedBridgesVisible!.value
                      ? MyTheme.primaryColor.withOpacity(0.55)
                      : null,
                ),
                if (arePedBridgesVisible!.value == true)
                  Icon(
                    Icons.close,
                    size: 28,
                    color: arePedBridgesVisible!.value ? Colors.red : null,
                  ),
              ],
            ),
          );
    final zoomOutBtn = ElevatedButton(
      key: zoomInAndOutButtonGlobalKey,
      onPressed: () async {
        final ctl = await mapCtlCompleter.future;
        ctl.animateCamera(
          CameraUpdate.zoomOut(),
        );
      },
      style: MyTheme.secondaryButtonStyle,
      child: const Icon(
        Icons.zoom_out,
        size: 28,
      ),
    );
    final locateMeBtn = ElevatedButton(
      key: findMyLocationButtonGlobalKey,
      onPressed: () async {
        final locPermission = await ref.read(locPermissionProvider.future);
        final mustChangeInSettings =
            locPermission == LocationPermission.deniedForever;
        if (mustChangeInSettings) {
          return context.simpleDialog(
            title: 'Permission disabled',
            content:
                'To use this feature, you need to enable it in System Settings.',
            alternativeAction: ElevatedButton(
              onPressed: ref
                  .read(
                    locPermissionProvider.notifier,
                  )
                  .openSettings,
              child: const Text("Open Settings"),
            ),
          );
        }
        final canChangeByPrompt = locPermission == LocationPermission.denied;
        if (canChangeByPrompt) {
          final repeated = await ref
              .read(
                locPermissionProvider.notifier,
              )
              .askAgain();
          if (![
            LocationPermission.whileInUse,
            LocationPermission.always,
          ].contains(repeated)) return;
        }
        final currentLoc = await ref.read(currentLocProvider.future);
        final ctl = await mapCtlCompleter.future;
        await ctl.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(
              currentLoc.latitude,
              currentLoc.longitude,
            ),
          ),
        );
      },
      style: MyTheme.secondaryButtonStyle,
      child: SizedBox.square(
        dimension: 28,
        child: ref
            .watch(
              locPermissionProvider,
            )
            .when(
              data: (permission) => switch (permission) {
                LocationPermission.denied ||
                LocationPermission.deniedForever ||
                LocationPermission.unableToDetermine =>
                  Icon(
                    Icons.location_disabled,
                    color: permission == LocationPermission.deniedForever
                        ? Colors.red
                        : null,
                  ),
                LocationPermission.whileInUse ||
                LocationPermission.always =>
                  ref
                      .watch(
                        currentLocProvider,
                      )
                      .when(
                        data: (data) => const Icon(
                          Icons.my_location,
                        ),
                        error: (error, stackTrace) => const Icon(
                          Icons.location_disabled,
                          color: Colors.red,
                        ),
                        loading: () => const BlinkingLoader(
                          child: Icon(
                            Icons.location_searching,
                          ),
                        ),
                      ),
              },
              error: (error, stackTrace) => const Icon(
                Icons.location_disabled,
              ),
              loading: () => const BlinkingLoader(
                child: Icon(Icons.location_searching),
              ),
            ),
      ),
    );
    return Column(
      children: [
        if (pedBridgeBtn != null) ...[
          pedBridgeBtn,
          12.verticalSpace,
        ],
        locateMeBtn,
        12.verticalSpace,
        zoomOutBtn,
      ],
    );
  }
}
