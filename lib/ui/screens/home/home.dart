import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../config/my_theme.dart';
import '../../../../models/coordinates.dart';
import '../../../../models/google_place.dart';
import '../../../../models/located_google_place.dart';
import '../../../../models/located_place.dart';
import '../../../../repo/location.dart';
import '../../../../repo/nearby_places.dart';
import '../../../models/view_model.dart';
import '../../../repo/local/favorites.dart';
import '../../components/dialogs.dart';
import '../../components/space.dart';

part '_favorites.dart';
part '_home_view_model.dart';
part '_nearby_suggestions.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hvm = HomeViewModel(context, ref);
    final backdrop = Image.asset(
      'assets/images/geometric pattern.png',
      fit: BoxFit.fitWidth,
      alignment: Alignment.topCenter,
    );
    final searchButton = ListTile(
      onTap: hvm.searchOnPressed,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 24,
      ),
      leading: const Icon(
        Icons.search,
      ),
      trailing: IconButton(
        onPressed: hvm.locateMeButtonOnPressed,
        icon: const Icon(
          Icons.my_location_sharp,
        ),
      ),
      title: const Text("Enter Destination..."),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: MyTheme.colorSecondaryDark),
      ),
      tileColor: MyTheme.colorSecondaryLight,
    );
    final title = ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 400,
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 48,
            left: 24,
            right: 30,
            bottom: 24,
          ),
          child: Text(
            "Where are you currently?",
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
      ),
    );
    final scrollController = useScrollController();
    final foreground = CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              title,
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                child: searchButton,
              ),
              const _FavoritesHandler(),
            ],
          ),
        ),
        const _NearbySuggestions(),
        const SliverToBoxAdapter(
          child: SizedBox(height: 240),
        ),
      ],
    );
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          backdrop,
          foreground,
        ],
      ),
    );
  }
}
