part of 'home.dart';

class HomeViewModel extends ViewModel<Home> {
  const HomeViewModel(super.context, super.ref);

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
}
