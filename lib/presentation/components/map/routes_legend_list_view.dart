import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../../../config/my_theme.dart';
import '../../../domain/entities/route_entity.dart';
import '../space.dart';

class RoutesLegendListView extends HookWidget {
  const RoutesLegendListView(
    this.segments, {
    super.key,
    this.onScrollToNewSegment,
    this.selectedRouteName,
  });

  final List<Set<RouteEntity>> segments;
  final void Function(int index)? onScrollToNewSegment;
  final ValueNotifier<String?>? selectedRouteName;

  static const colorLegend = [
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.green,
  ];

  static const _height = 135.0;
  static const _tileWidth = 300.0;

  Widget _tileBuilder(
    int index,
    RouteEntity route,
    bool isOnCurrentCard,
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
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
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
    final isSelected = route.name == selectedRouteName?.value;
    return InkWell(
      onTap: !isOnCurrentCard || selectedRouteName == null
          ? null
          : () => selectedRouteName!.value = isSelected ? null : route.name,
      child: ColoredBox(
        color: Colors.black.withOpacity(
          isSelected ? 0.2 : 0,
        ),
        child: Row(
          children: [
            coloredBox,
            12.horizontalSpace,
            Expanded(
              child: textColumn,
            ),
            9.horizontalSpace,
          ],
        ),
      ),
    );
  }

  Widget _segmentCardBuilder(
    BuildContext context,
    int index,
    int selectedIndex,
  ) {
    final tiles = <Widget>[];
    final segment = segments[index];
    for (int i = 0; i < segment.length; i += 2) {
      final leftRoute = segment.elementAt(i);
      final leftTile = _tileBuilder(
        i,
        leftRoute,
        index == selectedIndex,
      );
      final hasNextElement = i + 1 < segment.length;
      final rightTile = hasNextElement
          ? _tileBuilder(
              i + 1,
              segment.elementAt(i + 1),
              index == selectedIndex,
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(12),
            right: Radius.circular(25),
          ),
        ),
        margin: EdgeInsets.zero,
        child: cardContent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);
    return SizedBox(
      height: _height,
      child: ScrollSnapList(
        focusOnItemTap: true,
        scrollPhysics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.fast,
        ),
        margin: EdgeInsets.zero,
        itemCount: segments.length,
        onItemFocus: (index) {
          currentIndex.value = index;
          if (onScrollToNewSegment != null) onScrollToNewSegment!(index);
          if (selectedRouteName != null) selectedRouteName!.value = '';
        },
        clipBehavior: Clip.none,
        padding: EdgeInsets.zero,
        itemSize: _tileWidth,
        scrollDirection: Axis.horizontal,
        duration: kThemeAnimationDuration.inMilliseconds,
        dynamicItemSize: true,
        dynamicSizeEquation: (distance) => 1 - min(distance.abs() / 500, 0.2),
        itemBuilder: (context, index) => _segmentCardBuilder(
          context,
          index,
          currentIndex.value,
        ),
      ),
    );
  }
}
