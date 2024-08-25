import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SlideTransitionHelper extends HookConsumerWidget {
  const SlideTransitionHelper({
    required this.doShow,
    required this.axis,
    required this.axisAlignment,
    required this.child,
    super.key,
  });

  final bool doShow;
  final Widget child;
  final Axis axis;
  final double axisAlignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animCtl = useAnimationController(
      duration: kThemeAnimationDuration,
      initialValue: doShow ? 1 : 0,
    );
    if (doShow) {
      animCtl.forward();
    } else {
      animCtl.reverse();
    }
    return SizeTransition(
      sizeFactor: animCtl,
      axis: axis,
      axisAlignment: axisAlignment,
      child: child,
    );
  }
}
