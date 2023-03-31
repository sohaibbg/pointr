import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointr/my_theme.dart';
import 'package:pointr/providers/nearby_provider.dart';
import 'package:pointr/providers/star_provider.dart';
import 'package:pointr/screens/set_points_view_routes.dart';
import 'package:pointr/widgets/horizontal_chip_scroller.dart';
import 'package:pointr/widgets/map_results.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  static LatLng? currentLatLng;
  static final FocusNode focusNode = FocusNode();

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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SetPointsViewRoutes(
                          initialLatLng: currentLatLng,
                        ),
                      ),
                    );
                    focusNode.unfocus();
                  },
                ),
              ),
              // starred
              Consumer<StarProvider>(
                builder: (context, starProvider, child) => starProvider
                        .all.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: HorizontalChipScroller(
                          height: 6.h,
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          items: starProvider.all,
                          onSelected: (_) {},
                        ),
                      )
                    : const SizedBox(),
              ),
              // suggestions
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.bounceIn,
                child: Consumer<NearbyProvider>(
                  builder: (context, nearbyProvider, child) =>
                      nearbyProvider.suggestions == null
                          ? const SizedBox()
                          : PlaceListview(
                              items: nearbyProvider.suggestions!,
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
