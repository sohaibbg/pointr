import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CoordFetcher extends StatelessWidget {
  const CoordFetcher({Key? key}) : super(key: key);
  // ignore: prefer_const_constructors
  static LatLng currentLatLng = LatLng(
    24.917784901306725,
    67.09686760394065,
  );
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    FocusNode searchFocus = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'searchField',
          child: Material(
            type: MaterialType.transparency,
            child: TextField(
              controller: controller,
              focusNode: searchFocus,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search address...',
                icon: Icon(Icons.search),
              ),
            ),
          ),
        ),
        leading: const SizedBox(),
      ),
      body: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: const CameraPosition(
              target: LatLng(
                24.917784901306725,
                67.09686760394065,
              ),
              zoom: 15,
            ),
            onCameraMove: (camPos) => currentLatLng = camPos.target,
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 48),
              child: Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 48,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(3.w),
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(currentLatLng),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green[400]),
                padding: MaterialStateProperty.all(
                  EdgeInsets.all(2.h),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: const Icon(Icons.check),
                  ),
                  const Text('Confirm'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
