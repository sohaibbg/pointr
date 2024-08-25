part of '../route_calculator.dart';

class _ConfirmedStopsCard extends HookConsumerWidget {
  const _ConfirmedStopsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nStops = ref.watch(
      bothStopsProvider.select(
        (e) => [e.hasFrom, e.hasTo].where((e) => e).length,
      ),
    );
    // controls chip width shrink/expand
    // 0 represents halfWidth, 1 represents fullWidth
    final fromAnimCtl = useAnimationController(
      duration: kThemeAnimationDuration,
      initialValue: ref.read(
        toStopProvider.select(
          (e) => e != null,
        ),
      )
          ? 0
          : 1,
    );
    final toAnimCtl = useAnimationController(
      duration: kThemeAnimationDuration,
      initialValue: ref.read(
        fromStopProvider.select(
          (e) => e != null,
        ),
      )
          ? 0
          : 1,
    );
    // controls chip slide in/out
    final doShowFrom = useState(
      nStops == 0 || ref.read(fromStopProvider) != null,
    );
    final doShowTo = useState(
      nStops == 0 || ref.read(toStopProvider) != null,
    );
    ref.listen(
      bothStopsProvider,
      (previous, next) {
        // if both are removed, chips are frozen as card itself animates down
        if (!next.hasFrom && !next.hasTo) {
          Future.delayed(
            kThemeAnimationDuration,
            () {
              if (!context.mounted) return;
              doShowFrom.value = true;
              doShowTo.value = true;
              fromAnimCtl.value = 1;
              toAnimCtl.value = 1;
            },
          );
          return;
        }
        doShowFrom.value = next.hasFrom;
        doShowTo.value = next.hasTo;
        fromAnimCtl.animateTo(next.hasTo ? 0 : 1);
        toAnimCtl.animateTo(next.hasFrom ? 0 : 1);
      },
    );
    final animatingContent = LayoutBuilder(
      builder: (context, constraints) {
        final fullWidth = constraints.maxWidth;
        final halfWidth = (fullWidth - 12) / 2;
        return Row(
          children: [
            SlideTransitionHelper(
              doShow: doShowFrom.value,
              axis: Axis.horizontal,
              axisAlignment: 1,
              child: AnimatedBuilder(
                animation: fromAnimCtl,
                child: _AnimatedChip(
                  label: 'From: ',
                  provider: fromStopProvider,
                ),
                builder: (context, child) => SizedBox(
                  width: Tween(
                    begin: halfWidth,
                    end: fullWidth,
                  ).animate(fromAnimCtl).value,
                  child: child,
                ),
              ),
            ),
            SlideTransitionHelper(
              doShow: nStops == 2,
              axis: Axis.horizontal,
              axisAlignment: 0,
              child: 12.horizontalSpace,
            ),
            SlideTransitionHelper(
              doShow: doShowTo.value,
              axis: Axis.horizontal,
              axisAlignment: -1,
              child: AnimatedBuilder(
                animation: toAnimCtl,
                child: _AnimatedChip(
                  label: 'To: ',
                  provider: toStopProvider,
                ),
                builder: (context, child) => SizedBox(
                  width: Tween(
                    begin: halfWidth,
                    end: fullWidth,
                  ).animate(toAnimCtl).value,
                  child: child,
                ),
              ),
            ),
          ],
        );
      },
    );
    final card = Card(
      color: MyTheme.primaryColor.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 24, 8),
        child: animatingContent,
      ),
    );
    final animatedCard = SlideTransitionHelper(
      doShow: nStops != 0,
      axis: Axis.vertical,
      axisAlignment: -1,
      child: card,
    );
    final canPop = [
      fromStopProvider,
      toStopProvider,
    ].every(
      (prov) => ref.watch(prov) == null,
    );
    final popScope = PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final to = ref.read(toStopProvider);
        if (to != null) {
          return ref.read(toStopProvider.notifier).state = null;
        }
        final from = ref.read(fromStopProvider);
        if (from != null) {
          return ref.read(fromStopProvider.notifier).state = null;
        }
      },
      child: animatedCard,
    );
    return popScope;
  }
}

class _AnimatedChip extends HookConsumerWidget {
  const _AnimatedChip({
    required this.label,
    required this.provider,
  });

  final String label;
  final StateProvider<AddressEntity?> provider;

  Widget chipBuilder({
    required String label,
    required AddressEntity address,
    required VoidCallback onPressed,
  }) {
    final chip = ActionChip(
      label: SizedBox(
        width: double.infinity,
        child: Text(
          address.address,
          overflow: TextOverflow.fade,
          maxLines: 3,
        ),
      ),
      avatar: const Icon(Icons.location_on),
      onPressed: onPressed,
    );
    return Row(
      children: [
        Text(label),
        Expanded(
          child: chip,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debouncedAddress = useLatestWhereAndDelayWhereNot(
      ref.watch(provider),
      kThemeAnimationDuration * 5,
      test: (e) => e != null,
    );
    if (debouncedAddress == null) return const SizedBox();
    final chip = chipBuilder(
      label: label,
      address: debouncedAddress,
      onPressed: () {
        final isValueNull = ref.read(provider) == null;
        if (isValueNull) return;
        ref.read(provider.notifier).state = null;
      },
    );
    return chip;
  }
}
