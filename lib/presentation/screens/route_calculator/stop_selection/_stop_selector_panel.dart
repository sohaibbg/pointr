part of '../route_calculator.dart';

@riverpod
({bool from, bool to}) bothStops(BothStopsRef ref) => (
      from: ref.watch(
        fromStopProvider.select((e) => e != null),
      ),
      to: ref.watch(
        toStopProvider.select((e) => e != null),
      ),
    );

class _StopSelectorPanel extends ConsumerWidget {
  const _StopSelectorPanel(this.vm);

  final RouteCalculatorViewModel vm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confirmLocBtn = ElevatedButton.icon(
      icon: const Icon(Icons.navigate_next_sharp),
      label: Text(vm.selectLocBtnLabel),
      onPressed: () => context.loaderWithErrorDialog(
        vm.onPlaceConfirmed,
      ),
      style: MyTheme.primaryElevatedButtonStyle,
    );
    final backBtn = ElevatedButton(
      onPressed: () {
        if (ref.watch(toStopProvider) != null) {
          return ref.read(toStopProvider.notifier).state = null;
        }
        if (ref.watch(fromStopProvider) != null) {
          return ref.read(fromStopProvider.notifier).state = null;
        }
        return Navigator.of(
          context,
          rootNavigator: true,
        ).pop();
      },
      style: MyTheme.secondaryButtonStyle,
      child: const Icon(
        Icons.arrow_back_ios_new_outlined,
      ),
    );
    final panelContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            backBtn,
            12.horizontalSpace,
            Expanded(child: confirmLocBtn),
          ],
        ),
        const _ConfirmedStopChips(),
      ],
    );
    final panel = Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
      child: panelContent,
    );
    return ListenableBuilder(
      listenable: LocSearchBarWithOverlay.searchFocusNode,
      builder: (context, child) => AnimatedSize(
        duration: kThemeAnimationDuration,
        alignment: Alignment.topCenter,
        child: LocSearchBarWithOverlay.searchFocusNode.hasFocus
            ? double.infinity.horizontalSpace
            : panel,
      ),
    );
  }
}
