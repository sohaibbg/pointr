import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BlinkingLoader extends HookConsumerWidget {
  const BlinkingLoader({
    super.key,
    required this.child,
    this.duration = kThemeAnimationDuration,
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpaque = useState(true);
    useEffect(
      () {
        final timer = Timer.periodic(
          duration,
          (timer) => isOpaque.value = !isOpaque.value,
        );
        return timer.cancel;
      },
    );
    return AnimatedOpacity(
      opacity: isOpaque.value ? 1 : 0,
      duration: kThemeAnimationDuration,
      child: child,
    );
  }
}
