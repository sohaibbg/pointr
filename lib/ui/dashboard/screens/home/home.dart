import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../misc/my_theme.dart';
import '../../../../models/located_place.dart';
import '../../../../repo/favorites.dart';
import 'home_view_model.dart';
import 'nearby_suggestions.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hvm = HomeViewModel(context);
    final backdrop = Image.asset(
      'assets/images/geometric pattern.png',
      fit: BoxFit.fitWidth,
      alignment: Alignment.topCenter,
    );
    final searchButton = ListTile(
      leading: IconButton(
        onPressed: hvm.searchOnPressed,
        icon: const Icon(
          Icons.search,
        ),
      ),
      trailing: IconButton(
        onPressed: hvm.locateMeButtonOnPressed,
        icon: const Icon(
          Icons.my_location_sharp,
        ),
      ),
      title: const Text("Enter Destination..."),
      shape: const OutlineInputBorder(
        borderSide: BorderSide(color: MyTheme.colorSecondaryDark),
      ),
      tileColor: MyTheme.colorSecondaryLight,
    );
    Widget favoritesButtonBuilder(LocatedPlace favorite) => OutlinedButton.icon(
          onPressed: () => hvm.favoriteSelected(
            favorite,
          ),
          style: MyTheme.outlineButtonStyle.copyWith(
            backgroundColor: const MaterialStatePropertyAll(
              Colors.white,
            ),
          ),
          icon: const Icon(Icons.star),
          label: Text(
            favorite.toString(),
            textAlign: TextAlign.start,
          ),
        );
    Widget favoritesBar(List<LocatedPlace> favs) => SizedBox(
          height: 200,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            padding: const EdgeInsets.only(left: 7),
            scrollDirection: Axis.horizontal,
            itemCount: favs.length,
            itemBuilder: (context, index) {
              final fav = favs[index];
              return favoritesButtonBuilder(fav);
            },
          ),
        );

    final foreground = ListView(
      children: [
        // title
        Padding(
          padding: const EdgeInsets.only(
            top: 15,
            left: 7,
            right: 7,
            bottom: 2,
          ),
          child: Text(
            "Where are you currently?",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        // search
        Padding(
          padding: const EdgeInsets.fromLTRB(7, 0, 7, 2),
          child: searchButton,
        ),
        // favorites
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ref.watch(favoritesProvider).when(
                data: favoritesBar,
                error: (error, stackTrace) => const Text('error'),
                loading: () => const LinearProgressIndicator(),
              ),
        ),
        const Suggestions(),
      ],
    );
    return Stack(
      alignment: Alignment.topCenter,
      fit: StackFit.expand,
      children: [
        backdrop,
        foreground,
      ],
    );
  }
}
