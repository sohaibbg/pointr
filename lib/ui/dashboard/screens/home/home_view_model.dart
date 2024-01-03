import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../models/google_place.dart';
import '../../../../models/located_place.dart';
import '../../../components/dialogs.dart';

class HomeViewModel {
  final BuildContext context;

  const HomeViewModel(this.context);

  void locateMeButtonOnPressed() => context.go(
        '/route-calculator',
      );

  void searchOnPressed() => context.go(
        '/route-calculator',
        extra: {'focusSearch': true},
      );

  void placeSelected(GooglePlace place) async {
    final coordinates = await context.loaderWithErrorDialog(
      place.getCoordinate,
    );
    context.go(
      '/route-calculator',
      extra: {'initialCoordinates': coordinates},
    );
  }

  void favoriteSelected(LocatedPlace favorite) => context.go(
        '/route-calculator',
        extra: {'initialCoordinates': favorite.coordinates},
      );
}
