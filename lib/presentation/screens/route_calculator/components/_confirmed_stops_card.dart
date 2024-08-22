part of '../route_calculator.dart';

class _ConfirmedStopsCard extends HookConsumerWidget {
  const _ConfirmedStopsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nStops = ref.watch(
      bothStopsProvider.select(
        (e) => [e.from, e.to].where((e) => e).length,
      ),
    );
    final prevStops = useState(
      ref.read(bothStopsProvider),
    );
    final latestStops = useState(
      ref.read(bothStopsProvider),
    );
    final initialE = E(prevStops.value, latestStops.value);
    final fromAnimCtl = useAnimationController(
      duration: kThemeAnimationDuration,
      initialValue: initialE.getScale(FromTo.from),
    );
    final toAnimCtl = useAnimationController(
      duration: kThemeAnimationDuration,
      initialValue: initialE.getScale(FromTo.to),
    );
    ref.listen(
      bothStopsProvider,
      (previous, next) {
        if (previous != null) prevStops.value = previous;
        latestStops.value = next;
        // print('here');
        final e = E(prevStops.value, latestStops.value);
        final fromScale = e.getScale(FromTo.from);
        final toScale = e.getScale(FromTo.to);
        // print('fromScale $fromScale, toScale $toScale');
        fromAnimCtl.animateTo(fromScale);
        toAnimCtl.animateTo(toScale);
      },
    );
    // print('fromAnim ${fromAnimCtl.value}, toAnim ${toAnimCtl.value}');
    final animatingContent = Row(
      children: [
        Expanded(
          child: _AnimatedChip(
            label: 'From: ',
            provider: fromStopProvider,
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: _AnimatedChip(
            label: 'To: ',
            provider: toStopProvider,
          ),
        ),
      ],
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
      doShow: nStops > 0,
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

enum FromTo {
  from,
  to;

  FromTo get other => switch (this) {
        FromTo.from => FromTo.to,
        FromTo.to => FromTo.from,
      };

  bool isIn(({bool from, bool to}) set) => switch (this) {
        FromTo.from => set.from,
        FromTo.to => set.to,
      };
}

class E {
  final ({bool from, bool to}) prev;
  final ({bool from, bool to}) latest;

  const E(this.prev, this.latest);

  double _prevScale(FromTo e) => e.isIn(prev)
      ? 0
      : e.other.isIn(prev)
          ? 0.5
          : 1;
  bool _didLeave(FromTo e) => e.isIn(prev) && !e.isIn(latest);

  double getScale(FromTo e) {
    if (!e.isIn(prev) && !e.isIn(latest)) return 0;
    if (_didLeave(e)) return _prevScale(e);
    if (e.other.isIn(latest)) return 0.5;
    return 1;
  }

  double getWidth(FromTo e, double fullWidth, double halfWidth) =>
      switch (getScale(e)) {
        0 => 0,
        1 => fullWidth,
        0.5 => halfWidth,
        _ => throw getScale(e),
      };
}
