extension IterableHelperMethods<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T e) test) {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }

  List<T> replaceAtIndex(
    int index,
    T newElement,
  ) =>
      [
        ...toList().sublist(0, index),
        newElement,
        ...toList().sublist(index + 1),
      ];

  Iterable<T> replaceWhere(
    bool Function(T e) test,
    T Function(T e) replacementBuilder,
  ) =>
      map(
        (e) => test(e) ? replacementBuilder(e) : e,
      );

  List<List<T>> splitByLength(int subListLength) {
    final masterList = <List<T>>[];
    final masterListLength = (length / subListLength).ceil();
    for (int i = 0; i < masterListLength; i++) {
      masterList.add([]);
      for (int j = 0; j < subListLength; j++) {
        final index = (i * subListLength) + j;
        if (index == length) break;
        masterList[i].add(
          elementAt(index),
        );
      }
    }
    return masterList;
  }

  List<T> toggle(T e) {
    if (contains(e)) {
      return toList()..removeWhere((e2) => e2 == e);
    } else {
      return toList()..add(e);
    }
  }

  /// splits a list into a map of {id:list<T>} pairs
  ///
  /// the id is supplied by the [deriveKey] method
  Map<V, List<T>> divideByKey<V>(
    V Function(T e) deriveKey,
  ) {
    final result = <V, List<T>>{};
    for (final e in this) {
      final key = deriveKey(e);
      if (result[key] == null) result[key] = <T>[];
      result[key]!.add(e);
    }
    return result;
  }

  List<T> intersperseDivider(
    T divider, {
    bool insertAfterLast = false,
  }) {
    final list = toList();
    for (int i = 1; i < list.length; i += 2) {
      list.insert(i, divider);
    }
    if (insertAfterLast) return list..add(divider);
    return list;
  }
}

extension ComparableHelperMethods<T extends Comparable> on Iterable<T> {
  T calculateMax() {
    final sorted = toList()..sort();
    return sorted.last;
  }

  T calculateMin() {
    final sorted = toList()..sort();
    return sorted.first;
  }
}

extension NumIterableHelperMethods<T extends num> on Iterable<T> {
  num calculateSum() => fold(
        0 as T,
        (prev, e) => prev += e,
      );

  num caclulateAverage() => calculateSum() / length;
}
