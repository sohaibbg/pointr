import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class ViewModel<T> {
  const ViewModel(this.context, this.ref);

  final BuildContext context;
  final WidgetRef ref;

  T get widget => context.widget as T;
}
