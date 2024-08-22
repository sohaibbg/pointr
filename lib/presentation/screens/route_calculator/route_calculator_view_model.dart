part of 'route_calculator.dart';

LatLngBounds _latLngBoundsFromCoordinatesEntities(
  Iterable<CoordinatesEntity> list,
) {
  final latitudes = list.map((e) => e.latitude);
  final northest = latitudes.calculateMax();
  final southest = latitudes.calculateMin();
  final longitudes = list.map((e) => e.longitude);
  final eastest = longitudes.calculateMax();
  final westest = longitudes.calculateMin();
  final northeast = LatLng(northest, eastest);
  final southwest = LatLng(southest, westest);
  final latLngBounds = LatLngBounds(
    northeast: northeast,
    southwest: southwest,
  );
  return latLngBounds;
}

class RouteCalculatorViewModel extends ViewModel<RouteCalculator> {
  final Completer<GoogleMapController> gmapCtlCompleter;

  const RouteCalculatorViewModel(
    super.context,
    super.ref, {
    required this.gmapCtlCompleter,
  });

  int get numberOfStopsConfirmed => [
        fromStopProvider,
        toStopProvider,
      ]
          .map(
            (provider) => ref.watch(
              provider.select(
                (value) => value != null,
              ),
            ),
          )
          .where((e) => e)
          .length;

  bool get areBothStopsSet => numberOfStopsConfirmed == 2;

  Future<void> onPlaceSelected(AddressEntity place) async {
    final mapCtl = await gmapCtlCompleter.future;
    mapCtl.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
          place.coordinates.latitude,
          place.coordinates.longitude,
        ),
        15,
      ),
    );
  }

  /// only animates if both stops are set
  Future<void> _animateCameraToBoundsOfStops() async {
    final from = ref.read(fromStopProvider)?.coordinates;
    if (from == null) return;
    final to = ref.read(toStopProvider)?.coordinates;
    if (to == null) return;
    final newBounds = _latLngBoundsFromCoordinatesEntities([from, to]);
    final mapCtl = await gmapCtlCompleter.future;
    mapCtl.animateCamera(
      CameraUpdate.newLatLngBounds(newBounds, 36),
    );
  }

  Future<void> onPlaceConfirmed() async {
    final mapCtl = await gmapCtlCompleter.future;
    final mapLatLng = await mapCtl.centerLatLng;
    await context.loaderWithErrorDialog(
      () => updateStopProvider(ref, mapLatLng),
    );
    _animateCameraToBoundsOfStops();
  }

  String get selectLocBtnLabel {
    final currentlyPickingStop = ref
            .watch(
              currentlyPickingDirectionTypeProvider,
            )
            ?.name
            .toUpperCase() ??
        "";
    return "Set $currentlyPickingStop location";
  }
}
