import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointr/classes/gmaps_api.dart';
import 'package:pointr/classes/star.dart';
import 'package:pointr/my_theme.dart';
import 'package:pointr/widgets/horizontal_chip_scroller.dart';
import 'package:pointr/widgets/map_results.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:sizer/sizer.dart';

class LocSetter extends StatefulWidget {
  const LocSetter({this.initialLatLng, super.key});
  final LatLng? initialLatLng;
  @override
  State<LocSetter> createState() => _LocSetterState();
}

class _LocSetterState extends State<LocSetter> {
  static List<Star> filteredStars = Star.all;
  static final FocusNode searchFocus = FocusNode();
  static final TextEditingController searchController = TextEditingController();
  static late Future searchFuture;
  static final Completer<GoogleMapController> mapController = Completer();
  static LatLng? fromLatLng;
  static String? fromName;

  @override
  void initState() {
    super.initState();
    searchFuture = GMapsApi.autocomplete("");
  }

  void onLocSelected(LatLng latLng) {
    searchFocus.unfocus();
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
              TextButton(onPressed: Get.back, child: const Text("CANCEL")),
              TextButton(
                onPressed: () async {
                  Get.back();
                  searchFocus.unfocus();
                  await Star(Star.nextId, controller.text, latLng).insert();
                  Star.updateAll();
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

  void onNext(LatLng latLng) async {
    if (fromLatLng == null) {
      fromLatLng = latLng;
      fromName = await GMapsApi.nameFromLatLng(latLng);
      setState(() {});
    } else {}
  }

  Future<LatLng> getLatLng() async {
    GoogleMapController mc = await mapController.future;
    LatLngBounds bounds = await mc.getVisibleRegion();
    return LatLng((bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2);
  }

  @override
  Widget build(BuildContext context) {
    final Widget fromAppBarContents = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // subtitle
        Padding(
          padding: EdgeInsets.only(left: 56 + 1.w, bottom: 0.5.h),
          child: const Text(
            "LEAVING FROM",
            style: MyTheme.subtitle,
          ),
        ),
        // textfield
        Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: Get.back,
                icon: const Icon(Icons.arrow_back),
              ),
              Flexible(
                child: TextField(
                  autofocus: true,
                  controller: searchController,
                  focusNode: searchFocus,
                  decoration: MyTheme.addressFieldStyle,
                  onChanged: (searchTerm) => setState(
                    () {
                      searchFuture = GMapsApi.autocomplete(searchTerm);
                      if (searchTerm.isEmpty) {
                        filteredStars = Star.all;
                      } else {
                        filteredStars = Star.all
                            .where(
                              (star) => star.name
                                  .toLowerCase()
                                  .removeAllWhitespace
                                  .contains(searchTerm
                                      .toLowerCase()
                                      .removeAllWhitespace),
                            )
                            .toList();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
    final Widget toAppBarContents = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // textfield
        Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: Get.back,
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
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
                    hintText: fromName,
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 20, right: 15),
                      child: Text(
                        'FROM',
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
      ],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.colorPrimary,
        toolbarHeight: 10.h,
        leadingWidth: 0,
        titleSpacing: 0,
        flexibleSpace: Image.asset(
          'assets/images/geometric pattern.png',
          fit: BoxFit.fitWidth,
          // repeat: ImageRepeat.repeat,
          color: Colors.white,
        ),
        automaticallyImplyLeading: false,
        title: fromLatLng == null ? fromAppBarContents : toAppBarContents,
      ),
      body: KeyboardVisibilityBuilder(
        builder: (p0, isKeyboardVisible) => Stack(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  padding: EdgeInsets.only(bottom: 15.h),
                  onMapCreated: (GoogleMapController controller) {
                    mapController.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: widget.initialLatLng ??
                        const LatLng(24.860966, 66.990501),
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                  onCameraIdle: () async {
                    LatLng latLng = await getLatLng();
                    searchController.text =
                        await GMapsApi.nameFromLatLng(latLng);
                  },
                  onCameraMoveStarted: () => searchController.text = "",
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 56),
                  child: Icon(
                    Icons.location_on,
                    color: MyTheme.colorPrimary,
                    size: 56,
                    shadows: [Shadow(offset: Offset(0.1, 0.9), blurRadius: 6)],
                  ),
                ),
                // buttons
                if (!(isKeyboardVisible && searchFocus.hasFocus))
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(5.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // new star button
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.star_border),
                                onPressed: () async {
                                  onStar(await getLatLng());
                                },
                                label: const Text("Star"),
                                style: MyTheme.outlineButtonStyle.copyWith(
                                  padding: const MaterialStatePropertyAll(
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
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: () async => onNext(await getLatLng()),
                              label: const Text("Next"),
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    MyTheme.colorPrimary),
                                padding: MaterialStatePropertyAll(
                                  EdgeInsets.only(
                                    top: 18,
                                    bottom: 18,
                                    left: 12,
                                    right: 24,
                                  ),
                                ),
                                shape:
                                    MaterialStatePropertyAll(StadiumBorder()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
            if (isKeyboardVisible && searchFocus.hasFocus)
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    Expanded(
                      child: Material(
                        elevation: 10,
                        child: ListView(
                          children: [
                            // chip scroller
                            if (filteredStars.isNotEmpty)
                              SizedBox(
                                height: 5.5.h + 32,
                                width: 200,
                                child: HorizontalChipScroller(
                                  items: filteredStars,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 20),
                                  onSelected: (Star star) {
                                    searchController.text = star.name;
                                    return onLocSelected(star.latLng);
                                  },
                                ),
                              ),
                            // GMap search results
                            FutureBuilder(
                              future: searchFuture,
                              builder: (context, snapshot) => snapshot
                                          .connectionState ==
                                      ConnectionState.waiting
                                  ? JumpingDotsProgressIndicator(
                                      fontSize: 80,
                                    )
                                  : searchController.text.isEmpty
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 50,
                                                bottom: 22,
                                              ),
                                              child: Image.asset(
                                                'assets/images/cursor.png',
                                                opacity:
                                                    const AlwaysStoppedAnimation(
                                                        0.5),
                                              ),
                                            ),
                                            const Text(
                                              "Type in the search bar to get suggestions.",
                                            ),
                                          ],
                                        )
                                      : snapshot.hasData
                                          ? (snapshot.data as Iterable).isEmpty
                                              ? Column(
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 60, bottom: 24),
                                                      child: RotatedBox(
                                                        quarterTurns: 1,
                                                        child: Text(
                                                          ":(",
                                                          textScaleFactor: 4,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                        "No results for \"${searchController.text}\"")
                                                  ],
                                                )
                                              : Padding(
                                                  padding: filteredStars.isEmpty
                                                      ? const EdgeInsets.only(
                                                          top: 12.0)
                                                      : EdgeInsets.zero,
                                                  child: MapResults(
                                                    items: snapshot.data
                                                        as Iterable<Map>,
                                                    onSelected: (map) {
                                                      print(map);
                                                      searchFocus.unfocus();
                                                      GMapsApi.latLngFromPlaceId(
                                                              map['place_id'])
                                                          .then((latLng) =>
                                                              onLocSelected(
                                                                  latLng));
                                                    },
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 24),
                                                  ),
                                                )
                                          : const SizedBox(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
