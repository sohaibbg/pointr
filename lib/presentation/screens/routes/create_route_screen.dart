import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../config/my_theme.dart';
import '../../../domain/entities/coordinates_entity.dart';
import '../../../domain/entities/route_entity.dart';
import '../../../domain/repositories/i_location_repo.dart';
import '../../../domain/use_cases/routes_use_case.dart';
import '../../../infrastructure/services/packages/google_map_controller.dart';
import '../../../infrastructure/services/packages/view_model.dart';
import '../../components/dialogs.dart';
import '../../components/gmap_buttons.dart';
import '../../components/header_footer.dart';
import '../../components/map_with_pin_and_banner.dart';
import '../../components/space.dart';

class CreateRouteScreen extends HookConsumerWidget {
  const CreateRouteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapCtlCompleter = useRef(Completer<GoogleMapController>()).value;
    final points = useState(<CoordinatesEntity>[]);
    final vm = _CreateRouteViewModel(
      context,
      ref,
      mapCtlCompleter: mapCtlCompleter,
      points: points,
    );
    final map = MapWithPinAndBanner(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          karachiLatLng.latitude,
          karachiLatLng.longitude,
        ),
        zoom: 15,
      ),
      markers: points.value
          .map(
            (e) => Marker(
              markerId: MarkerId(
                [e.latitude, e.longitude].toString(),
              ),
              position: LatLng(e.latitude, e.longitude),
            ),
          )
          .toSet(),
      polylines: vm.polylines,
      onMapCreated: (controller) => mapCtlCompleter.complete(controller),
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
            onPressed: points.value.isEmpty ? null : vm.onReverse,
            icon: const Icon(Icons.undo),
          ),
        ),
        12.horizontalSpace,
        SizedBox(
          height: 60,
          width: 200,
          child: ElevatedButton.icon(
            onPressed: vm.onPinDrop,
            style: MyTheme.primaryOutlinedButtonStyle,
            label: const Text("Drop pin"),
            icon: const Icon(Icons.location_pin),
          ),
        ),
      ],
    );
    final footer = HeaderFooter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            pinDropOrReverseRow,
            18.verticalSpace,
            backOrFinishSelectionRow,
            12.verticalSpace,
            MediaQuery.of(context).padding.bottom.verticalSpace,
          ],
        ),
      ),
    );
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          map,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: GmapButtons(mapCtlCompleter),
              ),
              128.verticalSpace,
              footer,
            ],
          ),
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
  });

  final Completer<GoogleMapController> mapCtlCompleter;
  final ValueNotifier<List<CoordinatesEntity>> points;

  void onSelectionFinished() async {
    if (points.value.length < 2) {
      return context.errorDialog(
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

  void onReverse() async {
    if (points.value.isEmpty) return;
    points.value = points.value.toList()..removeLast();
  }

  void onPinDrop() async {
    final mapCtl = await mapCtlCompleter.future;
    final point = await mapCtl.centerLatLng;
    points.value = points.value.toList()..add(point);
  }

  Set<Polyline> get polylines {
    if (points.value.length < 2) return {};
    final polyline = Polyline(
      polylineId: const PolylineId(
        'routeBeingCreated',
      ),
      color: Colors.red,
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
    return {polyline};
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
