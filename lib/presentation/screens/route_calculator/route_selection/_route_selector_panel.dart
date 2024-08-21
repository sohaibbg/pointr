part of '../route_calculator.dart';

class _RouteSelectorPanel extends HookConsumerWidget {
  const _RouteSelectorPanel({
    required this.vm,
  });

  final RouteCalculatorViewModel vm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final body = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            backBtn,
            12.horizontalSpace,
            const Expanded(child: _RouteModeFilterBtn()),
          ],
        ),
        12.verticalSpace,
        const _ConfirmedStopChips(),
      ],
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _RoutesLegendListView(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: body,
        ),
      ],
    );
  }
}
