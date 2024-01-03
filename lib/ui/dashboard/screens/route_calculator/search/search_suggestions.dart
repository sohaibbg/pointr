import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../models/coordinates.dart';
import '../../../../../models/google_place.dart';
import '../../../../../models/located_google_place.dart';
import '../../../../../models/located_place.dart';
import '../../../../../repo/favorites.dart';
import '../../../../../repo/nearby_places.dart';
import '../../../../components/dialogs.dart';
import '../display/map_display.dart';
import '../route_calculator_view_model.dart';
import 'search_bar.dart';

class SearchSuggestions extends ConsumerStatefulWidget {
  const SearchSuggestions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchSuggestionsState();
}

class _SearchSuggestionsState extends ConsumerState<SearchSuggestions> {
  Future<void> onSelected(Coordinates coordinates) async {
    final gmapCtl = await ref.read(gmapCtlProvider).future;
    return gmapCtl.animateCamera(
      CameraUpdate.newLatLng(coordinates.latLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeStopIndex = ref.watch(activeStopIndexProvider);
    final focusNode = ref.read(
      SearchBarFocusNodeProvider(activeStopIndex),
    );
    if (!focusNode.hasFocus) return const SizedBox();
    final searchTextController = ref.read(
      searchBarTextEditingControllerProvider(activeStopIndex),
    );
    searchTextController.addListener(() => setState(() {}));
    final searchEscapeRegion = GestureDetector(
      onTap: focusNode.previousFocus,
      onDoubleTap: focusNode.previousFocus,
      onSecondaryTap: focusNode.previousFocus,
      onSecondaryLongPress: focusNode.previousFocus,
      onPanStart: (_) => focusNode.previousFocus(),
      onVerticalDragStart: (_) => focusNode.previousFocus(),
      onHorizontalDragStart: (_) => focusNode.previousFocus(),
      onScaleStart: (_) => focusNode.previousFocus(),
      onSecondaryLongPressStart: (_) => focusNode.previousFocus(),
      onLongPressStart: (_) => focusNode.previousFocus(),
      onForcePressStart: (_) => focusNode.previousFocus(),
      onTertiaryLongPressStart: (_) => focusNode.previousFocus(),
    );
    if (searchTextController.text.isEmpty) return searchEscapeRegion;
    Widget suggestionsView(List<GooglePlace> places) => places.isEmpty
        ? searchEscapeRegion
        : ListView.separated(
            reverse: true,
            itemBuilder: (context, index) {
              final place = places[index];
              return ListTile(
                dense: true,
                contentPadding: const EdgeInsets.only(left: 10, right: 13),
                leading: const Icon(Icons.location_on),
                title: Text(
                  place.title,
                  overflow: TextOverflow.fade,
                ),
                subtitle: place is LocatedGooglePlace
                    ? Text(
                        place.subtitle,
                        overflow: TextOverflow.fade,
                      )
                    : null,
                onTap: () async {
                  final latLng = await context.loaderWithErrorDialog(
                    place.getCoordinate,
                  );
                  onSelected(latLng);
                },
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: places.length,
          );
    Widget favView(List<LocatedPlace> favs) => favs.isEmpty
        ? const SizedBox()
        : ListView.separated(
            itemCount: favs.length,
            scrollDirection: Axis.horizontal,
            cacheExtent: 400,
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              final fav = favs[index];
              return ActionChip(
                label: Text(
                  fav.title,
                  overflow: TextOverflow.fade,
                ),
                avatar: const Icon(Icons.star),
                onPressed: () => onSelected(fav.coordinates),
              );
            },
          );

    final googlePlacesSuggestions = ref
        .watch(
          NearbyPlacesBySearchTermProvider(
            searchTextController.text,
          ),
        )
        .when(
          data: suggestionsView,
          error: (error, stackTrace) => Text('error\n$error'),
          loading: () => const LinearProgressIndicator(),
        );
    final favsSuggestions = ref.watch(favoritesProvider).when(
          data: (favs) {
            final filteredFavs = favs
                .where(
                  (fav) => fav.title.contains(
                    searchTextController.text,
                  ),
                )
                .toList();
            return favView(filteredFavs);
          },
          error: (error, stackTrace) => const Text('error loading favorites'),
          loading: () => const LinearProgressIndicator(),
        );
    return Column(
      children: [
        Expanded(child: searchEscapeRegion),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Expanded(child: googlePlacesSuggestions),
              favsSuggestions,
            ],
          ),
        ),
      ],
    );
  }
}
