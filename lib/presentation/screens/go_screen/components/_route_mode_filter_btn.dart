part of '../go_screen.dart';

class _RouteModeFilterBtn extends HookConsumerWidget {
  const _RouteModeFilterBtn();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popupChild = Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 9,
            ),
            child: Wrap(
              spacing: 9,
              children: pointr.RouteMode.values.map(
                (mode) {
                  final isSelected = ref.watch(
                    selectedRouteModesProvider.select(
                      (modes) => modes.contains(mode),
                    ),
                  );
                  return FilterChip(
                    selected: isSelected,
                    label: Text(mode.name),
                    avatar: const SizedBox.shrink(),
                    checkmarkColor: Theme.of(context).cardColor,
                    onSelected: (isChecked) => ref
                        .read(
                          selectedRouteModesProvider.notifier,
                        )
                        .toggle(
                          mode,
                        ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ),
    );
    return AlignedDialogPusherBox(
      dialogBuilder: (context) => popupChild,
      targetAnchor: Alignment.topRight,
      followerAnchor: Alignment.bottomRight,
      childBuilder: ({
        required dismiss,
        required push,
      }) =>
          ElevatedButton.icon(
        onPressed: push,
        icon: const Icon(Icons.filter_alt),
        label: const Text("Filter"),
        style: MyTheme.primaryElevatedButtonStyle.copyWith(
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
