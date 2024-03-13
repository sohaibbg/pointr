part of 'route_calculator.dart';

class _RoutesLegendListView extends ConsumerWidget {
  const _RoutesLegendListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final segments = ref.watch(
      routeSegmentsProvider,
    );
    if (segments!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(25),
        child: Text("No routes loaded"),
      );
    }
    const horizontalPadding = 0;
    final tileWidth = 300.toDouble();
    return SizedBox(
      height: 265,
      child: ScrollSnapList(
        focusOnItemTap: true,
        margin: EdgeInsets.zero,
        itemCount: segments.length,
        onItemFocus: (newIndex) => ref
            .read(
              selectedSegmentIndexProvider.notifier,
            )
            .state = newIndex,
        padding: EdgeInsets.zero,
        itemSize: horizontalPadding + tileWidth,
        scrollDirection: Axis.horizontal,
        duration: kThemeAnimationDuration.inMilliseconds,
        dynamicItemSize: true,
        dynamicSizeEquation: (distance) => 1 - min(distance.abs() / 500, 0.2),
        itemBuilder: (context, index) {
          final tiles = <Widget>[];
          final segment = segments[index];
          for (int i = 0; i < segment.length; i++) {
            final route = segment.elementAt(i);
            final colorKey = DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: RouteCalculatorViewModel.colorLegend[i],
              ),
              child: const SizedBox.square(
                dimension: 15,
              ),
            );
            final subtitleText = switch (route.mode) {
              pointr.RouteMode.bus => "Bus",
              pointr.RouteMode.acBus => "AC Bus",
              pointr.RouteMode.pinkBus => "Pink bus",
              pointr.RouteMode.chinchi => "Chinchi",
              pointr.RouteMode.greenLine => "Green Line",
            };
            final tile = SizedBox(
              width: tileWidth,
              child: ListTile(
                trailing: colorKey,
                dense: true,
                subtitle: Text(subtitleText),
                title: Text(route.name),
              ),
            );
            tiles.add(tile);
          }
          return Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList(),
            ),
          );
        },
      ),
    );
  }
}
