part of 'go_screen.dart';

class FavoritesView extends ConsumerWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        height: 96,
        padding: const EdgeInsets.only(bottom: 16),
        alignment: Alignment.center,
        child: ref.watch(favoritesUseCaseProvider).when(
              loading: onLoading,
              data: (value) => _FavoritesDataView(value),
              error: (error, stackTrace) => onError(context, ref),
            ),
      );

  Widget onError(BuildContext context, WidgetRef ref) {
    Future.delayed(
      const Duration(seconds: 5),
      () {
        if (!context.mounted) return;
        ref.invalidate(favoritesUseCaseProvider);
      },
    );
    final textBody = Column(
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
            child: textBody,
          ),
        ],
      ),
    );
  }

  Widget onLoading() => const Padding(
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

class _FavoritesDataView extends ConsumerWidget {
  const _FavoritesDataView(this.favs);

  final List<FavoriteEntity> favs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttons = <Widget>[];
    final favBtns = favs.map(
      (fav) => OutlinedButton.icon(
        onPressed: () => context.go(
          '/route/advisor',
          extra: {'initialPlace': fav},
        ),
        style: MyTheme.primaryOutlinedButtonStyle.copyWith(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        icon: const Icon(Icons.star),
        label: Text(
          fav.name,
          textAlign: TextAlign.start,
        ),
      ),
    );
    buttons.addAll(favBtns);
    if (favs.isNotEmpty) {
      final editFavsBtn = OutlinedButton.icon(
        onPressed: () => context.go('/favorite'),
        icon: const Icon(Icons.edit),
        label: const Text(
          "Edit favorites",
        ),
        style: MyTheme.secondaryOutlinedButtonStyle,
      );
      buttons.add(editFavsBtn);
    }
    final addNewFavBtn = favs.isEmpty
        ? ElevatedButton.icon(
            style: MyTheme.secondaryOutlinedButtonStyle,
            onPressed: () => context.go('/favorite/create'),
            icon: const Icon(Icons.favorite),
            label: const Text(
              "Save a Favorite Place",
            ),
          )
        : IconButton.filledTonal(
            onPressed: () => context.go('/favorite/create'),
            style: MyTheme.secondaryOutlinedButtonStyle,
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
