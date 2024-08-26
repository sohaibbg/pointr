import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../../config/my_theme.dart';
import '../../domain/entities/route_entity.dart';
import 'space.dart';

class RoutesLegendListView extends StatelessWidget {
  const RoutesLegendListView(
    this.segments, {
    super.key,
    this.onScrollToNewSegment,
  });

  final List<Set<RouteEntity>> segments;
  final void Function(int index)? onScrollToNewSegment;

  static const colorLegend = [
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.green,
  ];

  static const _height = 165.0;
  static const _tileWidth = 300.0;

  Widget _tileBuilder(
    int index,
    RouteEntity route,
  ) {
    final coloredBox = ColoredBox(
      color: colorLegend[index],
      child: const SizedBox(
        width: 14,
        height: double.infinity,
      ),
    );
    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          route.name,
          style: MyTheme.body,
        ),
        Text(
          route.mode.name.toUpperCase(),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ],
    );
    return Row(
      children: [
        coloredBox,
        12.horizontalSpace,
        Expanded(
          child: textColumn,
        ),
        9.horizontalSpace,
      ],
    );
  }

  Widget _segmentCardBuilder(
    BuildContext context,
    int index,
  ) {
    final tiles = <Widget>[];
    final segment = segments[index];
    for (int i = 0; i < segment.length; i += 2) {
      final leftRoute = segment.elementAt(i);
      final leftTile = _tileBuilder(
        i,
        leftRoute,
      );
      final hasNextElement = i + 1 < segment.length;
      final rightTile = hasNextElement
          ? _tileBuilder(
              i + 1,
              segment.elementAt(i + 1),
            )
          : null;
      tiles.add(
        SizedBox(
          height: _height / 2,
          child: Row(
            children: [
              Expanded(child: leftTile),
              Expanded(
                child: rightTile ?? const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    }
    final cardContent = Column(
      children: tiles
        ..insert(
          1,
          Divider(
            height: 0,
            color: MyTheme.primaryColor,
          ),
        ),
    );
    return SizedBox(
      width: _tileWidth,
      height: _height,
      child: Card(
        clipBehavior: Clip.hardEdge,
        color: Colors.indigo.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        margin: EdgeInsets.zero,
        child: cardContent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: _height,
        child: ScrollSnapList(
          focusOnItemTap: true,
          scrollPhysics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.fast,
          ),
          margin: EdgeInsets.zero,
          itemCount: segments.length,
          onItemFocus: onScrollToNewSegment ?? (_) {},
          clipBehavior: Clip.none,
          padding: EdgeInsets.zero,
          itemSize: _tileWidth,
          scrollDirection: Axis.horizontal,
          duration: kThemeAnimationDuration.inMilliseconds,
          dynamicItemSize: true,
          dynamicSizeEquation: (distance) => 1 - min(distance.abs() / 500, 0.2),
          itemBuilder: _segmentCardBuilder,
        ),
      );
}
