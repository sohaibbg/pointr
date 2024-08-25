import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../config/my_theme.dart';
import '../../../domain/entities/address_entity.dart';
import '../../../domain/entities/favorite_entity.dart';
import '../../../domain/repositories/i_location_repo.dart';
import '../../../domain/use_cases/favorites_use_case.dart';
import '../../../infrastructure/services/packages/google_map_controller.dart';
import '../../../infrastructure/services/packages/view_model.dart';
import '../../components/dialogs.dart';
import '../../components/gmap_buttons.dart';
import '../../components/header_footer.dart';
import '../../components/loc_search_bar_with_overlay.dart';
import '../../components/map_with_pin_and_banner.dart';
import '../../components/space.dart';

class _NewFavoriteViewModel extends ViewModel<NewFavorite> {
  const _NewFavoriteViewModel(
    super.context,
    super.ref, {
    required this.mapCtlCompleter,
  });

  final Completer<GoogleMapController> mapCtlCompleter;

  void onPopInvoked(bool didPop) {
    if (LocSearchBarWithOverlay.searchFocusNode.hasFocus) {
      return LocSearchBarWithOverlay.searchFocusNode.unfocus();
    }
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
    if (name == null) return;
    final doesTitleConflict = await ref
        .read(favoritesUseCaseProvider.notifier)
        .doesTitleAlreadyExist(name);
    if (doesTitleConflict) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Conflict'),
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
                  () => ref
                      .read(favoritesUseCaseProvider.notifier)
                      .updateExisting(name, coordinates: latLng),
                );
                context.go('/');
              },
              child: const Text("Update and save changes"),
            ),
          ],
        ),
      );
    }
    final lp = FavoriteEntity(
      name: name,
      coordinates: latLng,
    );
    await context.loaderWithErrorDialog(
      () => ref
          .read(
            favoritesUseCaseProvider.notifier,
          )
          .insert(lp),
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
    final vm = _NewFavoriteViewModel(
      context,
      ref,
      mapCtlCompleter: mapCtlCompleter,
    );
    final selectLocBtn = ElevatedButton.icon(
      onPressed: vm.confirmLocation,
      style: MyTheme.primaryElevatedButtonStyle,
      label: const Text("Select favorite"),
      icon: const Icon(Icons.chevron_right_sharp),
    );
    final map = MapWithPinAndBanner(
      primaryColor: Colors.pink,
      topIconData: Icons.favorite,
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
    );
    final backBtn = ElevatedButton(
      onPressed: context.pop,
      style: MyTheme.secondaryButtonStyle,
      child: const Icon(
        Icons.arrow_back_ios_new_outlined,
      ),
    );
    final bottomPanelBody = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        children: [
          Row(
            children: [
              backBtn,
              12.horizontalSpace,
              Expanded(child: selectLocBtn),
            ],
          ),
          kBottomNavigationBarHeight.verticalSpace,
        ],
      ),
    );
    final animatingBottomPanel = AnimatedSize(
      duration: kThemeAnimationDuration,
      child: AnimatedBuilder(
        animation: LocSearchBarWithOverlay.searchFocusNode,
        builder: (context, child) =>
            LocSearchBarWithOverlay.searchFocusNode.hasFocus
                ? double.infinity.horizontalSpace
                : bottomPanelBody,
      ),
    );
    final footer = HeaderFooter(
      child: Column(
        children: [
          LocSearchBarWithOverlay(
            onPlaceSelected: vm.onPlaceSelected,
          ),
          24.verticalSpace,
          animatingBottomPanel,
        ],
      ),
    );
    final overlay = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: GmapButtons(mapCtlCompleter),
          ),
        ),
        24.verticalSpace,
        footer,
      ],
    );
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          map,
          overlay,
        ],
      ),
    );
  }
}
