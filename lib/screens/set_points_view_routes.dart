import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointr/classes/lat_lng_extension.dart';
import 'package:pointr/classes/star.dart';
import 'package:pointr/my_theme.dart';
import 'package:pointr/providers/from_provider.dart';
import 'package:pointr/providers/route_provider.dart';
import 'package:pointr/providers/star_provider.dart';
import 'package:pointr/providers/to_provider.dart';
import 'package:pointr/widgets/route_radio_list.dart';
import 'package:pointr/widgets/to_from_setter_appbar.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SetPointsViewRoutes extends StatefulWidget {
  const SetPointsViewRoutes({this.initialLatLng, super.key});
  final LatLng? initialLatLng;
  @override
  State<SetPointsViewRoutes> createState() => _SetPointsViewRoutesState();
}

class _SetPointsViewRoutesState extends State<SetPointsViewRoutes> {
  static final Completer<GoogleMapController> mapController = Completer();

  void animateCameraHere(LatLng latLng) {
    mapController.future.then(
      (controller) {
        controller.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 17),
        );
      },
    );
  }

  void onStar(LatLng latLng) => showDialog(
        context: context,
        builder: (context) {
          TextEditingController controller = TextEditingController();
          return AlertDialog(
            content: TextField(
              autofocus: true,
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Star Name',
                prefixIcon: Icon(Icons.star_border),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text("CANCEL")),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await Provider.of<StarProvider>(context, listen: false)
                      .create(
                    Star(-1, controller.text, latLng),
                  );
                },
                style: const ButtonStyle(
                  foregroundColor:
                      MaterialStatePropertyAll(MyTheme.colorSecondary),
                ),
                child: const Text("CREATE NEW STAR"),
              )
            ],
          );
        },
      );

  Future<LatLng> getLatLng() async {
    GoogleMapController mc = await mapController.future;
    LatLngBounds bounds = await mc.getVisibleRegion();
    return LatLng((bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            // app bar
            ToFromSetterAppBar(onSelected: animateCameraHere),
            Expanded(
              child: Stack(
                children: [
                  // map, buttons, route list
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // map
                      Consumer<RouteProvider>(
                        builder: (context, routeProvider, child) => GoogleMap(
                          padding: const EdgeInsets.only(bottom: 100),
                          onMapCreated: (GoogleMapController controller) =>
                              mapController.complete(controller),
                          myLocationEnabled: true,
                          polylines:
                              routeProvider.all[routeProvider.selectedScore] ??
                                  {},
                          markers: {
                            if (Provider.of<FromProvider>(context,
                                        listen: false)
                                    .selected !=
                                null)
                              Marker(
                                markerId: const MarkerId('from'),
                                position: Provider.of<FromProvider>(context,
                                        listen: false)
                                    .selected!,
                              ),
                            if (Provider.of<ToProvider>(context, listen: false)
                                    .selected !=
                                null)
                              Marker(
                                markerId: const MarkerId('to'),
                                position: Provider.of<ToProvider>(context,
                                        listen: false)
                                    .selected!,
                              ),
                          },
                          initialCameraPosition: CameraPosition(
                            target: widget.initialLatLng ??
                                const LatLng(24.860966, 66.990501),
                            zoom: 15,
                          ),
                        ),
                      ),
                      // location pin icon
                      Padding(
                        padding: const EdgeInsets.only(bottom: 56),
                        child: Consumer2<FromProvider, ToProvider>(
                          builder: (context, fromProv, toProv, child) =>
                              fromProv.selected != null &&
                                      toProv.selected != null
                                  ? const SizedBox()
                                  : const Icon(
                                      Icons.location_on,
                                      color: MyTheme.colorPrimary,
                                      size: 56,
                                      shadows: [
                                        Shadow(
                                            offset: Offset(0.1, 0.9),
                                            blurRadius: 6)
                                      ],
                                    ),
                        ),
                      ),
                      // buttons
                      Consumer3<FromProvider, ToProvider, RouteProvider>(
                          builder: (context, fromProvider, toProvider,
                                  routeProvider, child) =>
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: fromProvider.selected != null &&
                                        toProvider.selected != null
                                    ? const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 80),
                                        child: RouterRadioList(),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.all(5.w),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            // new star button
                                            Expanded(
                                              flex: 5,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16),
                                                child: ElevatedButton.icon(
                                                  icon: const Icon(Icons.star),
                                                  onPressed: () async {
                                                    onStar(await getLatLng());
                                                  },
                                                  label: const Text(
                                                    "Star",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  ),
                                                  style: MyTheme
                                                      .outlineButtonStyle
                                                      .copyWith(
                                                    elevation:
                                                        const MaterialStatePropertyAll(
                                                            5),
                                                    padding:
                                                        const MaterialStatePropertyAll(
                                                      EdgeInsets.only(
                                                        top: 18,
                                                        bottom: 18,
                                                        left: 12,
                                                        right: 24,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // next button
                                            Expanded(
                                              flex: 7,
                                              child: ElevatedButton.icon(
                                                icon: const Icon(
                                                    Icons.arrow_forward),
                                                onPressed: () async {
                                                  var latLng =
                                                      await getLatLng();
                                                  var name =
                                                      await latLng.getName();
                                                  if (fromProvider.selected ==
                                                          null &&
                                                      context.mounted) {
                                                    fromProvider.select(
                                                      latLng: latLng,
                                                      name: name,
                                                      context: context,
                                                    );
                                                  } else if (toProvider
                                                              .selected ==
                                                          null &&
                                                      context.mounted) {
                                                    toProvider.select(
                                                      latLng: latLng,
                                                      name: name,
                                                      context: context,
                                                    );
                                                  }
                                                },
                                                label: const Text("Next"),
                                                style: const ButtonStyle(
                                                  elevation:
                                                      MaterialStatePropertyAll(
                                                          5),
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                    MyTheme.colorPrimary,
                                                  ),
                                                  padding:
                                                      MaterialStatePropertyAll(
                                                    EdgeInsets.only(
                                                      top: 18,
                                                      bottom: 18,
                                                      left: 12,
                                                      right: 24,
                                                    ),
                                                  ),
                                                  shape:
                                                      MaterialStatePropertyAll(
                                                    StadiumBorder(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
