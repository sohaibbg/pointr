import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config/my_theme.dart';
import '../../domain/use_cases/location_use_case.dart';
import 'dialogs.dart';
import 'space.dart';

class GmapButtons extends ConsumerWidget {
  const GmapButtons(
    this.mapCtlCompleter, {
    super.key,
  });

  final Completer<GoogleMapController> mapCtlCompleter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zoomOutBtn = ElevatedButton(
      onPressed: () => mapCtlCompleter.future.then(
        (e) => e.animateCamera(
          CameraUpdate.zoomOut(),
        ),
      ),
      style: MyTheme.secondaryButtonStyle,
      child: const Icon(
        Icons.zoom_out,
        size: 28,
      ),
    );
    final locateMeBtn = ElevatedButton(
      onPressed: () async {
        final locPermission = await ref.read(locPermissionProvider.future);
        final mustChangeInSettings =
            locPermission == LocationPermission.deniedForever;
        if (mustChangeInSettings) {
          return context.errorDialog(
            title: 'Permission disabled',
            content:
                'To use this feature, you need to enable it in System Settings.',
            alternativeAction: ElevatedButton(
              onPressed: ref
                  .read(
                    locPermissionProvider.notifier,
                  )
                  .openSettings,
              // style: MyTheme.primaryButtonStyle,
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
        ctl.animateCamera(
          CameraUpdate.newLatLng(
            LatLng.fromJson(currentLoc.toJson())!,
          ),
        );
      },
      style: MyTheme.secondaryButtonStyle,
      child: SizedBox.square(
        dimension: 28,
        child: ref.watch(currentLocProvider).when(
              data: (data) => const Icon(
                Icons.my_location,
              ),
              error: (error, stackTrace) {
                context.errorDialog(
                  title: 'Could not locate user',
                  content: 'Try moving closer to the open sky',
                );
                return const Icon(
                  Icons.my_location,
                );
              },
              loading: () =>
                  const FittedBox(child: CircularProgressIndicator()),
            ),
      ),
    );
    return Column(
      children: [
        locateMeBtn,
        12.verticalSpace,
        zoomOutBtn,
      ],
    );
  }
}
