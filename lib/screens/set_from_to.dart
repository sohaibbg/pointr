// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:pointr/classes/google_api.dart';
// import 'package:pointr/classes/google_place.dart';
// import 'package:pointr/classes/star.dart';
// import 'package:pointr/my_theme.dart';
// import 'package:pointr/providers/from_provider.dart';
// import 'package:pointr/providers/to_provider.dart';
// import 'package:pointr/widgets/horizontal_chip_scroller.dart';
// import 'package:pointr/widgets/map_results.dart';
// import 'package:progress_indicators/progress_indicators.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';

// class SetFromTo extends StatefulWidget {
//   const SetFromTo({this.initialLatLng, super.key});
//   final LatLng? initialLatLng;
//   @override
//   State<SetFromTo> createState() => _SetFromToState();
// }

// class _SetFromToState extends State<SetFromTo> {
//   static List<Star> filteredStars = Star.all;
//   static final FocusNode searchFocus = FocusNode();
//   static final TextEditingController searchController = TextEditingController();
//   static late Future<List<GooglePlace>> searchFuture;
//   static final Completer<GoogleMapController> mapController = Completer();
//   late final Widget gMap;
//   static bool isKeyboardVisibleLV = false;

//   @override
//   void dispose() {
//     searchController.clear();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     searchFuture = GoogleApi.autocomplete("");
//     gMap = GoogleMap(
//       padding: const EdgeInsets.only(bottom: 100),
//       onMapCreated: (GoogleMapController controller) =>
//           mapController.complete(controller),
//       initialCameraPosition: CameraPosition(
//         target: widget.initialLatLng ?? const LatLng(24.860966, 66.990501),
//         zoom: 15,
//       ),
//       myLocationEnabled: true,
//       onTap: onMapTapped,
//       onCameraIdle: onMapIdle,
//       onCameraMoveStarted: () => searchController.text = "",
//     );
//   }

//   onMapTapped(_) {
//     if (!isKeyboardVisibleLV) searchController.clear();
//   }

//   onMapIdle() async {
//     LatLng latLng = await getLatLng();
//     GoogleApi.nameFromLatLng(latLng).then((s) {
//       if (!isKeyboardVisibleLV) {
//         searchController.text = s;
//       }
//     });
//   }

//   void onLocSelected(LatLng latLng) {
//     searchFocus.unfocus();
//     mapController.future.then(
//       (controller) {
//         controller.animateCamera(
//           CameraUpdate.newLatLngZoom(latLng, 17),
//         );
//       },
//     );
//   }

//   void onStar(LatLng latLng) => showDialog(
//         context: context,
//         builder: (context) {
//           TextEditingController controller = TextEditingController();
//           return AlertDialog(
//             content: TextField(
//               autofocus: true,
//               controller: controller,
//               decoration: const InputDecoration(
//                 labelText: 'Star Name',
//                 prefixIcon: Icon(Icons.star_border),
//               ),
//             ),
//             actions: [
//               TextButton(
//                   onPressed: Navigator.of(context).pop,
//                   child: const Text("CANCEL")),
//               TextButton(
//                 onPressed: () async {
//                   Navigator.of(context).pop();
//                   searchFocus.unfocus();
//                   await Star(-1, controller.text, latLng).create();
//                   Star.readAll();
//                 },
//                 style: const ButtonStyle(
//                   foregroundColor:
//                       MaterialStatePropertyAll(MyTheme.colorSecondary),
//                 ),
//                 child: const Text("CREATE NEW STAR"),
//               )
//             ],
//           );
//         },
//       );

//   Future<LatLng> getLatLng() async {
//     GoogleMapController mc = await mapController.future;
//     LatLngBounds bounds = await mc.getVisibleRegion();
//     return LatLng((bounds.northeast.latitude + bounds.southwest.latitude) / 2,
//         (bounds.northeast.longitude + bounds.southwest.longitude) / 2);
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: KeyboardVisibilityBuilder(
//           builder: (context, isKeyboardVisible) =>
//               Consumer2<FromProvider, ToProvider>(
//             builder: (context, fromProvider, toProvider, child) {
//               FutureOr<void> onNext(LatLng latLng) async {
//                 if (fromProvider.selected == null) {
//                   fromProvider.select(
//                     latLng: latLng,
//                     name: await GoogleApi.nameFromLatLng(latLng),
//                   );
//                 } else {
//                   toProvider.select(
//                     latLng: latLng,
//                     name: await GoogleApi.nameFromLatLng(latLng),
//                   );
//                   // Get.to(
//                   //   () => DisplayRoutes(
//                   //     fromProvider.selected: fromProvider.selected!,
//                   //     fromName: fromName!,
//                   //     toLatLng: latLng,
//                   //     toName: toName,
//                   //   ),
//                   // );
//                 }
//               }

//               return AppBar(
//                 backgroundColor: MyTheme.colorPrimary,
//                 toolbarHeight: 10.h +
//                     (fromProvider.selected == null || isKeyboardVisible
//                         ? 0
//                         : 8.h),
//                 leadingWidth: 0,
//                 titleSpacing: 0,
//                 automaticallyImplyLeading: false,
//                 // appbar bg img
//                 flexibleSpace: Image.asset(
//                   'assets/images/geometric pattern.png',
//                   fit: BoxFit.fitWidth,
//                   // repeat: ImageRepeat.repeat,
//                   color: Colors.white,
//                 ),
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     // FROM is set, its descriptor
//                     if (fromProvider.selected != null && !isKeyboardVisibleLV)
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             right: 16, bottom: 8, left: 48, top: 4),
//                         child: TextField(
//                           enabled: false,
//                           textAlignVertical: TextAlignVertical.center,
//                           decoration: InputDecoration(
//                             fillColor: MyTheme.colorPrimaryLight,
//                             filled: true,
//                             enabled: false,
//                             isDense: true,
//                             contentPadding: EdgeInsets.zero,
//                             border: const OutlineInputBorder(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(99),
//                               ),
//                             ),
//                             hintText: fromProvider.name,
//                             hintStyle: const TextStyle(color: Colors.white),
//                             prefixIcon: const Padding(
//                               padding:
//                                   EdgeInsets.only(top: 16, left: 20, right: 15),
//                               child: Text(
//                                 'FROM',
//                                 textScaleFactor: 0.6,
//                                 style: TextStyle(fontWeight: FontWeight.w900),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     // back button, search field
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         // search title
//                         Padding(
//                           padding:
//                               EdgeInsets.only(left: 56 + 1.w, bottom: 0.5.h),
//                           child: Text(
//                             fromProvider.selected == null
//                                 ? "LEAVING FROM"
//                                 : "GOING TO",
//                             style: MyTheme.subtitle,
//                           ),
//                         ),
//                         // back button, search field
//                         Padding(
//                           padding: const EdgeInsets.only(right: 16, bottom: 8),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               // back button
//                               IconButton(
//                                 onPressed: Navigator.of(context).pop,
//                                 icon: const Icon(Icons.arrow_back),
//                               ),
//                               // search field
//                               Flexible(
//                                 child: TextField(
//                                   autofocus: true,
//                                   controller: searchController,
//                                   focusNode: searchFocus,
//                                   onTap: () {
//                                     if (!isKeyboardVisible) {
//                                       searchController.clear();
//                                     }
//                                   },
//                                   // clear all button
//                                   decoration:
//                                       MyTheme.addressFieldStyle.copyWith(
//                                     suffixIcon: IconButton(
//                                       onPressed: searchController.clear,
//                                       icon: const Icon(Icons.clear),
//                                     ),
//                                   ),
//                                   // search functionality
//                                   onChanged: (searchTerm) => setState(
//                                     () {
//                                       searchFuture =
//                                           GoogleApi.autocomplete(searchTerm);
//                                       if (searchTerm.isEmpty) {
//                                         filteredStars = Star.all;
//                                       } else {
//                                         filteredStars = Star.all
//                                             .where(
//                                               (star) => star.name
//                                                   .toLowerCase()
//                                                   .trim()
//                                                   .contains(
//                                                     searchTerm
//                                                         .toLowerCase()
//                                                         .trim(),
//                                                   ),
//                                             )
//                                             .toList();
//                                       }
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ) as AppBar,
//         body: Stack(
//           children: [
//             // map, buttons
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 // map
//                 gMap,
//                 // location pin icon
//                 const Padding(
//                   padding: EdgeInsets.only(bottom: 56),
//                   child: Icon(
//                     Icons.location_on,
//                     color: MyTheme.colorPrimary,
//                     size: 56,
//                     shadows: [Shadow(offset: Offset(0.1, 0.9), blurRadius: 6)],
//                   ),
//                 ),
//                 // buttons
//                 if (!(isKeyboardVisibleLV && searchFocus.hasFocus))
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Padding(
//                       padding: EdgeInsets.all(5.w),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           // new star button
//                           Expanded(
//                             flex: 5,
//                             child: Padding(
//                               padding: const EdgeInsets.only(right: 16),
//                               child: ElevatedButton.icon(
//                                 icon: const Icon(Icons.star),
//                                 onPressed: () async {
//                                   onStar(await getLatLng());
//                                 },
//                                 label: const Text(
//                                   "Star",
//                                   style: TextStyle(fontWeight: FontWeight.w900),
//                                 ),
//                                 style: MyTheme.outlineButtonStyle.copyWith(
//                                   elevation: const MaterialStatePropertyAll(5),
//                                   padding: const MaterialStatePropertyAll(
//                                     EdgeInsets.only(
//                                       top: 18,
//                                       bottom: 18,
//                                       left: 12,
//                                       right: 24,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           // next button
//                           Expanded(
//                             flex: 7,
//                             child: ElevatedButton.icon(
//                               icon: const Icon(Icons.arrow_forward),
//                               onPressed: () async {},
//                               // onPressed: () async => onNext(await getLatLng()),
//                               label: const Text("Next"),
//                               style: const ButtonStyle(
//                                 elevation: MaterialStatePropertyAll(5),
//                                 backgroundColor: MaterialStatePropertyAll(
//                                     MyTheme.colorPrimary),
//                                 padding: MaterialStatePropertyAll(
//                                   EdgeInsets.only(
//                                     top: 18,
//                                     bottom: 18,
//                                     left: 12,
//                                     right: 24,
//                                   ),
//                                 ),
//                                 shape:
//                                     MaterialStatePropertyAll(StadiumBorder()),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//               ],
//             ),
//             // search overlay
//             if (isKeyboardVisibleLV && searchFocus.hasFocus)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 40),
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: Material(
//                         elevation: 10,
//                         child: ListView(
//                           children: [
//                             AnimatedSize(
//                               duration: const Duration(milliseconds: 300),
//                               child: HorizontalChipScroller(
//                                 height: filteredStars.isEmpty ? 0 : 5.5.h + 32,
//                                 items: filteredStars,
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 16, horizontal: 20),
//                                 onSelected: (Star star) {
//                                   searchController.text = star.title;
//                                   return onLocSelected(star.latLng);
//                                 },
//                               ),
//                             ),
//                             // GMap search results
//                             FutureBuilder<List<GooglePlace>>(
//                               future: searchFuture,
//                               builder: (context, snapshot) => snapshot
//                                           .connectionState ==
//                                       ConnectionState.waiting
//                                   // loading
//                                   ? JumpingDotsProgressIndicator(
//                                       fontSize: 80,
//                                     )
//                                   : searchController.text.isEmpty
//                                       // type something
//                                       ? Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                 top: 50,
//                                                 bottom: 22,
//                                               ),
//                                               child: Image.asset(
//                                                 'assets/images/cursor.png',
//                                                 opacity:
//                                                     const AlwaysStoppedAnimation(
//                                                         0.5),
//                                               ),
//                                             ),
//                                             const Text(
//                                               "Type in the search bar to get suggestions.",
//                                             ),
//                                           ],
//                                         )
//                                       : snapshot.hasData
//                                           ? snapshot.data!.isEmpty
//                                               // no results found
//                                               ? Column(
//                                                   children: [
//                                                     const Padding(
//                                                       padding: EdgeInsets.only(
//                                                           top: 60, bottom: 24),
//                                                       child: RotatedBox(
//                                                         quarterTurns: 1,
//                                                         child: Text(
//                                                           ":(",
//                                                           textScaleFactor: 4,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                         "No results for \"${searchController.text}\"")
//                                                   ],
//                                                 )
//                                               // show results
//                                               : Padding(
//                                                   padding: filteredStars.isEmpty
//                                                       ? const EdgeInsets.only(
//                                                           top: 12.0)
//                                                       : EdgeInsets.zero,
//                                                   child: PlaceListview(
//                                                     items: snapshot.data!,
//                                                     onSelected: (map) {
//                                                       searchFocus.unfocus();
//                                                       GoogleApi
//                                                               .latLngFromPlaceId(
//                                                                   map.placeId)
//                                                           .then((latLng) =>
//                                                               onLocSelected(
//                                                                   latLng));
//                                                     },
//                                                     padding: const EdgeInsets
//                                                             .symmetric(
//                                                         horizontal: 24),
//                                                   ),
//                                                 )
//                                           : const SizedBox(),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       );
// }
