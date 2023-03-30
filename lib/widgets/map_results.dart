import 'package:flutter/material.dart';
import 'package:pointr/classes/google_place.dart';
import 'package:pointr/classes/located_google_place.dart';
import 'package:pointr/classes/place.dart';
import 'package:sizer/sizer.dart';

class PlaceListview extends StatelessWidget {
  const PlaceListview({
    required this.items,
    required this.onSelected,
    this.padding,
    this.limit,
    super.key,
  });
  final List<GooglePlace> items;
  final EdgeInsets? padding;
  final int? limit;
  final void Function(Place place) onSelected;
  @override
  Widget build(BuildContext context) => items.isEmpty
      ? const SizedBox()
      : Column(
          mainAxisSize: MainAxisSize.min,
          children: items
              .sublist(
                1,
                limit == null
                    ? null
                    : items.length >= limit!
                        ? limit
                        : null,
              )
              .map(
                (item) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      dense: true,
                      contentPadding:
                          padding ?? EdgeInsets.only(left: 10.w, right: 13.w),
                      title: Text(item.title),
                      subtitle: item is LocatedGooglePlace
                          ? Text(item.subtitle)
                          : null,
                      onTap: () => onSelected(item),
                    ),
                    const Divider(thickness: 0),
                  ],
                ),
              )
              .toList(),
        );
}
