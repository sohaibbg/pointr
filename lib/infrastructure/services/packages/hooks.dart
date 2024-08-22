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

/// returns the latest [source] which satisfies [test]
/// returns null if no previous element ever satisfied [test]
/// marks rebuild on change
T? useLatestWhere<T>(
  T source,
  bool Function(T prev) test,
) {
  final didPass = test(source);
  final state = useState(
    didPass ? source : null,
  );
  if (didPass) state.value = source;
  return state.value;
}

/// persists previous [source] for [duration]
/// before being updated if [test] is passed.
///
/// returns null if no previous [source]
/// ever satisfied [test]
T? useLatestWhereAndDelayWhereNot<T>(
  T source,
  Duration duration, {
  required bool Function(T e) test,
}) {
  final previous = useLatestWhere(source, test);
  final state = useState(previous);
  useEffect(
    () {
      final didPass = test(source);
      if (didPass) {
        state.value = source;
        return null;
      } else {
        final timer = Timer(
          duration,
          () => state.value = null,
        );
        return timer.cancel;
      }
    },
  );
  return state.value;
}
