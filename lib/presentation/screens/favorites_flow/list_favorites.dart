import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/favorite_entity.dart';
import '../../../domain/use_cases/favorites_use_case.dart';
import '../../components/dialogs.dart';

class ListFavorites extends ConsumerWidget {
  const ListFavorites({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget favDataView(List<FavoriteEntity> data) => ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final fav = data[index];
            return ListTile(
              title: Text(fav.name),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 18,
              ),
              onTap: () => context.go(
                '/favorites/${fav.name}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final didConsent = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Are you sure?"),
                      content: Text(
                        "This will remove ${fav.name} from your favorites.",
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
                    () => ref
                        .read(
                          favoritesUseCaseProvider.notifier,
                        )
                        .delete(
                          fav.name,
                        ),
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
    final favHandler = ref.watch(favoritesUseCaseProvider).when(
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
