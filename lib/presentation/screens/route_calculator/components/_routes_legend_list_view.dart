part of '../route_calculator.dart';

class _RoutesLegendListView extends ConsumerWidget {
  const _RoutesLegendListView();

  static const colorLegend = [
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.green,
  ];

  static const height = 165.0;
  static const _tileWidth = 300.0;
  // for animation
  static List<Set<RouteEntity>>? _cachedLastValidState;

  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox(
        height: height,
        child: ref
            .watch(
              scoredRouteGroupsProvider,
            )
            .when(
              error: (_, __) => const Padding(
                padding: EdgeInsets.all(25),
                child: Text("Error loading routes"),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(25),
                child: LinearProgressIndicator(),
              ),
              data: (segments) {
                if (segments.isNotEmpty) _cachedLastValidState = segments;
                if (segments.isEmpty && _cachedLastValidState != null) {
                  return _onData(_cachedLastValidState!, ref);
                }
                return _onData(segments, ref);
              },
            ),
      );

  Widget _onData(
    List<Set<RouteEntity>> segments,
    WidgetRef ref,
  ) =>
      ScrollSnapList(
        focusOnItemTap: true,
        scrollPhysics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.fast,
        ),
        margin: EdgeInsets.zero,
        itemCount: segments.length,
        onItemFocus: (newIndex) => ref
            .read(
              selectedRouteGroupIndexProvider.notifier,
            )
            .state = newIndex,
        clipBehavior: Clip.none,
        padding: EdgeInsets.zero,
        itemSize: _tileWidth,
        scrollDirection: Axis.horizontal,
        duration: kThemeAnimationDuration.inMilliseconds,
        dynamicItemSize: true,
        dynamicSizeEquation: (distance) => 1 - min(distance.abs() / 500, 0.2),
        itemBuilder: (context, index) {
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
              Flexible(
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
          return SizedBox(
            width: _tileWidth,
            height: height,
            child: Card(
              clipBehavior: Clip.hardEdge,
              color: Colors.indigo.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              margin: EdgeInsets.zero,
              child: Column(
                children: tiles.intersperseDivider(
                  Divider(
                    height: 0,
                    color: MyTheme.primaryColor,
                  ),
                ),
              ),
            ),
          );
        },
      );
  Widget _tileBuilder(
    int index,
    pointr.RouteEntity route,
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
}
