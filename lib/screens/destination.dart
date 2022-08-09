import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointr/screens/departure.dart';
import 'package:sizer/sizer.dart';

import '../widgets/loc_picker.dart';
import 'display_routes.dart';

class Destination extends StatefulWidget {
  const Destination({Key? key, this.departure}) : super(key: key);
  final LatLng? departure;
  @override
  State<Destination> createState() => _DestinationState();
}

class _DestinationState extends State<Destination> {
  Map<String, String> guide = {
    '1.':
        'When getting off the bus, make sure to look in the rear and ensure there is sufficient space to get off. Disembark whilst holding the vertical rod to the side of the door, otherwise you may lose your balance if you jump from a bus that is not completely stationary.',
  };
  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor:
                  Colors.transparent, // Color.fromARGB(255, 185, 108, 106),
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  'assets/truck art.png',
                  fit: BoxFit.cover,
                  // height: 100.h -
                  //     kBottomNavigationBarHeight -
                  //     kToolbarHeight -
                  //     kTextTabBarHeight,
                  // color: Colors.white.withOpacity(0.15),
                  colorBlendMode: BlendMode.modulate,
                ),
                title: const Text('Where to?'),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  locPicker(
                    context: context,
                    stateSetter: setState,
                    next: (stop) {
                      // if you have departure, fetch routes
                      if (widget.departure != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => DisplayRoutes(
                              destination: stop,
                              departure: widget.departure!,
                            ),
                          ),
                        );
                      }
                      // else fetch departure
                      else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => Departure(
                              destination: stop,
                            ),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      );
}
