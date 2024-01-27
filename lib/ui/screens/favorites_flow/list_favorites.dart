import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/located_place.dart';
import '../../../repo/local/favorites.dart';
import '../../components/dialogs.dart';

class ListFavorites extends ConsumerWidget {
  const ListFavorites({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget favDataView(List<LocatedPlace> data) => ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final fav = data[index];
            return ListTile(
              title: Text(fav.title),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 18,
              ),
              onTap: () => context.go(
                '/favorites/${fav.title}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final didConsent = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Are you sure?"),
                      content: Text(
                        "This will remove ${fav.title} from your favorites.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Return"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Yes, I'm sure"),
                        ),
                      ],
                    ),
                  );
                  if (didConsent is! bool) return;
                  if (!didConsent) return;
                  context.loaderWithErrorDialog(
                    () => FavoritesCRUD.delete(fav.title),
                  );
                },
                color: Colors.red,
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(
            height: 0,
          ),
        );
    final favHandler = ref.watch(favoritesProvider).when(
          data: favDataView,
          error: (error, s) => Center(
            child: Text(
              error.toString(),
            ),
          ),
          loading: () => const CircularProgressIndicator(),
        );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Favorites"),
      ),
      body: favHandler,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add new"),
        icon: const Icon(Icons.add),
        onPressed: () => context.go('/new-favorite'),
      ),
    );
  }
}
