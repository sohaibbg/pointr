import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../models/route.dart' as pointr;
import '../route_calculator_view_model.dart';

class RouteCheckList extends ConsumerWidget {
  const RouteCheckList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(scoredRoutesProvider).when(
            loading: () => const LinearProgressIndicator(),
            error: (error, stackTrace) => const Text('error'),
            data: (routes) {
              Widget checkListBuilder(Map<pointr.Route, double> routes) =>
                  ListView.separated(
                    itemCount: routes.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final entry = routes.entries.elementAt(index);
                      final route = entry.key;
                      return CheckboxListTile.adaptive(
                        value: ref
                            .watch(
                              selectedRoutesProvider,
                            )
                            .contains(
                              route,
                            ),
                        onChanged: (isChecked) {
                          if (isChecked == null) return;
                          final selectedNotifier = ref.read(
                            selectedRoutesProvider.notifier,
                          );
                          selectedNotifier.toggleRoute(route, isChecked);
                        },
                      );
                    },
                  );
              final routeModeCheckboxView = ListView.separated(
                scrollDirection: Axis.horizontal,
                cacheExtent: 200,
                itemCount: pointr.RouteMode.values.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final mode = pointr.RouteMode.values[index];
                  return CheckboxListTile.adaptive(
                    value: ref
                        .watch(
                          selectedRouteModesProvider,
                        )
                        .contains(
                          mode,
                        ),
                    onChanged: (isChecked) {
                      if (isChecked == null) return;
                      final selectedNotifier = ref.read(
                        selectedRouteModesProvider.notifier,
                      );
                      selectedNotifier.update(
                        (state) =>
                            isChecked ? state.add(mode) : state.remove(mode),
                      );
                    },
                  );
                },
              );
              return Column(
                children: [
                  routeModeCheckboxView,
                  Flexible(
                    child: checkListBuilder(routes),
                  ),
                ],
              );
            },
          );
}
