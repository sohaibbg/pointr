import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MapResults extends StatelessWidget {
  const MapResults({
    required this.items,
    required this.onSelected,
    this.padding,
    this.limit,
    super.key,
  });
  final Iterable<Map> items;
  final EdgeInsets? padding;
  final int? limit;
  final void Function(Map map) onSelected;
  @override
  Widget build(BuildContext context) => items.isEmpty
      ? const SizedBox()
      : Column(
          mainAxisSize: MainAxisSize.min,
          children: items
              .toList()
              .sublist(
                  1,
                  limit == null
                      ? null
                      : items.length >= limit!
                          ? limit
                          : null)
              .map(
                (item) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      dense: true,
                      contentPadding:
                          padding ?? EdgeInsets.only(left: 10.w, right: 13.w),
                      title: Text(item['title']),
                      subtitle: item.containsKey('subtitle')
                          ? Text(item['subtitle'])
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
