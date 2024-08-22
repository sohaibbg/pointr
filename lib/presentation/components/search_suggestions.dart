import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config/injector.dart';
import '../../domain/entities/autocomplete_suggestion_entity.dart';
import '../../domain/entities/coordinates_entity.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/repositories/i_places_repo.dart';
import '../../domain/use_cases/favorites_use_case.dart';
import '../../domain/use_cases/places_use_case.dart';

class SearchSuggestions extends ConsumerWidget {
  final String searchTerm;
  final void Function(FavoriteEntity locatedPlace) onSelected;

  const SearchSuggestions({
    super.key,
    required this.searchTerm,
    required this.onSelected,
  });

  Widget suggestionsView(List<AutocompleteSuggestionEntity> places) {
    if (places.isEmpty && searchTerm.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.manage_search,
              size: 124,
              color: Colors.black54,
            ),
            Text(
              "Type something for search results to be loaded.",
              style: TextStyle(
                fontSize: 22,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );
    }
    if (places.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.question_mark,
              size: 124,
            ),
            Expanded(
              child: Text(
                "No results found for '$searchTerm'.",
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      reverse: true,
      itemCount: places.length,
      cacheExtent: places.isEmpty ? 0 : 120,
      separatorBuilder: (context, index) => const Divider(),
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemBuilder: (context, index) {
        final place = places[index];
        AsyncValue<CoordinatesEntity>? located;
        return StatefulBuilder(
          builder: (context, setState) => ListTile(
            dense: true,
            tileColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 10, right: 13),
            title: Text(
              place.name,
              overflow: TextOverflow.fade,
            ),
            leading: located == null
                ? const Icon(
                    Icons.location_on,
                  )
                : located!.when(
                    data: (_) => const Icon(Icons.done),
                    error: (error, stackTrace) => const Icon(Icons.error),
                    loading: () => const CircularProgressIndicator(),
                  ),
            onTap: () async {
              setState(
                () => located = const AsyncLoading(),
              );
              late final CoordinatesEntity coordinates;
              try {
                coordinates = await getIt.call<IPlacesRepo>().getCoordinatesFor(
                      place.id,
                    );
              } catch (e) {
                if (!context.mounted) return;
                setState(
                  () => located = AsyncValue.error(
                    e.toString(),
                    StackTrace.empty,
                  ),
                );
                return;
              }
              if (!context.mounted) return;
              setState(() => located = AsyncData(coordinates));
              final locatedPlace = FavoriteEntity(
                name: place.name,
                coordinates: coordinates,
              );
              onSelected(locatedPlace);
            },
          ),
        );
      },
    );
  }

  Widget favView(List<FavoriteEntity> favs) => AnimatedSize(
        duration: kThemeAnimationDuration,
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: favs.isEmpty ? 0 : 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: favs.length,
            cacheExtent: 400,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              final fav = favs[index];
              return ActionChip(
                label: Text(
                  fav.name,
                  overflow: TextOverflow.fade,
                ),
                avatar: const Icon(Icons.star),
                onPressed: () => onSelected(fav),
              );
            },
          ),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googlePlaces = ref.watch(
      NearbyPlacesBySearchTermProvider(searchTerm),
    );
    final googlePlacesSuggestions = googlePlaces.when(
      data: suggestionsView,
      error: (error, stackTrace) => const Center(
        child: Text("An error occurred."),
      ),
      loading: () => const Padding(
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
    );
    final favorites = ref.watch(favoritesUseCaseProvider);
    final reducedSearchTerm = searchTerm.replaceAll(' ', '').toLowerCase();
    final favsSuggestions = favorites.when(
      data: (favs) => favView(
        favs.where(
          (e) {
            final reducedTitle = e.name.replaceAll(' ', '').toLowerCase();
            return reducedTitle.contains(reducedSearchTerm);
          },
        ).toList(),
      ),
      error: (error, stackTrace) => const Text('error loading favorites'),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 24,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            LinearProgressIndicator(
              color: Colors.pink,
            ),
            ColoredBox(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.favorite,
                  color: Colors.pink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: ColoredBox(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(child: googlePlacesSuggestions),
            favsSuggestions,
          ],
        ),
      ),
    );
  }
}
