import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pointr/classes/gmaps_api.dart';
import 'package:pointr/classes/star.dart';
import 'package:pointr/my_theme.dart';
import 'package:pointr/widgets/horizontal_chip_scroller.dart';
import 'package:pointr/widgets/map_results.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:sizer/sizer.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  static LatLng? currentLatLng;
  static final FocusNode focusNode = FocusNode();
  Future<Iterable<Map>?> suggestions() async {
    // check permission
    if (await Permission.location.request() == PermissionStatus.denied) {
      return null;
    }
    // get location
    Position p = await Geolocator.getCurrentPosition();
    currentLatLng = LatLng(p.latitude, p.longitude);
    // return results
    return await GMapsApi.nearbyPlaces(currentLatLng!);
  }

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          // backdrop
          Image.asset(
            'assets/images/geometric pattern.png',
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
          // foreground
          ListView(
            children: [
              // title
              Padding(
                padding: EdgeInsets.only(
                  top: 15.h,
                  left: 7.w,
                  right: 7.w,
                  bottom: 2.h,
                ),
                child: const Text(
                  "Where are you currently?",
                  style: MyTheme.heading1,
                ),
              ),
              // textfield
              Padding(
                padding: EdgeInsets.fromLTRB(7.w, 0, 7.w, 2.h),
                child: TextField(
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    prefixIcon:
                        Icon(Icons.search, color: MyTheme.colorSecondaryDark),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyTheme.colorSecondaryDark),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyTheme.colorSecondaryDark),
                    ),
                    hintText: 'Enter Destination...',
                    filled: true,
                    fillColor: MyTheme.colorSecondaryLight,
                    hintStyle:
                        TextStyle(color: MyTheme.colorSecondaryDarkAccent),
                  ),
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => SetFromTo(
                    //       initialLatLng: currentLatLng,
                    //     ),
                    //   ),
                    // );
                    focusNode.unfocus();
                  },
                ),
              ),
              // starred
              FutureBuilder(
                future: Star.updateAll(),
                builder: (context, snapshot) => snapshot.connectionState ==
                        ConnectionState.done
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: HorizontalChipScroller(
                          height: 6.h,
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          items: Star.all,
                          onSelected: (_) {},
                        ),
                      )
                    : const SizedBox(),
              ),
              // suggestions
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.bounceIn,
                child: FutureBuilder(
                  future: suggestions(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? JumpingDotsProgressIndicator(fontSize: 36)
                          : snapshot.data == null
                              ? const SizedBox()
                              : MapResults(
                                  items: (snapshot.data! as Iterable).toList()
                                      as Iterable<Map>,
                                  onSelected: (_) {},
                                  limit: 5,
                                ),
                ),
              )
            ],
          ),
        ],
      );
}
