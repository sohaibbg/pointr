import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../config/my_theme.dart';
import '../../../infrastructure/services/packages/iterable.dart';

enum HomeOptions {
  go(
    iconData: Icons.directions_walk_rounded,
    label: 'Go',
    path: '/go',
  ),
  routes(
    iconData: Icons.route,
    label: 'Routes',
    path: '/route',
  );

  final String label;
  final IconData iconData;
  final String path;

  const HomeOptions({
    required this.label,
    required this.iconData,
    required this.path,
  });
}

class HomeShell extends HookWidget {
  const HomeShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final selectedOption = HomeOptions.values.firstWhereOrNull(
      (o) => o.path == GoRouterState.of(context).fullPath,
    );
    final previousOption = useValueChanged<HomeOptions?, HomeOptions>(
      selectedOption,
      (oldValue, oldResult) {
        if (selectedOption != null) return selectedOption;
        return oldResult;
      },
    );
    final bottomNavigationBar = Material(
      elevation: 8,
      child: BottomNavigationBar(
        backgroundColor: Color.lerp(
          MyTheme.primaryColor.shade50,
          Colors.white,
          0.5,
        ),
        currentIndex: switch (selectedOption ?? previousOption) {
          HomeOptions.go => 0,
          HomeOptions.routes => 1,
          null => 0,
        },
        onTap: (value) {
          final path = switch (value) {
            0 => '/go',
            1 => '/route',
            _ => throw UnimplementedError()
          };
          context.go(path);
        },
        items: HomeOptions.values
            .map(
              (o) => BottomNavigationBarItem(
                icon: Icon(o.iconData),
                label: o.label,
              ),
            )
            .toList(),
      ),
    );
    final backdrop = Image.asset(
      'assets/images/geometric pattern.png',
      fit: BoxFit.fitWidth,
      alignment: Alignment.topCenter,
    );
    final body = Stack(
      alignment: Alignment.topCenter,
      fit: StackFit.expand,
      children: [backdrop, child],
    );
    return Scaffold(
      bottomNavigationBar: bottomNavigationBar,
      body: body,
    );
  }
}
