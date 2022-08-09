import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointr/classes/catalogue.dart';
import 'package:pointr/classes/favorite.dart';
import 'package:pointr/classes/viable_route.dart';
import 'package:pointr/screens/destination.dart';

import '../utils.dart';
import '../widgets/loc_picker.dart';
import 'display_routes.dart';

class Departure extends StatefulWidget {
  const Departure({Key? key, this.destination}) : super(key: key);
  final LatLng? destination;

  @override
  State<Departure> createState() => _DepartureState();
}

class _DepartureState extends State<Departure> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [
            locPicker(
                context: context,
                stateSetter: setState,
                next: (departure) async {
                  // if you have destination, fetch routes
                  if (widget.destination != null) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (ctx) => const Dialog(
                        child: LinearProgressIndicator(),
                      ),
                    );
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => DisplayRoutes(
                          destination: widget.destination!,
                          departure: departure,
                        ),
                      ),
                    );
                  }
                  // else fetch destination
                  else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => Destination(
                          departure: departure,
                        ),
                      ),
                    );
                  }
                }),
          ],
        ),
      );
}
