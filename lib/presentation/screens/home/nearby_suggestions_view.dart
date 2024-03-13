import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/address_entity.dart';
import '../../../domain/entities/coordinates_entity.dart';
import '../../../domain/entities/named_address_entity.dart';
import '../../../domain/use_cases/location_use_case.dart';
import '../../../domain/use_cases/nearby_places.dart';
import '../../components/space.dart';

class NearbySuggestionsView extends ConsumerWidget {
  const NearbySuggestionsView({super.key});

  // read this class bottom-up
  Widget suggestionsView(List<NamedAddressEntity> places) =>
      SliverFixedExtentList.builder(
        itemCount: places.length,
        itemExtent: 80,
        itemBuilder: (context, index) {
          final place = places[index];
          final btnBody = Row(
            children: [
              const Icon(Icons.location_on),
              24.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        place.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      place.address,
                    ),
                  ],
                ),
              ),
            ],
          );
          return Column(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => context.go(
                    '/route-calculator',
                    extra: {
                      'initialPlace': AddressEntity(
                        address: place.name,
                        coordinates: place.coordinates,
                      ),
                    },
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 36, right: 48),
                    child: btnBody,
                  ),
                ),
              ),
              if (index != places.length - 1) const Divider(height: 0),
            ],
          );
        },
      );
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locPermission = ref
        .watch(
          locPermissionProvider,
        )
        .asData
        ?.value;
    if (!{
      LocationPermission.always,
      LocationPermission.whileInUse,
    }.contains(locPermission)) {
      return const _LocPermissionHandlerViewForNearbySuggestions();
    }
    final currentLocation = ref
        .watch(
          currentLocProvider,
        )
        .asData
        ?.value;
    if (currentLocation == null) {
      return const _CurrentLocHandlerViewForNearbySuggestions();
    }
    final searchSuggestions = ref
        .watch(
          NearbyPlacesFromCoordinatesProvider(currentLocation),
        )
        .asData
        ?.value;
    if (searchSuggestions == null) {
      return _ResultsHandlerViewForNearbySuggestions(currentLocation);
    }
    return suggestionsView(searchSuggestions);
  }
}

class _LocPermissionHandlerViewForNearbySuggestions extends ConsumerWidget {
  const _LocPermissionHandlerViewForNearbySuggestions();

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(
        locPermissionProvider,
      )
      .when(
        error: (error, stackTrace) => const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 24,
            ),
            child: Text(
              "Suggestions of places nearby will show up here once you grant permission access.",
            ),
          ),
        ),
        loading: () => const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 24,
            ),
            child: Text(
              "Suggestions of places nearby will show up here once you grant permission access.",
            ),
          ),
        ),
        data: (permission) => switch (permission) {
          LocationPermission.unableToDetermine => const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                child: Text(
                  "Suggestions of nearby places would have shown up here, but your device or browser does not support this feature.",
                ),
              ),
            ),
          LocationPermission.deniedForever => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                child: Column(
                  children: [
                    const Text(
                      "Suggestions of nearby places would have shown up here, but you denied location access.",
                    ),
                    24.verticalSpace,
                    SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => ref.refresh(
                              locPermissionProvider,
                            ),
                            label: const Text("Recheck"),
                            icon: const Icon(Icons.refresh),
                          ),
                          18.horizontalSpace,
                          ElevatedButton.icon(
                            onPressed: () async {
                              await Geolocator.openAppSettings();
                              ref.invalidate(locPermissionProvider);
                            },
                            label: const Text("Open permission settings"),
                            icon: const Icon(Icons.settings),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          LocationPermission.denied => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                child: Column(
                  children: [
                    const Text(
                      "If you grant location permissions, suggestions of nearby places will be displayed here.",
                    ),
                    24.verticalSpace,
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await Geolocator.requestPermission();
                          ref.invalidate(locPermissionProvider);
                        },
                        label: const Text("Request permission"),
                        icon: const Icon(Icons.location_on_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          LocationPermission.whileInUse ||
          LocationPermission.always =>
            const Placeholder(),
        },
      );
}

class _CurrentLocHandlerViewForNearbySuggestions extends ConsumerWidget {
  const _CurrentLocHandlerViewForNearbySuggestions();

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(
        currentLocProvider,
      )
      .when(
        error: (_, __) {
          Future.delayed(
            const Duration(seconds: 5),
            () {
              if (!context.mounted) return;
              ref.invalidate(currentLocProvider);
            },
          );
          final textBody = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Could not load suggestions.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.red),
              ),
              Text(
                "retrying in 5 seconds".toUpperCase(),
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 36,
                vertical: 12,
              ),
              child: Row(
                children: [
                  const Icon(Icons.error),
                  24.horizontalSpace,
                  Expanded(
                    child: textBody,
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 24,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                LinearProgressIndicator(
                  color: Colors.blue,
                ),
                ColoredBox(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.near_me,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (_) => const Placeholder(),
      );
}

class _ResultsHandlerViewForNearbySuggestions extends ConsumerWidget {
  const _ResultsHandlerViewForNearbySuggestions(this.coordinates);

  final CoordinatesEntity coordinates;
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(
        NearbyPlacesFromCoordinatesProvider(coordinates),
      )
      .when(
        error: (error, stackTrace) {
          Future.delayed(
            const Duration(seconds: 5),
            () {
              if (!context.mounted) return;
              ref.invalidate(
                NearbyPlacesFromCoordinatesProvider(coordinates),
              );
            },
          );
          final textBody = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Could not load suggestions.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.red),
              ),
              Text(
                "retrying in 5 seconds".toUpperCase(),
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 36,
                vertical: 12,
              ),
              child: Row(
                children: [
                  const Icon(Icons.near_me),
                  24.horizontalSpace,
                  textBody,
                ],
              ),
            ),
          );
        },
        loading: () => const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 24,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                LinearProgressIndicator(
                  color: Colors.blue,
                ),
                ColoredBox(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.near_me,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (_) => const Placeholder(),
      );
}
