import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../config/injector.dart';
import '../../../domain/entities/address_entity.dart';
import '../../../domain/entities/favorite_entity.dart';
import '../../../domain/repositories/i_favorites_repo.dart';
import '../../../domain/repositories/i_location_repo.dart';
import '../../../infrastructure/services/packages/focus_node.dart';
import '../../../infrastructure/services/packages/google_map_controller.dart';
import '../../../infrastructure/services/packages/view_model.dart';
import '../../components/dialogs.dart';
import '../../components/loc_search_bar.dart';
import '../../components/map_with_pin_and_banner.dart';
import '../../components/space.dart';

class _NewFavoriteViewModel extends ViewModel<NewFavorite> {
  const _NewFavoriteViewModel(
    super.context,
    super.ref, {
    required this.mapCtlCompleter,
    required this.searchBarFocusNode,
  });

  final Completer<GoogleMapController> mapCtlCompleter;
  final FocusNode searchBarFocusNode;

  void onPopInvoked(bool didPop) {
    if (searchBarFocusNode.hasFocus) return searchBarFocusNode.unfocus();
    context.pop();
  }

  Future<String?> _fetchName() async {
    final tec = TextEditingController();
    final title = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: tec,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Title for new location',
          ),
          onSubmitted: Navigator.of(context).pop,
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text(
              "Return",
            ),
          ),
          ElevatedButton(
            autofocus: true,
            onPressed: () => Navigator.of(context).pop(
              tec.text,
            ),
            child: const Text(
              "Create new favorite",
            ),
          ),
        ],
      ),
    );
    return title;
  }

  Future<void> confirmLocation() async {
    final mapCtl = await mapCtlCompleter.future;
    final latLng = await mapCtl.centerLatLng;
    final name = await _fetchName();
    if (name is! String) return;
    final lp = FavoriteEntity(
      name: name,
      coordinates: latLng,
    );
    final doesTitleConflict =
        await getIt.call<IFavoritesRepo>().doesTitleAlreadyExist(name);
    if (doesTitleConflict) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Conflict',
          ),
          content: Text(
            '"$name" already exists. Do you want to update it?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel and return"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await context.loaderWithErrorDialog(
                  () => getIt.call<IFavoritesRepo>().update(
                        name,
                        coordinates: latLng,
                      ),
                );
                context.go('/');
              },
              child: const Text("Update and save changes"),
            ),
          ],
        ),
      );
    }
    await context.loaderWithErrorDialog(
      () => getIt.call<IFavoritesRepo>().insert(lp),
    );
    context.go('/');
  }

  Future<void> onPlaceSelected(
    AddressEntity locatedPlace,
  ) async {
    final mapCtl = await mapCtlCompleter.future;
    final latLng = LatLng(
      locatedPlace.coordinates.latitude,
      locatedPlace.coordinates.longitude,
    );
    mapCtl.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }
}

class NewFavorite extends HookConsumerWidget {
  const NewFavorite({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapCtlCompleter = useMemoized(
      () => Completer<GoogleMapController>(),
      [context],
    );
    final searchBarFocusNode = useFocusNode();
    final vm = _NewFavoriteViewModel(
      context,
      ref,
      mapCtlCompleter: mapCtlCompleter,
      searchBarFocusNode: searchBarFocusNode,
    );
    final selectLocBtn = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ElevatedButton.icon(
        onPressed: vm.confirmLocation,
        style: const ButtonStyle(
          padding: MaterialStatePropertyAll(
            EdgeInsets.symmetric(vertical: 18, horizontal: 18),
          ),
          textStyle: MaterialStatePropertyAll(
            TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          iconSize: MaterialStatePropertyAll(48),
        ),
        label: const Text("Confirm location"),
        icon: const Icon(Icons.done),
      ),
    );
    final returnBtn = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: TextButton.icon(
        onPressed: () => context.go('/'),
        style: const ButtonStyle(
          padding: MaterialStatePropertyAll(
            EdgeInsets.symmetric(vertical: 18, horizontal: 18),
          ),
          textStyle: MaterialStatePropertyAll(
            TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          iconSize: MaterialStatePropertyAll(48),
        ),
        label: const Text("Cancel and Return"),
        icon: const Icon(Icons.arrow_back),
      ),
    );
    final mapWithSearchBar = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        MapWithPinAndBanner(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              karachiLatLng.latitude,
              karachiLatLng.longitude,
            ),
            zoom: 15,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 148,
            horizontal: 36,
          ),
          onMapCreated: mapCtlCompleter.complete,
        ),
        LocSearchBar(
          focusNode: searchBarFocusNode,
          onPlaceSelected: vm.onPlaceSelected,
          prefixIconWhenNotFocused: const Icon(Icons.favorite),
        ),
      ],
    );
    final bottomPanel = Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: selectLocBtn,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: returnBtn,
        ),
      ],
    );
    final bottomPanelWithShrinkAnimationOnSearchBarFocus = AnimatedSize(
      duration: kThemeAnimationDuration,
      alignment: Alignment.topCenter,
      child: useIsFocused(
        searchBarFocusNode,
      )
          ? double.infinity.horizontalSpace
          : bottomPanel,
    );
    return PopScope(
      onPopInvoked: vm.onPopInvoked,
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: mapWithSearchBar,
              ),
              bottomPanelWithShrinkAnimationOnSearchBarFocus,
            ],
          ),
        ),
      ),
    );
  }
}
