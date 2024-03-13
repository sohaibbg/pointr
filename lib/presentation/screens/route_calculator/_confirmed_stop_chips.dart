part of 'route_calculator.dart';

class _ConfirmedStopChips extends HookConsumerWidget {
  const _ConfirmedStopChips({
    required this.searchBarFocusNode,
  });

  final FocusNode searchBarFocusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFocused = useIsFocused(searchBarFocusNode);
    if (isFocused) return const SizedBox();
    final from = ref.watch(fromStopProvider);
    final to = ref.watch(toStopProvider);
    final chips = <Widget>[];
    if (from != null) {
      chips.add(
        Expanded(
          child: Row(
            children: [
              const Text("From: "),
              Expanded(
                child: ActionChip(
                  label: Text(
                    from.address,
                    overflow: TextOverflow.fade,
                  ),
                  avatar: const Icon(Icons.location_on),
                  onPressed: () {
                    ref
                        .read(
                          fromStopProvider.notifier,
                        )
                        .state = null;
                    searchBarFocusNode.requestFocus();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (to != null) {
      chips.add(
        Expanded(
          child: Row(
            children: [
              const Text("To: "),
              Expanded(
                child: ActionChip(
                  label: Text(
                    to.address,
                    overflow: TextOverflow.fade,
                  ),
                  avatar: const Icon(Icons.location_on),
                  onPressed: () {
                    ref
                        .read(
                          toStopProvider.notifier,
                        )
                        .state = null;
                    searchBarFocusNode.requestFocus();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (chips.length == 2) chips.insert(1, 12.horizontalSpace);
    if (chips.isEmpty) return const SizedBox();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 24, 8),
        child: Row(children: chips),
      ),
    );
  }
}
