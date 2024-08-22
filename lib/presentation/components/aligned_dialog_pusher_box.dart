import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AlignedDialogPusherBox extends HookConsumerWidget {
  const AlignedDialogPusherBox({
    required this.childBuilder,
    required this.dialogBuilder,
    required this.targetAnchor,
    required this.followerAnchor,
    this.onDismiss,
    super.key,
  });

  final Widget Function({
    required void Function() push,
    required void Function() dismiss,
  }) childBuilder;
  final Widget Function(BuildContext context) dialogBuilder;
  final Alignment targetAnchor;
  final Alignment followerAnchor;
  final void Function()? onDismiss;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opc = OverlayPortalController();
    final animCtl = useAnimationController(
      duration: kThemeAnimationDuration,
    );
    void push() {
      opc.show();
      animCtl.forward();
    }

    void dismiss() async {
      await animCtl.reverse();
      opc.hide();
      if (onDismiss != null) onDismiss!();
    }

    final ll = LayerLink();
    return CompositedTransformTarget(
      link: ll,
      child: OverlayPortal(
        controller: opc,
        child: childBuilder(
          push: push,
          dismiss: dismiss,
        ),
        overlayChildBuilder: (context) {
          final unfocusShade = AnimatedBuilder(
            animation: animCtl,
            builder: (context, child) {
              final finalColor = Theme.of(
                    context,
                  ).dialogTheme.backgroundColor ??
                  Colors.black54;
              final animatingColor = Color.lerp(
                Colors.transparent,
                finalColor,
                animCtl.value,
              );
              return ModalBarrier(
                color: animatingColor,
                onDismiss: dismiss,
              );
            },
          );
          final positionedPopup = CompositedTransformFollower(
            link: ll,
            targetAnchor: targetAnchor,
            followerAnchor: followerAnchor,
            child: ScaleTransition(
              alignment: followerAnchor,
              scale: animCtl,
              child: dialogBuilder(context),
            ),
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
