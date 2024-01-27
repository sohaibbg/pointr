part of 'home.dart';

class _NearbySuggestions extends ConsumerWidget {
  const _NearbySuggestions();

  // read this class bottom-up
  Widget suggestionsView(List<GooglePlace> places) =>
      SliverFixedExtentList.builder(
        itemCount: places.length,
        itemExtent: 80,
        itemBuilder: (context, index) {
          final place = places[index];
          return Column(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final coordinates =
                        await context.loaderWithErrorDialog<Coordinates>(
                      place.getCoordinate,
                    );
                    context.go(
                      '/route-calculator',
                      extra: {
                        'initialPlace': LocatedPlace(
                          title: place.title,
                          coordinates: coordinates,
                        ),
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 36, right: 48),
                    child: Row(
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
                                  place.title,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              if (place is LocatedGooglePlace)
                                Text(
                                  place.subtitle,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
    Widget nearbyPlacesView(Coordinates coordinates) => ref
        .watch(
          NearbyPlacesFromCoordinatesProvider(coordinates),
        )
        .when(
          data: suggestionsView,
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
                    Column(
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
        );
    Widget currentLocView() => ref
        .watch(
          currentLocProvider,
        )
        .when(
          data: nearbyPlacesView,
          error: (_, __) {
            Future.delayed(
              const Duration(seconds: 5),
              () {
                if (!context.mounted) return;
                ref.invalidate(currentLocProvider);
              },
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
                      child: Column(
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
                      ),
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
        );

    final locPermissionView = ref
        .watch(
          locPermissionProvider,
        )
        .when(
          data: (
            permission,
          ) {
            if (LocationPermission.unableToDetermine == permission) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  child: Text(
                    "Suggestions of nearby places would have shown up here, but your browser does not support this feature.",
                  ),
                ),
              );
            }
            if (permission == LocationPermission.deniedForever ||
                permission == LocationPermission.deniedForever) {
              return SliverToBoxAdapter(
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
                              onPressed: () =>
                                  ref.refresh(locPermissionProvider),
                              label: const Text("Refresh"),
                              icon: const Icon(Icons.refresh),
                            ),
                            18.horizontalSpace,
                            ElevatedButton.icon(
                              onPressed: () async {
                                if (permission ==
                                    LocationPermission.deniedForever) {
                                  await Geolocator.openAppSettings();
                                } else {
                                  assert(
                                    permission == LocationPermission.denied,
                                  );
                                  await Geolocator.requestPermission();
                                }
                                ref.invalidate(locPermissionProvider);
                              },
                              label: const Text("Request access again"),
                              icon: const Icon(Icons.location_on_rounded),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return currentLocView();
          },
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
        );
    return locPermissionView;
  }
}
