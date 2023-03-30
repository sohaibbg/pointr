// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pointr/my_theme.dart';
// import 'package:sizer/sizer.dart';

// class Routes extends StatelessWidget {
//   const Routes({super.key});
//   void addRoute() {
//     TextEditingController nameController = TextEditingController();
//     Get.dialog(
//       AlertDialog(
//         title: const Text("New Route"),
//         content: TextField(
//           decoration: const InputDecoration(
//             filled: true,
//             hintText: 'Name...',
//           ),
//           controller: nameController,
//         ),
//         actions: [
//           TextButton(
//             onPressed: Navigator.of(context).pop,
//             child: const Text("CANCEL"),
//           ),
//           TextButton(
//             onPressed: () {
//               if (nameController.text.isNotEmpty) {
//                 // Get.to(() => AddRoute(name: nameController.text));
//               }
//             },
//             child: const Text(
//               "CREATE NEW ROUTE",
//               style: TextStyle(color: Colors.amber),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Image.asset(
//           'assets/images/geometric pattern.png',
//           fit: BoxFit.fitWidth,
//           alignment: Alignment.topCenter,
//           color: Colors.amber,
//         ),
//         ListView(
//           children: [
//             // title
//             Padding(
//               padding: EdgeInsets.only(
//                 top: 15.h,
//                 left: 7.w,
//                 right: 7.w,
//                 bottom: 2.h,
//               ),
//               child: const Text(
//                 //  TO-DO fix font
//                 "Explore and Add New Routes",
//                 style: MyTheme.heading1,
//               ),
//             ),
//             // button (add a new route)
//             Padding(
//               padding: EdgeInsets.only(left: 7.w, right: 7.w, bottom: 30),
//               child: ElevatedButton(
//                 onPressed: addRoute,
//                 style: MyTheme.elevatedButtonStyle.copyWith(
//                   padding: const MaterialStatePropertyAll(
//                     EdgeInsets.symmetric(vertical: 20),
//                   ),
//                 ),
//                 child: const Text("Add a New Route"),
//               ),
//             )
//             // starred
//             // routes near me
//           ],
//         ),
//       ],
//     );
//   }
// }
