part of 'home.dart';

class _FavoritesHandler extends ConsumerWidget {
  const _FavoritesHandler();

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        height: 96,
        padding: const EdgeInsets.only(bottom: 16),
        alignment: Alignment.center,
        child: ref.watch(favoritesProvider).when(
              loading: loading,
              data: (value) => _FavoritesData(value),
              error: (error, stackTrace) {
                Future.delayed(
                  const Duration(seconds: 5),
                  () {
                    if (!context.mounted) return;
                    ref.invalidate(favoritesProvider);
                  },
                );
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.heart_broken),
                      24.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Could not load favorites.',
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
                );
              },
            ),
      );

  Widget loading() => const Padding(
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
      );
}

class _FavoritesData extends ConsumerWidget {
  const _FavoritesData(this.favs);

  final List<LocatedPlace> favs;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final buttons = <Widget>[];
    final favBtns = favs.map(
      (fav) => OutlinedButton.icon(
        onPressed: () => context.go(
          '/route-calculator',
          extra: {'initialPlace': fav},
        ),
        icon: const Icon(Icons.star),
        label: Text(
          fav.title,
          textAlign: TextAlign.start,
        ),
      ),
    );
    buttons.addAll(favBtns);
    if (favs.isNotEmpty) {
      final editFavsBtn = ElevatedButton.icon(
        onPressed: () => context.go('/favorites'),
        icon: const Icon(Icons.edit),
        label: const Text(
          "Edit favorites",
        ),
      );
      buttons.add(editFavsBtn);
    }
    final addNewFavBtn = favs.isEmpty
        ? ElevatedButton.icon(
            onPressed: () => context.go('/new-favorite'),
            icon: Icon(Icons.favorite),
            label: Text(
              "Save a Favorite Place",
            ),
          )
        : IconButton.filledTonal(
            onPressed: () => context.go('/new-favorite'),
            icon: Icon(favs.isEmpty ? Icons.favorite : Icons.add),
          );
    buttons.add(addNewFavBtn);

    return ListView.separated(
      separatorBuilder: (context, index) => 18.horizontalSpace,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      scrollDirection: Axis.horizontal,
      itemCount: buttons.length,
      itemBuilder: (context, index) => buttons[index],
    );
  }
}
