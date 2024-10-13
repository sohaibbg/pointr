import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../config/injector.dart';
import '../../../config/my_theme.dart';
import '../../../domain/entities/coordinates_entity.dart';
import '../../../domain/entities/route_entity.dart';
import '../../../domain/repositories/i_initial_disclaimers_shown_repo.dart';
import '../../../domain/repositories/i_location_repo.dart';
import '../../../domain/use_cases/routes_use_case.dart';
import '../../../infrastructure/services/packages/google_map_controller.dart';
import '../../../infrastructure/services/packages/view_model.dart';
import '../../components/dialogs.dart';
import '../../components/map/gmap_buttons.dart';
import '../../components/map/loc_search_bar_with_overlay.dart';
import '../../components/map/map_with_pin_and_banner.dart';
import '../../components/slide_transition_helper.dart';
import '../../components/space.dart';

class CreateRouteScreen extends HookConsumerWidget {
  const CreateRouteScreen({super.key});

  static final dropPinKey =
      GlobalKey(debugLabel: 'CreateRouteScreen.dropPinBtn');
  static final reversePinDropKey =
      GlobalKey(debugLabel: 'CreateRouteScreen.reversePinDropBtn');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapCtlCompleter = useRef(Completer<GoogleMapController>()).value;
    final points = useState(<CoordinatesEntity>[]);
    final dragPolyline = useState<Polyline?>(null);
    final vm = _CreateRouteViewModel(
      context,
      ref,
      mapCtlCompleter: mapCtlCompleter,
      points: points,
      dragPolyline: dragPolyline,
    );
    useEffect(
      () {
        vm.initState();
        return null;
      },
      const [],
    );
    final map = MapWithPinAndBanner(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          karachiLatLng.latitude,
          karachiLatLng.longitude,
        ),
        zoom: 15,
      ),
      markers: vm.markers,
      primaryColor: const HSLColor.fromAHSL(
        1,
        BitmapDescriptor.hueRed,
        1,
        0.5,
      ).toColor(),
      polylines: {
        if (vm.selectionPolyline != null) vm.selectionPolyline!,
        if (dragPolyline.value != null) dragPolyline.value!,
      },
      onMapCreated: (controller) => mapCtlCompleter.complete(controller),
      onCameraMove: vm.onCameraMove,
    );
    final backBtn = ElevatedButton(
      onPressed: context.pop,
      style: MyTheme.secondaryButtonStyle,
      child: const Icon(
        Icons.arrow_back_ios_new_outlined,
      ),
    );
    final backOrFinishSelectionRow = Row(
      children: [
        10.verticalSpace,
        backBtn,
        12.horizontalSpace,
        Expanded(
          child: ElevatedButton.icon(
            onPressed: vm.onSelectionFinished,
            style: MyTheme.primaryElevatedButtonStyle,
            label: const Text("Finish Selection"),
            icon: const Icon(Icons.keyboard_arrow_right),
          ),
        ),
      ],
    );
    final pinDropOrReverseRow = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 60,
          width: 100,
          child: IconButton.filled(
            key: reversePinDropKey,
            onPressed: points.value.isEmpty ? null : vm.onReverse,
            icon: const Icon(Icons.undo),
          ),
        ),
        12.horizontalSpace,
        SizedBox(
          height: 60,
          width: 200,
          child: ElevatedButton.icon(
            key: dropPinKey,
            onPressed: vm.onPinDrop,
            style: MyTheme.primaryOutlinedButtonStyle,
            label: const Text("Drop pin"),
            icon: const Icon(
              Icons.location_pin,
            ),
          ),
        ),
      ],
    );
    final belowSearchBarItems = ListenableBuilder(
      listenable: LocSearchBarWithOverlay.searchFocusNode,
      builder: (context, child) => SlideTransitionHelper(
        doShow: !LocSearchBarWithOverlay.searchFocusNode.hasFocus,
        axis: Axis.vertical,
        axisAlignment: -1,
        child: child!,
      ),
      child: Column(
        children: [
          18.verticalSpace,
          backOrFinishSelectionRow,
          12.verticalSpace,
          MediaQuery.of(context).padding.bottom.verticalSpace,
        ],
      ),
    );
    final footer = Card(
      margin: EdgeInsets.zero,
      color: MyTheme.primaryColor.shade50,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.zero,
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          12.verticalSpace,
          LocSearchBarWithOverlay(
            onPlaceSelected: (locatedPlace) async {
              final ctl = await mapCtlCompleter.future;
              final latLng = LatLng(
                locatedPlace.coordinates.latitude,
                locatedPlace.coordinates.longitude,
              );
              ctl.animateCamera(
                CameraUpdate.newLatLng(latLng),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: belowSearchBarItems,
          ),
        ],
      ),
    );
    final foreground = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: GmapButtons(mapCtlCompleter),
        ),
        92.verticalSpace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: pinDropOrReverseRow,
        ),
        8.verticalSpace,
        footer,
      ],
    );
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          map,
          foreground,
        ],
      ),
    );
  }
}

class _CreateRouteViewModel extends ViewModel<CreateRouteScreen> {
  const _CreateRouteViewModel(
    super.context,
    super.ref, {
    required this.mapCtlCompleter,
    required this.points,
    required this.dragPolyline,
  });

  final Completer<GoogleMapController> mapCtlCompleter;
  final ValueNotifier<List<CoordinatesEntity>> points;
  final ValueNotifier<Polyline?> dragPolyline;

  Future<void> initState() async {
    const flag = InitialDisclaimer.dropPinsToDrawRoute;
    final repo = getIt.call<IInitialDisclaimersShownRepo>();
    final hasAlreadyShown = await repo.fetch(flag);
    if (hasAlreadyShown) return;
    final dropPinFocus = TargetFocus(
      identify: 'CreateRouteScreen.dropPinKey',
      keyTarget: CreateRouteScreen.dropPinKey,
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
            '''Drop pins using this button.
	
Each pin connects to the next to draw a contiguous route.''',
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
    final reversePinDropContent = TargetFocus(
      identify: 'CreateRouteScreen.reversePinDropKey',
      keyTarget: CreateRouteScreen.reversePinDropKey,
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
            '''Use the 'undo' button to remove the latest pin dropped on the map.''',
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
      targets: [dropPinFocus, reversePinDropContent],
      hideSkip: true,
    );
    tutorialCoachMark.show(context: context);
    repo.setTrue(flag);
  }

  Set<Marker> get markers {
    if (points.value.isEmpty) return {};
    final last = points.value.last;
    return points.value
        .map(
          (e) => Marker(
            markerId: MarkerId(
              [e.latitude, e.longitude].toString(),
            ),
            position: LatLng(e.latitude, e.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              e == last
                  ? BitmapDescriptor.hueRed
                  : HSLColor.fromColor(
                      Colors.purple.shade900,
                      // MyTheme.primaryColor,
                    ).hue,
            ),
          ),
        )
        .toSet();
  }

  void onSelectionFinished() async {
    if (points.value.length < 2) {
      return context.simpleDialog(
        title: 'Not enough points entered',
        content: 'Drop at least 2 pins in the selection',
      );
    }
    final route = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _CompleteCreationDialog(points.value),
    );
    if (route == null) return;
    await ref.read(routesUseCaseProvider.notifier).addRoute(route);
    context.pop();
  }

  Future<void> _rebuildDragPolyline({
    CoordinatesEntity? point1,
    required CoordinatesEntity point2,
  }) async {
    if (point1 == null) {
      final ctl = await mapCtlCompleter.future;
      point1 = await ctl.centerLatLng;
    }
    final point1ll = LatLng(
      point1.latitude,
      point1.longitude,
    );
    final point2ll = LatLng(
      point2.latitude,
      point2.longitude,
    );
    dragPolyline.value = Polyline(
      polylineId: const PolylineId('dragPolyline'),
      color: MyTheme.primaryColor.withOpacity(0.5),
      points: [
        point1ll,
        point2ll,
      ],
      width: 4,
    );
  }

  void onReverse() async {
    points.value = points.value.toList()..removeLast();
    if (points.value.isEmpty) {
      dragPolyline.value = null;
      return;
    }
    _rebuildDragPolyline(point2: points.value.last);
    if (points.value.isEmpty) return;
  }

  void onPinDrop() async {
    final mapCtl = await mapCtlCompleter.future;
    final newPoint = await mapCtl.centerLatLng;
    final newPointList = points.value.toList()..add(newPoint);
    points.value = newPointList;
    dragPolyline.value = null;
  }

  Polyline? get selectionPolyline => points.value.length < 2
      ? null
      : Polyline(
          polylineId: const PolylineId(
            'routeBeingCreated',
          ),
          color: MyTheme.primaryColor,
          width: 4,
          points: points.value
              .map(
                (point) => LatLng(
                  point.latitude,
                  point.longitude,
                ),
              )
              .toList(),
        );

  Future<void> onCameraMove(CameraPosition position) async {
    if (points.value.isEmpty) return;
    final point2 = CoordinatesEntity(
      position.target.latitude,
      position.target.longitude,
    );
    await _rebuildDragPolyline(
      point1: points.value.last,
      point2: point2,
    );
  }
}

class _CompleteCreationDialog extends HookWidget {
  const _CompleteCreationDialog(this.points);

  final List<CoordinatesEntity> points;

  @override
  Widget build(BuildContext context) {
    final nameCtl = useTextEditingController();
    final formKey = useRef(GlobalKey<FormState>()).value;
    final nameField = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          autofocus: true,
          controller: nameCtl,
          validator: (value) =>
              value!.isEmpty ? 'Name must not be empty.' : null,
          decoration: const InputDecoration(
            labelText: 'Name of Route',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
    final selectedMode = useState(RouteMode.values.first);
    final routeModeColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text("Select Route Mode"),
        ),
        6.verticalSpace,
        ...RouteMode.values.map(
          (mode) => CheckboxListTile(
            contentPadding: const EdgeInsetsDirectional.fromSTEB(24, 5, 24, 5),
            value: mode == selectedMode.value,
            onChanged: (value) => selectedMode.value = mode,
            title: Text(mode.name),
          ),
        ),
      ],
    );
    final actionsRow = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: context.pop,
            child: const Text('Return'),
          ),
          12.horizontalSpace,
          ElevatedButton(
            onPressed: () {
              final isValid = formKey.currentState!.validate();
              if (!isValid) return;
              final name = nameCtl.text;
              final route = RouteEntity(
                name: name,
                mode: selectedMode.value,
                points: points,
              );
              context.pop(route);
            },
            child: const Text('Create new Route'),
          ),
        ],
      ),
    );
    final bodyContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        18.verticalSpace,
        nameField,
        24.verticalSpace,
        routeModeColumn,
        12.verticalSpace,
        actionsRow,
      ],
    );
    return Material(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          child: bodyContent,
        ),
      ),
    );
  }
}
