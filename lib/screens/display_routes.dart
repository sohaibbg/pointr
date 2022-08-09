import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pointr/classes/viable_route.dart';
import 'package:sizer/sizer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../classes/catalogue.dart';

class DisplayRoutes extends StatefulWidget {
  const DisplayRoutes({
    Key? key,
    required this.departure,
    required this.destination,
  }) : super(key: key);

  final LatLng departure;
  final LatLng destination;

  @override
  // ignore: no_logic_in_create_state
  State<DisplayRoutes> createState() => _DisplayRoutesState(
        departure,
        destination,
      );
}

class _DisplayRoutesState extends State<DisplayRoutes> {
  _DisplayRoutesState(
    this.departure,
    this.destination,
  );

  LatLng departure;
  LatLng destination;
  // ignore: prefer_final_fields
  Completer<GoogleMapController> _controller = Completer();
  double? selectedScore;
  Map groupedViableRoutes = {};

  @override
  void initState() {
    super.initState();
    fu = calculateViability();
  }

  Future<dynamic> calculateViability() async {
    // fetch all routes
    if (Catalogue.routes == null) {
      await Catalogue.loadRoutes();
    }
    // calculate viability
    List<ViableRoute> viableRoutes = Catalogue.routes!
        .map((route) => ViableRoute.between(departure, destination, route))
        .toList();
    // gather scores
    List<double> scoreOptions = [];
    for (var route in viableRoutes) {
      scoreOptions.add(route.score);
    }
    // sort
    scoreOptions = scoreOptions.toSet().toList();
    scoreOptions.sort();
    selectedScore = scoreOptions.first;
    // group
    for (int i = 0; i < scoreOptions.length; i++) {
      var score = scoreOptions[i];
      groupedViableRoutes[score] = viableRoutes
          .where((vr) => vr.score == score)
          .map(
            (vr) => vr.polyline.copyWith(
              colorParam: Colors.primaries[i % Colors.primaries.length],
            ),
          )
          .toSet();
    }
  }

  late Future fu;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            FutureBuilder(
              initialData: const {},
              future: fu,
              builder: (context, snapshot) => GoogleMap(
                polylines: groupedViableRoutes[selectedScore] ?? {},
                onMapCreated: (controller) {
                  _controller.complete(controller);
                  setState(
                    () {
                      controller.animateCamera(
                        CameraUpdate.newLatLngBounds(
                          LatLngBounds(
                            southwest:
                                destination.latitude <= departure.latitude
                                    ? destination
                                    : departure,
                            northeast:
                                destination.latitude <= departure.latitude
                                    ? departure
                                    : destination,
                          ),
                          100,
                        ),
                      );
                    },
                  );
                },
                markers: {
                  Marker(
                    markerId: const MarkerId('destination'),
                    position: destination,
                    infoWindow: const InfoWindow(title: '↑'),
                  ),
                  Marker(
                    markerId: const MarkerId('departure'),
                    position: departure,
                    infoWindow: const InfoWindow(title: '↓'),
                  ),
                },
                initialCameraPosition: CameraPosition(
                  target: destination,
                  zoom: 15,
                ),
              ),
            ),
            Material(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.w),
                topRight: Radius.circular(10.w),
              ),
              elevation: 20,
              child: DraggableScrollableSheet(
                expand: false,
                maxChildSize: 0.4,
                initialChildSize: 0.3,
                minChildSize: 0.2,
                builder: (context, scrollController) => ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.w),
                    topRight: Radius.circular(10.w),
                  ),
                  child: ListView(
                    padding: EdgeInsets.only(top: 2.h),
                    controller: scrollController,
                    children: groupedViableRoutes.keys
                        .map(
                          (score) => RadioListTile<double>(
                            groupValue: selectedScore,
                            value: score,
                            dense: true,
                            onChanged: (thisScore) => setState(
                              () => selectedScore = thisScore as double,
                            ),
                            title: RichText(
                              text: TextSpan(
                                children: (groupedViableRoutes[score].toList()
                                        as List<Polyline>)
                                    .map(
                                  (e) {
                                    String s = e.mapsId.value;
                                    if (e != groupedViableRoutes[score].last) {
                                      s += ', ';
                                    }
                                    return TextSpan(
                                      text: s,
                                      style: TextStyle(color: e.color),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
