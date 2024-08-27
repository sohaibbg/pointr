part of '../route_advisor_screen.dart';

class _RoutesLegendListView extends ConsumerWidget {
  const _RoutesLegendListView();

  // for animation
  static List<Set<RouteEntity>>? _cachedLastValidState;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(
        scoredRouteGroupsProvider,
      )
      .when(
        error: (_, __) => const Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20, top: 130),
            child: Text("Error loading routes"),
          ),
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(25),
          child: LinearProgressIndicator(),
        ),
        data: (segments) {
          if (segments.isNotEmpty) _cachedLastValidState = segments;
          if (segments.isEmpty && _cachedLastValidState != null) {
            return RoutesLegendListView(_cachedLastValidState!);
          }
          return RoutesLegendListView(
            segments,
            onScrollToNewSegment: (newIndex) => ref
                .read(
                  selectedRouteGroupIndexProvider.notifier,
                )
                .state = newIndex,
          );
        },
      );
}
