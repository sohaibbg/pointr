import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/searchable_place.dart';
import '../../../domain/use_cases/favorites_use_case.dart';
import '../../components/dialogs.dart';
import '../../components/space.dart';

class ListFavorites extends ConsumerWidget {
  const ListFavorites({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mqPadding = MediaQuery.of(context).padding;
    Widget favDataView(List<FavoriteEntity> data) => SliverList.separated(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final fav = data[index];
            return ListTile(
              title: Text(fav.name),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 24,
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

    final favHandler = ref
        .watch(
          favoritesUseCaseProvider,
        )
        .when(
          data: favDataView,
          error: (error, s) => SliverToBoxAdapter(
            child: Center(
              child: Text(
                error.toString(),
              ),
            ),
          ),
          loading: () => const SliverToBoxAdapter(
            child: CircularProgressIndicator(),
          ),
        );
    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        mqPadding.top.verticalSpace,
        230.verticalSpace,
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 24,
            end: 30,
          ),
          child: Text(
            "Edit Favorites",
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(color: Colors.grey.shade800),
          ),
        ),
        70.verticalSpace,
      ],
    );
    final overlay = CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: header,
        ),
        favHandler,
      ],
    );
    final addNewBtn = FloatingActionButton.extended(
      label: const Text("Add new"),
      icon: const Icon(Icons.add),
      onPressed: () => context.go('/favorite/create'),
    );
    final body = Stack(
      children: [
        Image.asset(
          'assets/images/geometric pattern.png',
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
        overlay,
      ],
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: body,
      floatingActionButton: addNewBtn,
    );
  }
}
