part of 'route_calculator.dart';

class _RouteModeFilterBtn extends HookConsumerWidget {
  const _RouteModeFilterBtn();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opc = useMemoized(
      () => OverlayPortalController(
        debugLabel: 'route mode filter portal controller',
      ),
      [context],
    );
    final ll = LayerLink();
    final animCtl = useAnimationController(
      duration: kThemeAnimationDuration,
    );
    final button = ElevatedButton.icon(
      onPressed: () async {
        opc.show();
        animCtl.forward();
      },
      icon: const Icon(Icons.filter_alt),
      label: const Text("Filter"),
    );

    return CompositedTransformTarget(
      link: ll,
      child: OverlayPortal(
        controller: opc,
        key: const ValueKey('route mode filter overlay portal'),
        child: button,
        overlayChildBuilder: (
          context,
        ) {
          Future<void> unfocus() async {
            if (animCtl.isAnimating) return;
            await animCtl.reverse();
            if (!opc.isShowing) return;
            opc.hide();
          }

          final unfocusShade = GestureDetector(
            onTap: unfocus,
            onDoubleTap: unfocus,
            onSecondaryTap: unfocus,
            onSecondaryLongPress: unfocus,
            onVerticalDragStart: (_) => unfocus(),
            onHorizontalDragStart: (_) => unfocus(),
            onSecondaryLongPressStart: (_) => unfocus(),
            onLongPressStart: (_) => unfocus(),
            onForcePressStart: (_) => unfocus(),
            onTertiaryLongPressStart: (_) => unfocus(),
            child: AnimatedBuilder(
              animation: animCtl,
              builder: (context, child) => Opacity(
                opacity: animCtl.value * 0.3,
                child: child,
              ),
              child: const ColoredBox(
                color: Colors.black,
                child: SizedBox.expand(),
              ),
            ),
          );
          final popup = ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: ScaleTransition(
              alignment: Alignment.topCenter,
              scale: animCtl,
              child: Material(
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: pointr.RouteMode.values.map(
                      (mode) {
                        final isSelected = ref
                            .watch(
                              selectedRouteModesProvider,
                            )
                            .contains(
                              mode,
                            );
                        void onSelected(bool isChecked) => ref
                            .read(
                              selectedRouteModesProvider.notifier,
                            )
                            .update(
                              (state) => state.toggle(mode),
                            );
                        return FilterChip(
                          selected: isSelected,
                          label: Text(mode.name),
                          avatar: const SizedBox.shrink(),
                          checkmarkColor: Theme.of(context).cardColor,
                          onSelected: onSelected,
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ),
          );
          final positionedPopup = CompositedTransformFollower(
            link: ll,
            targetAnchor: Alignment.bottomCenter,
            followerAnchor: Alignment.topCenter,
            child: popup,
          );
          return Stack(
            children: [
              unfocusShade,
              positionedPopup,
            ],
          );
        },
      ),
    );
  }
}
