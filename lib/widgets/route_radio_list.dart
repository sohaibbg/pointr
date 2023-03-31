import 'package:flutter/material.dart';
import 'package:pointr/providers/route_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouterRadioList extends StatelessWidget {
  const RouterRadioList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Material(
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
            child: Consumer<RouteProvider>(
              builder: (context, routeProvider, child) => ListView(
                padding: EdgeInsets.only(top: 2.h),
                controller: scrollController,
                children: routeProvider.all.entries
                    .map(
                      (score) => RadioListTile<double>(
                        groupValue: routeProvider.selectedScore,
                        value: score.key,
                        dense: true,
                        onChanged: (thisScore) =>
                            routeProvider.selectedScore = thisScore!,
                        title: RichText(
                          text: TextSpan(
                            children: (routeProvider.all[score.key]?.toList()
                                    as List<Polyline>)
                                .map(
                              (e) {
                                String s = e.mapsId.value;
                                if (e != routeProvider.all[score]?.last) {
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
      );
}
