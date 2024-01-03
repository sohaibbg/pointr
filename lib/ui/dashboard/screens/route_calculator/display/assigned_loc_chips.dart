import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../route_calculator_view_model.dart';
import '../search/search_bar.dart';

class AssignedLocChips extends ConsumerWidget {
  const AssignedLocChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fromToStops = ref.watch(fromToStopsProvider);
    final chips = <Widget>[];
    if (fromToStops.first != null) {
      chips.add(
        Expanded(
          child: ActionChip(
            label: Text(
              fromToStops.first!.title,
              overflow: TextOverflow.fade,
            ),
            avatar: const Text("FROM"),
            onPressed: () {
              ref
                  .read(
                    fromToStopsProvider.notifier,
                  )
                  .update(
                    (list) => list.replace(0, null),
                  );
              ref
                  .read(
                    SearchBarFocusNodeProvider(0),
                  )
                  .requestFocus();
            },
          ),
        ),
      );
    }
    if (fromToStops.last != null) {
      chips.add(
        Expanded(
          child: ActionChip(
            label: Text(
              fromToStops.last!.title,
              overflow: TextOverflow.fade,
            ),
            avatar: const Text("TO"),
            onPressed: () {
              ref
                  .read(
                    fromToStopsProvider.notifier,
                  )
                  .update(
                    (list) => list.replace(1, null),
                  );
              ref
                  .read(
                    SearchBarFocusNodeProvider(1),
                  )
                  .requestFocus();
            },
          ),
        ),
      );
    }
    if (chips.isEmpty) return const SizedBox();
    return Row(children: chips);
  }
}
