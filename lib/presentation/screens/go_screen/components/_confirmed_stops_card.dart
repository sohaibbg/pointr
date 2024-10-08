part of '../go_screen.dart';

class _ConfirmedStopsCard extends HookConsumerWidget {
  const _ConfirmedStopsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nStops = ref.watch(
      bothStopsProvider.select(
        (e) => [e.hasFrom, e.hasTo].where((e) => e).length,
      ),
    );
    final animatingContent = LayoutBuilder(
      builder: (context, constraints) => Row(
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
      ),
    );
    final card = Padding(
      padding: const EdgeInsets.fromLTRB(10, 16, 5, 4),
      child: animatingContent,
    );
    final animatedCard = SlideTransitionHelper(
      doShow: nStops == 2,
      axis: Axis.vertical,
      axisAlignment: -1,
      child: card,
    );
    return animatedCard;
  }
}

class _AnimatedChip extends HookConsumerWidget {
  const _AnimatedChip({
    required this.label,
    required this.provider,
  });

  final String label;
  final StateProvider<AddressEntity?> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = ref.watch(provider);
    final text = Text(
      address == null
          ? "Search"
          : address.address == ''
              ? BoneMock.address
              : address.address,
    );
    final chip = ActionChip(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 12, 8, 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      label: Align(
        alignment: Alignment.centerLeft,
        child: Skeletonizer(
          enabled: address?.address == '',
          child: text,
        ),
      ),
      avatar: Icon(
        Icons.location_on,
        color: HSLColor.fromAHSL(
          1,
          switch (label) {
            'From: ' => BitmapDescriptor.hueBlue,
            'To: ' => BitmapDescriptor.hueRed,
            _ => throw label,
          },
          1,
          0.5,
        ).toColor(),
      ),
      onPressed: () {
        final stop = ref.read(provider);
        LocSearchBarWithOverlay.searchFocusNode.requestFocus();
        if (stop != null) {
          LocSearchBarWithOverlay.searchController.text = stop.address;
          ref.read(provider.notifier).state = null;
        }
      },
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
}
