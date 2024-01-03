import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/coordinates.dart';
import '../../../../models/google_place.dart';
import '../../../../models/located_google_place.dart';
import '../../../../repo/location.dart';
import '../../../../repo/nearby_places.dart';
import '../../../components/dialogs.dart';

class Suggestions extends ConsumerWidget {
  const Suggestions({super.key});

  // read this class bottom-up
  Widget suggestionsView(List<GooglePlace> places) => ListView.separated(
        itemBuilder: (context, index) {
          final place = places[index];
          return ListTile(
            dense: true,
            contentPadding: const EdgeInsets.only(left: 10, right: 13),
            leading: const Icon(Icons.location_on),
            title: Text(place.title),
            subtitle: place is LocatedGooglePlace ? Text(place.subtitle) : null,
            onTap: () async {
              final coordinates = await context.loaderWithErrorDialog(
                place.getCoordinate,
              );
              context.go(
                '/onboard/${coordinates.toJson()}',
              );
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: places.length,
      );
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget nearbyPlacesView(Coordinates coordinates) => ref
        .watch(
          NearbyPlacesFromCoordinatesProvider(coordinates),
        )
        .when(
          data: suggestionsView,
          error: (error, stackTrace) => Text('error\n$error'),
          loading: () => const LinearProgressIndicator(),
        );
    Widget currentLocView() => ref
        .watch(
          currentLocProvider,
        )
        .when(
          data: nearbyPlacesView,
          error: (error, stackTrace) => Text('error\n$error'),
          loading: () => const LinearProgressIndicator(),
        );

    final locPermissionView = ref
        .watch(
          locPermissionProvider,
        )
        .when(
          data: (
            LocationPermission permission,
          ) {
            if (LocationPermission.unableToDetermine == permission) {
              return const Text('Use another browser');
            }
            if (permission == LocationPermission.denied) {
              return const Text("ask again");
            }
            if (permission == LocationPermission.deniedForever) {
              return const Text(
                'Denied strictly. Fixed only through settings now.',
              );
            }
            return currentLocView();
          },
          error: (error, stackTrace) => const Text('retrying'),
          loading: () => const LinearProgressIndicator(),
        );
    return locPermissionView;
  }
}
