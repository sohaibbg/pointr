part of 'go_screen.dart';

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

class _GoViewModel extends ViewModel<GoScreen> {
  final Completer<GoogleMapController> gmapCtlCompleter;

  _GoViewModel(
    super.context,
    super.ref, {
    required this.gmapCtlCompleter,
  });

  final _tutorialCompleter = Completer<void>();

  Future<void> _showTutorial() async {
    const flag = InitialDisclaimer.goScreenTutorial;
    final shouldTutorialBeShown = await shouldFlagBeShown(
      flag,
      context: context,
    );
    if (!shouldTutorialBeShown) return;
    await context.simpleDialog(
      title: 'Disclaimer',
      content:
          'pointr is not affiliated with People\'s Bus Service, the Government of Sindh or other relevant agencies.\n\nGiven routes may be subject to change and inaccuracy. Please confirm from other sources before planning your route.\n\nPlease download the official People\'s Bus Service App for official information and for using the digital ticketing system.',
    );
    final tutorialContent = [
      TargetFocus(
        identify: 'zoomInAndOutButtonGlobalKey',
        keyTarget: GmapButtons.zoomInAndOutButtonGlobalKey,
        enableOverlayTab: true,
        paddingFocus: 0,
        enableTargetTab: true,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            padding: EdgeInsets.zero,
            customPosition: CustomTargetContentPosition(
              top: -200,
            ),
            align: ContentAlign.top,
            child: const Text(
              '''Tap this button to zoom out.
                
Double tap on the map to zoom in.''',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'findMyLocationButtonGlobalKey',
        keyTarget: GmapButtons.findMyLocationButtonGlobalKey,
        enableOverlayTab: true,
        paddingFocus: 0,
        enableTargetTab: true,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            padding: EdgeInsets.zero,
            customPosition: CustomTargetContentPosition(
              top: -200,
            ),
            align: ContentAlign.top,
            child: const Text(
              '''Press this button to take the map to you current location.
                
You will have to enable permissions.''',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'usePlacesSearchGlobalKey',
        keyTarget: LocSearchBarWithOverlay.usePlacesSearchGlobalKey,
        enableOverlayTab: true,
        paddingFocus: 0,
        enableTargetTab: true,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            padding: EdgeInsets.zero,
            customPosition: CustomTargetContentPosition(
              top: -200,
            ),
            align: ContentAlign.top,
            child: const Text(
              '''Search for popular spaces to direct the map here.''',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'setLocationButtonGlobalKey',
        keyTarget: GoScreen.setLocationButtonGlobalKey,
        enableOverlayTab: true,
        paddingFocus: 0,
        enableTargetTab: true,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            padding: EdgeInsets.zero,
            customPosition: CustomTargetContentPosition(
              top: -200,
            ),
            align: ContentAlign.top,
            child: const Text(
              '''Bus routes will be displayed, based on your FROM and TO locations.
              
Use this button to set your stops''',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'showPedestrianBridgeButtonGlobalKey',
        keyTarget: GmapButtons.showPedestrianBridgeButtonGlobalKey,
        enableOverlayTab: true,
        paddingFocus: 0,
        enableTargetTab: true,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            padding: EdgeInsets.zero,
            customPosition: CustomTargetContentPosition(
              top: -200,
            ),
            align: ContentAlign.top,
            child: const Text(
              '''Pedestrian bridges can be toggled on and off on the map by clicking this button.''',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ];
    final tutorialCoachMark = TutorialCoachMark(
      targets: tutorialContent,
      hideSkip: true,
      onFinish: () => flagTutorialAsSuccessfullyShown(flag),
    );
    tutorialCoachMark.show(context: context);
  }

  void initState() async {
    print(
        'sohaib init ${context.hashCode} ${context.mounted} ${context.owner}');
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        print("sohaib init postframcallback");
        _showTutorial();
      },
    );

    return null;
  }

  bool get areBothStopsSet => ref.watch(
        bothStopsProvider.select(
          (e) => e.hasFrom & e.hasTo,
        ),
      );

  void onBackBtnPressed() {
    final searchFocusNode = LocSearchBarWithOverlay.searchFocusNode;
    if (searchFocusNode.hasFocus) return searchFocusNode.unfocus();
    if (ref.watch(toStopProvider) != null) {
      return ref.read(toStopProvider.notifier).state = null;
    }
    if (ref.watch(fromStopProvider) != null) {
      return ref.read(fromStopProvider.notifier).state = null;
    }
    return context.pop();
  }

  void onSuggestionSelected(AddressEntity place) async {
    final isCoordinateAlreadySelected = _isCoordinateAlreadySelected(
      place.coordinates,
    );
    if (isCoordinateAlreadySelected) {
      if (context.mounted) {
        ref.context.simpleDialog(
          title: 'Choose another stop',
          content: '"From" and "To" stops can\'t be the same',
        );
      }
      return;
    }
    updateStopProvider(ref, place);
    _refocusMapOnStops();
    if (areBothStopsSet) {
      _showRouteLegendIsTappable();
      _showImperfectAlgorithmDialog();
    }
  }

  Future<void> _refocusMapOnStops() async {
    final coordinates = [fromStopProvider, toStopProvider]
        .map(
          (prov) => ref.read(prov)?.coordinates,
        )
        .whereType<CoordinatesEntity>();
    if (coordinates.isEmpty) return;
    final mapCtl = await gmapCtlCompleter.future;
    late final CameraUpdate cameraUpdate;
    if (coordinates.length == 1) {
      cameraUpdate = CameraUpdate.newLatLng(
        LatLng(
          coordinates.first.latitude,
          coordinates.first.longitude,
        ),
      );
    }
    if (coordinates.length == 2) {
      final newBounds = _latLngBoundsFromCoordinatesEntities(coordinates);
      cameraUpdate = CameraUpdate.newLatLngBounds(newBounds, 36);
    }
    mapCtl.animateCamera(cameraUpdate);
  }

  bool _isCoordinateAlreadySelected(CoordinatesEntity c) {
    final directionType = ref.read(
      currentlyPickingDirectionTypeProvider,
    );
    final otherStopProvider = switch (directionType!) {
      DirectionType.to => fromStopProvider,
      DirectionType.from => toStopProvider,
    };
    final otherStop = ref.read(otherStopProvider);
    if (otherStop == null) return false;
    if (otherStop.coordinates != c) return false;
    return true;
  }

  Future<void> _showRouteLegendIsTappable() async {
    final flagRepo = getIt.call<IInitialDisclaimersShownRepo>();
    final didShow = await flagRepo.fetch(
      InitialDisclaimer.routeLegendIsTappable,
    );
    if (didShow) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted) return;
      final routeLegendTarget = TargetFocus(
        identify: "Target 1",
        keyTarget: RoutesLegendListView.globalKey,
        enableOverlayTab: true,
        paddingFocus: 0,
        enableTargetTab: true,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            padding: EdgeInsets.zero,
            customPosition: CustomTargetContentPosition(
              top: -200,
            ),
            align: ContentAlign.top,
            child: const Text(
              "Tap the card to highlight a route, or swipe right to see more.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
      final tutorialCoachMark = TutorialCoachMark(
        targets: [routeLegendTarget],
        onClickOverlay: (_) => _tutorialCompleter.complete(),
        onClickTarget: (_) => _tutorialCompleter.complete(),
        hideSkip: true,
      );
      await Future.delayed(
        kThemeAnimationDuration * 5,
        () => tutorialCoachMark.show(context: context),
      );
      await flagRepo.setTrue(
        InitialDisclaimer.routeLegendIsTappable,
      );
    });
    return _tutorialCompleter.future;
  }

  Future<void> _showImperfectAlgorithmDialog() async {
    final flagRepo = getIt.call<IInitialDisclaimersShownRepo>();
    final didShow = await flagRepo.fetch(
      InitialDisclaimer.algorithmImperfect,
    );
    if (didShow) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _tutorialCompleter.future;
      await Future.delayed(const Duration(seconds: 1));
      if (!context.mounted) return;
      context.simpleDialog(
        title: 'Disclaimer',
        content:
            'The route suggestions provided by this app are generated by an algorithm that is still being refined. Please note that the algorithm does not yet support split-route journeys (e.g., taking multiple buses for the optimal route), and the recommendations may have room for improvement',
      );
      flagRepo.setTrue(
        InitialDisclaimer.algorithmImperfect,
      );
    });
  }

  Future<void> onStopSet() async {
    final mapCtl = await gmapCtlCompleter.future;
    final mapLatLng = await mapCtl.centerLatLng;
    final isCoordinateAlreadySelected = _isCoordinateAlreadySelected(mapLatLng);
    if (isCoordinateAlreadySelected) {
      if (context.mounted) {
        ref.context.simpleDialog(
          title: 'Choose another stop',
          content: '"From" and "To" stops can\'t be the same',
        );
      }
      return;
    }
    final temporaryAddress = AddressEntity(
      coordinates: mapLatLng,
      address: '',
    );
    final directionType = updateStopProvider(ref, temporaryAddress);
    _refocusMapOnStops();
    final address = await ref.read(
      NameFromCoordinatesProvider(mapLatLng).future,
    );
    final newStop = AddressEntity(
      address: address,
      coordinates: mapLatLng,
    );
    updateStopProvider(ref, newStop, directionType: directionType);
    if (areBothStopsSet) {
      _showRouteLegendIsTappable();
      _showImperfectAlgorithmDialog();
    }
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
