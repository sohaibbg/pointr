import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/route_entity.dart';

class CopyRouteScreen extends HookConsumerWidget {
  const CopyRouteScreen(this.seed, {super.key});

  final RouteEntity seed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold();
  }
}
