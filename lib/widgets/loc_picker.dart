// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:sizer/sizer.dart';
// import '../screens/coord_fetcher.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../classes/star.dart';
// import 'future_builder.dart';

// Column locPicker({
//   required BuildContext context,
//   required Function(LatLng) next,
//   required Function(VoidCallback) stateSetter,
//   List<Widget>? children,
// }) {
//   // Future favoriteFetcher = Star.all;
//   bool editing = false;
//   return Column(
//     children: [
//       // search field
//       Padding(
//         padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 4.h),
//         child: Hero(
//           tag: 'searchField',
//           child: Material(
//             type: MaterialType.transparency,
//             child: TextField(
//               readOnly: true,
//               showCursor: true,
//               decoration: const InputDecoration(
//                 hintText: 'Search address...',
//                 prefixIcon: Icon(Icons.location_on_outlined),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//               onTap: () async {
//                 PermissionStatus locPermStat =
//                     await Permission.location.request();
//                 Navigator.of(context)
//                     .push(
//                   MaterialPageRoute(
//                     builder: (context) => const CoordFetcher(),
//                   ),
//                 )
//                     .then(
//                   (latLng) {
//                     if (latLng != null) {
//                       next(latLng);
//                     }
//                   },
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//       // chips
//       Padding(
//         padding: EdgeInsets.only(
//           left: 8.w,
//           right: 6.w,
//           top: 2.h,
//         ),
//         child: futureBuilder(
//             favoriteFetcher,
//             (data) => StatefulBuilder(
//                   builder: (context, setState) => Wrap(
//                     spacing: 15,
//                     runSpacing: 8,
//                     children: [
//                       const SizedBox(width: double.infinity),
//                       // stored favorites
//                       ...(data as List<Star>).map(
//                         (stop) => editing
//                             ? Chip(
//                                 label: FittedBox(child: Text(stop.name)),
//                                 onDeleted: () async {
//                                   showDialog(
//                                     context: context,
//                                     builder: (ctx) => AlertDialog(
//                                       title: const Text('Confirm Deletion'),
//                                       content: Text(
//                                         'Are you sure you want to delete ${stop.name}?',
//                                       ),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () async {
//                                             Navigator.of(context).pop();
//                                             await stop.delete();
//                                             // favoriteFetcher = Star.favorites();
//                                             stateSetter(() {});
//                                           },
//                                           child: const Text(
//                                             'Confirm Deletion',
//                                             style: TextStyle(color: Colors.red),
//                                           ),
//                                         ),
//                                         TextButton(
//                                           onPressed: () =>
//                                               Navigator.of(context).pop(),
//                                           child: const Text('Return'),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                                 labelPadding: const EdgeInsets.only(
//                                   right: 4,
//                                   left: 12,
//                                   top: 4,
//                                   bottom: 4,
//                                 ),
//                                 backgroundColor: Colors.transparent,
//                                 elevation: 3,
//                               )
//                             : ActionChip(
//                                 label: FittedBox(child: Text(stop.name)),
//                                 onPressed: () => next(stop.latLng),
//                                 avatar: const Icon(Icons.star, size: 20),
//                                 labelPadding: const EdgeInsets.only(
//                                   right: 8,
//                                   top: 4,
//                                   bottom: 4,
//                                 ),
//                                 backgroundColor: Colors.transparent,
//                                 elevation: 3,
//                               ),
//                       ),
//                       // add chip
//                       ActionChip(
//                         // get loc, if not null, save, next function
//                         onPressed: () => Navigator.of(context)
//                             .push(
//                           MaterialPageRoute(
//                             builder: (context) => const CoordFetcher(),
//                           ),
//                         )
//                             .then(
//                           (selected) {
//                             if (selected != null) {
//                               TextEditingController controller =
//                                   TextEditingController();
//                               showDialog(
//                                 context: context,
//                                 barrierDismissible: false,
//                                 builder: (ctx) => AlertDialog(
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () =>
//                                           Navigator.of(context).pop(),
//                                       child: const Text(
//                                         "CANCEL",
//                                         style: TextStyle(color: Colors.red),
//                                       ),
//                                     ),
//                                     TextButton(
//                                       onPressed: () {
//                                         String name = controller.text.trim();
//                                         // if (name.isNotEmpty) {
//                                         //   Star(
//                                         //     0,
//                                         //     name,
//                                         //     selected,
//                                         //   ).then(
//                                         //     (stop) {
//                                         //       // alert the name is in use
//                                         //       if (stop == null) {
//                                         //         showDialog(
//                                         //           context: context,
//                                         //           builder: (_) => AlertDialog(
//                                         //             content: Text(
//                                         //               'You already have a favorite saved by the name of $name. Please try another.',
//                                         //             ),
//                                         //             actions: [
//                                         //               TextButton(
//                                         //                 onPressed: Navigator.of(
//                                         //                         context)
//                                         //                     .pop,
//                                         //                 child: const Text('Ok'),
//                                         //               ),
//                                         //             ],
//                                         //           ),
//                                         //         );
//                                         //       } // pop dialog, reload local favorites
//                                         //       else {
//                                         //         favoriteFetcher =
//                                         //             Star.favorites();
//                                         //         stateSetter(() {});
//                                         //         Navigator.of(context).pop();
//                                         //       }
//                                         //     },
//                                         //   );
//                                         // }
//                                       },
//                                       child: const Text(
//                                         "CONFIRM",
//                                         // style: TextStyle(color: Colors.red),
//                                       ),
//                                     ),
//                                   ],
//                                   content: TextField(
//                                     controller: controller,
//                                     decoration: const InputDecoration(
//                                         hintText: 'Enter Name...'),
//                                   ),
//                                 ),
//                               );
//                               // Star.setFavorite(
//                               //   'name',
//                               //   (selected as LatLng).latitude,
//                               //   selected.longitude,
//                               // ).then((stop) {
//                               //   if (stop != null) {
//                               //     next(stop.latLng);
//                               //   }
//                               // });
//                             }
//                           },
//                         ),
//                         label: const FittedBox(child: Text('add')),
//                         avatar: const Icon(Icons.add),
//                         labelPadding: const EdgeInsets.only(
//                           right: 8,
//                           top: 4,
//                           bottom: 4,
//                         ),
//                         backgroundColor: Colors.transparent,
//                         elevation: 3,
//                       ),
//                       // edit chip
//                       ActionChip(
//                         shape: StadiumBorder(
//                           side: BorderSide(
//                             color: editing ? Colors.red : Colors.transparent,
//                           ),
//                         ),
//                         onPressed: () => setState(() => editing = !editing),
//                         label: FittedBox(
//                           child: Text(
//                             editing ? 'Stop Editing' : 'Edit',
//                           ),
//                         ),
//                         avatar: Icon(
//                           Icons.edit,
//                           color: editing ? Colors.red : null,
//                           size: 20,
//                         ),
//                         labelPadding: const EdgeInsets.only(
//                           right: 8,
//                           top: 4,
//                           bottom: 4,
//                         ),
//                         backgroundColor: Colors.transparent,
//                         elevation: 3,
//                       )
//                     ],
//                   ),
//                 ),
//             []),
//       ),
//       children == null ? const SizedBox() : Column(children: children),
//     ],
//   );
// }
