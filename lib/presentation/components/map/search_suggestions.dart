import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../config/injector.dart';
import '../../../config/my_theme.dart';
import '../../../domain/entities/coordinates_entity.dart';
import '../../../domain/entities/searchable_place.dart';
import '../../../domain/repositories/i_places_repo.dart';
import '../../../domain/use_cases/recents_use_case.dart';
import '../../../domain/use_cases/suggestions_use_case.dart';

class SearchSuggestions extends ConsumerWidget {
  final String searchTerm;
  final void Function(AddressEntity locatedPlace) onSelected;

  const SearchSuggestions({
    super.key,
    required this.searchTerm,
    required this.onSelected,
  });

  Widget suggestionsView(
    List<SearchablePlace> places,
  ) {
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
                searchTerm.isNotEmpty
                    ? "No results found for '$searchTerm'."
                    : "Start typing",
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
        return _SuggestionTile(
          place,
          onSelected: onSelected,
        );
      },
    );
  }

  // Widget favView(List<FavoriteEntity> favs) => AnimatedSize(
  //       duration: kThemeAnimationDuration,
  //       alignment: Alignment.bottomCenter,
  //       child: SizedBox(
  //         height: favs.isEmpty ? 0 : 64,
  //         child: ListView.separated(
  //           scrollDirection: Axis.horizontal,
  //           itemCount: favs.length,
  //           cacheExtent: 400,
  //           padding: const EdgeInsets.symmetric(horizontal: 24),
  //           separatorBuilder: (context, index) => const SizedBox(width: 20),
  //           itemBuilder: (context, index) {
  //             final fav = favs[index];
  //             return ActionChip(
  //               label: Text(
  //                 fav.name,
  //                 overflow: TextOverflow.fade,
  //               ),
  //               avatar: const Icon(Icons.star),
  //               onPressed: () => onSelected(fav),
  //             );
  //           },
  //         ),
  //       ),
  //     );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestionsWatch = ref.watch(
      SearchSuggestionsProvider(searchTerm),
    );
    final body = suggestionsWatch.when(
      skipError: true,
      skipLoadingOnRefresh: false,
      skipLoadingOnReload: false,
      data: suggestionsView,
      error: (error, stackTrace) => const Center(
        child: Text("An error occurred."),
      ),
      loading: () => Skeletonizer(
        child: suggestionsView(
          List.generate(
            5,
            (index) => AutocompleteSuggestionEntity(
              id: '',
              name: BoneMock.name,
              address: BoneMock.address,
            ),
          ),
        ),
      ),
    );
    // final favorites = ref.watch(favoritesUseCaseProvider);
    // final reducedSearchTerm = searchTerm.replaceAll(' ', '').toLowerCase();
    // final favsSuggestions = favorites.when(
    //   data: (favs) => favView(
    //     favs.where(
    //       (e) {
    //         final reducedTitle = e.name.replaceAll(' ', '').toLowerCase();
    //         return reducedTitle.contains(reducedSearchTerm);
    //       },
    //     ).toList(),
    //   ),
    //   error: (error, stackTrace) => const Text('error loading favorites'),
    //   loading: () => Padding(
    //     padding: const EdgeInsets.symmetric(
    //       vertical: 12,
    //       horizontal: 24,
    //     ),
    //     child: Stack(
    //       alignment: Alignment.center,
    //       children: [
    //         const LinearProgressIndicator(
    //           color: Colors.pink,
    //         ),
    //         ColoredBox(
    //           color: bgColor,
    //           child: const Padding(
    //             padding: EdgeInsets.all(12),
    //             child: Icon(
    //               Icons.favorite,
    //               color: Colors.pink,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return ColoredBox(
      color: Color.lerp(
        MyTheme.primaryColor.shade50,
        Colors.white,
        0.7,
      )!,
      child: body,
    );
  }
}

class _SuggestionTile extends HookConsumerWidget {
  const _SuggestionTile(
    this.place, {
    required this.onSelected,
  });

  final SearchablePlace place;
  final void Function(AddressEntity locatedPlace) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (place) {
      case AddressEntity():
        return ListTile(
          dense: true,
          tileColor: MyTheme.primaryColor.shade50,
          minTileHeight: 36,
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.only(left: 24, right: 13),
          title: Text(
            place.name,
            overflow: TextOverflow.fade,
          ),
          leading: Icon(
            switch (place as AddressEntity) {
              FavoriteEntity() => Icons.favorite,
              NamedAddressEntity() => Icons.near_me,
              RecentEntity() => Icons.location_history,
              _ => Icons.location_on,
            },
          ),
          trailing: place is RecentEntity
              ? IconButton(
                  onPressed: () => ref
                      .read(
                        recentsUseCaseProvider.notifier,
                      )
                      .clearRecord(place as RecentEntity),
                  icon: const Icon(Icons.clear),
                )
              : null,
          onTap: () => onSelected(place as AddressEntity),
        );
      case AutocompleteSuggestionEntity():
        final located = useState<AsyncValue<CoordinatesEntity>?>(null);
        return ListTile(
          dense: true,
          tileColor: MyTheme.primaryColor.shade50,
          minTileHeight: 36,
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.only(left: 24, right: 13),
          title: Text(
            place.name,
            overflow: TextOverflow.fade,
          ),
          leading: located.value == null
              ? const Icon(
                  Icons.location_on,
                )
              : located.value!.when(
                  data: (_) => const Icon(Icons.done),
                  error: (error, stackTrace) => const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                  loading: () => const CircularProgressIndicator(),
                ),
          onTap: () async {
            located.value = const AsyncLoading();
            late final CoordinatesEntity coordinates;
            try {
              coordinates = await getIt.call<IPlacesRepo>().getCoordinatesFor(
                    (place as AutocompleteSuggestionEntity).id,
                  );
            } catch (e) {
              if (!context.mounted) return;
              located.value = AsyncValue.error(
                e.toString(),
                StackTrace.empty,
              );
              return;
            }
            if (!context.mounted) return;
            located.value = AsyncData(coordinates);
            final locatedPlace = FavoriteEntity(
              name: place.name,
              coordinates: coordinates,
            );
            onSelected(locatedPlace);
          },
        );
    }
  }
}
