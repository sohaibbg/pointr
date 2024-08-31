import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../config/my_theme.dart';
import '../components/space.dart';

enum DrawerOptions {
  go(
    iconData: Icons.directions_walk_rounded,
    name: 'Go',
    path: '/go',
  ),
  routes(
    iconData: Icons.route,
    name: 'Routes',
    path: '/route',
  ),
  about(
    iconData: Icons.info,
    name: 'About',
    path: '/about',
  ),
  tAndC(
    iconData: Icons.description,
    name: 'Terms & Conditions',
    path: '/terms-and-conditions',
  );

  final String name;
  final IconData iconData;
  final String path;

  const DrawerOptions({
    required this.name,
    required this.iconData,
    required this.path,
  });
}

class DrawerScaffold extends HookWidget {
  const DrawerScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
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
    final drawerHeader = DrawerHeader(
      padding: const EdgeInsetsDirectional.fromSTEB(32, 20, 28, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "pointr",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          12.verticalSpace,
          const Text("Public Transport routes for Karachi"),
        ],
      ),
    );
    final drawer = Drawer(
      backgroundColor: Color.lerp(
        MyTheme.primaryColor.shade50,
        Colors.white,
        0.6,
      ),
      child: ListView(
        reverse: true,
        children: [
          drawerHeader,
          ...DrawerOptions.values.map(_buildDrawerTile),
        ],
      ),
    );
    return Scaffold(
      drawer: drawer,
      body: body,
    );
  }

  Widget _buildDrawerTile(
    DrawerOptions o,
  ) =>
      Column(
        children: [
          Builder(
            builder: (context) {
              final fullPath = GoRouterState.of(context).fullPath;
              final selected = o.path == fullPath;
              return ListTile(
                selected: selected,
                contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(32, 0, 28, 0),
                title: Text(o.name),
                leading: Icon(o.iconData),
                onTap: () {
                  context.go(o.path);
                  Scaffold.of(context).closeDrawer();
                },
              );
            },
          ),
          const Divider(),
        ],
      );
}
