part of 'go_screen.dart';

class NearbySuggestionsView extends ConsumerWidget {
  const NearbySuggestionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      const _LocPermissionHandledView();
}

class _LocPermissionHandledView extends ConsumerWidget {
  const _LocPermissionHandledView();

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
                      "With your permission, we can list nearby places here.",
                      textAlign: TextAlign.center,
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
            const _CurrentLocHandledView(),
        },
      );
}

class _CurrentLocHandledView extends ConsumerWidget {
  const _CurrentLocHandledView();

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
                  color: Colors.green,
                ),
                ColoredBox(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.my_location,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (currentLocation) => _PlacesSearchHandledView(
          currentLocation,
        ),
      );
}

class _PlacesSearchHandledView extends ConsumerWidget {
  const _PlacesSearchHandledView(this.coordinates);

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
        loading: () => Skeletonizer.sliver(
          child: _SuggestionsView(
            List.filled(
              7,
              NamedAddressEntity(
                coordinates: karachiLatLng,
                address: BoneMock.address,
                name: BoneMock.name,
              ),
            ),
          ),
        ),
        data: (searchSuggestions) => _SuggestionsView(searchSuggestions),
      );
}

class _SuggestionsView extends StatelessWidget {
  const _SuggestionsView(this.places);

  final List<NamedAddressEntity> places;

  @override
  Widget build(BuildContext context) => SliverFixedExtentList.builder(
        itemCount: places.length,
        itemExtent: 80,
        itemBuilder: (context, index) {
          final place = places[index];
          final widgetStatesController = WidgetStatesController();
          return ValueListenableBuilder(
            valueListenable: widgetStatesController,
            builder: (context, value, child) {
              final name = Text(
                place.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(
                      color: value.contains(
                        WidgetState.pressed,
                      )
                          ? Colors.white
                          : MyTheme.primaryColor.shade800,
                    ),
              );
              final detail = Text(
                place.address.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: value.contains(
                    WidgetState.pressed,
                  )
                      ? Colors.white
                      : Colors.grey,
                  fontSize: 11,
                ),
              );
              final body = Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: value.contains(
                      WidgetState.pressed,
                    )
                        ? Colors.white
                        : MyTheme.primaryColor,
                  ),
                  24.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: name,
                        ),
                        detail,
                      ],
                    ),
                  ),
                ],
              );
              return Column(
                children: [
                  Expanded(
                    child: InkWell(
                      statesController: widgetStatesController,
                      overlayColor: widgetStatePropertyHelper(
                        defaultState: Colors.transparent,
                        hoveredState: MyTheme.primaryColor.shade50,
                        pressedState: MyTheme.primaryColor.shade100,
                      ),
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
                        child: body,
                      ),
                    ),
                  ),
                  if (index != places.length - 1) const Divider(height: 0),
                ],
              );
            },
          );
        },
      );
}
