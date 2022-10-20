import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointr/classes/viable_route.dart';
import 'package:pointr/my_theme.dart';
import 'package:sizer/sizer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../classes/catalogue.dart';

class DisplayRoutes extends StatefulWidget {
  const DisplayRoutes({
    Key? key,
    required this.fromLatLng,
    required this.fromName,
    required this.toLatLng,
    required this.toName,
  }) : super(key: key);

  final LatLng fromLatLng;
  final String fromName;
  final LatLng toLatLng;
  final String toName;

  @override
  State<DisplayRoutes> createState() => _DisplayRoutesState();
}

class _DisplayRoutesState extends State<DisplayRoutes> {
  static final Completer<GoogleMapController> _controller = Completer();
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
        .map((route) =>
            ViableRoute.between(widget.fromLatLng, widget.toLatLng, route))
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
        appBar: AppBar(
          backgroundColor: MyTheme.colorPrimary,
          toolbarHeight: 16.h,
          leadingWidth: 0,
          titleSpacing: 0,
          // appbar bg img
          flexibleSpace: Image.asset(
            'assets/images/geometric pattern.png',
            fit: BoxFit.fitWidth,
            // repeat: ImageRepeat.repeat,
            color: Colors.white,
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: Get.back,
            icon: const Icon(Icons.arrow_back),
          ),
          title: Column(
            children: [
              // from
              Padding(
                padding: const EdgeInsets.only(
                    right: 16, bottom: 8, left: 48, top: 4),
                child: TextField(
                  enabled: false,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    fillColor: MyTheme.colorPrimaryLight,
                    filled: true,
                    enabled: false,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(99),
                      ),
                    ),
                    hintText: widget.fromName,
                    hintStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(top: 16, left: 20, right: 15),
                      child: Text(
                        'FROM',
                        textScaleFactor: 0.6,
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ),
              // to
              Padding(
                padding: const EdgeInsets.only(
                    right: 16, bottom: 8, left: 48, top: 4),
                child: TextField(
                  enabled: false,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    fillColor: MyTheme.colorPrimaryLight,
                    filled: true,
                    enabled: false,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(99),
                      ),
                    ),
                    hintText: widget.toName,
                    hintStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(top: 16, left: 20, right: 15),
                      child: Text(
                        'TO',
                        textScaleFactor: 0.6,
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
                            southwest: widget.toLatLng.latitude <=
                                    widget.fromLatLng.latitude
                                ? widget.toLatLng
                                : widget.fromLatLng,
                            northeast: widget.toLatLng.latitude <=
                                    widget.fromLatLng.latitude
                                ? widget.fromLatLng
                                : widget.toLatLng,
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
                    position: widget.toLatLng,
                    infoWindow: const InfoWindow(title: '↑'),
                  ),
                  Marker(
                    markerId: const MarkerId('departure'),
                    position: widget.fromLatLng,
                    infoWindow: const InfoWindow(title: '↓'),
                  ),
                },
                initialCameraPosition: CameraPosition(
                  target: widget.toLatLng,
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
