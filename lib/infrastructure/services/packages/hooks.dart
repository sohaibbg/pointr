import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

bool useIsFocused(FocusNode node) {
  final isFocused = useState(node.hasFocus);

  useEffect(
    () {
      void listener() => isFocused.value = node.hasFocus;

      node.addListener(listener);
      return () => node.removeListener(listener);
    },
    [node],
  );

  return isFocused.value;
}

bool useBoolWhereTruthyDebounced(
  bool source,
  Duration duration,
) {
  final boolState = useState(source);
  useEffect(
    () {
      if (source) {
        final timer = Timer(
          duration,
          () => boolState.value = true,
        );
        return timer.cancel;
      } else {
        boolState.value = false;
        return null;
      }
    },
  );
  return boolState.value;
}

T? useDebouncedWhenNulled<T>(
  T? source,
  Duration duration,
) {
  final state = useState<T?>(source);
  useEffect(
    () {
      if (source == null) {
        final timer = Timer(
          duration,
          () => state.value = null,
        );
        return timer.cancel;
      } else {
        state.value = source;
        return null;
      }
    },
  );
  return state.value;
}
