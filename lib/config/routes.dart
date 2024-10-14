import 'package:go_router/go_router.dart';

import '../domain/entities/route_entity.dart';
import '../presentation/screens/about_screen.dart';
import '../presentation/screens/drawer_scaffold.dart';
import '../presentation/screens/favorites_flow/create_favorite.dart';
import '../presentation/screens/favorites_flow/list_favorites.dart';
import '../presentation/screens/go_screen/go_screen.dart';
import '../presentation/screens/routes/create_route_screen.dart';
import '../presentation/screens/routes/display_route_screen.dart';
import '../presentation/screens/routes/list_routes_screen/list_routes_screen.dart';
import '../presentation/screens/t_and_c_screen.dart';

final router = GoRouter(
  redirect: (context, state) => switch (state.fullPath) {
    // default
    "/" || "" => '/go',
    _ => null,
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) => DrawerScaffold(child: child),
      routes: [
        ...DrawerOptions.values.map(
          (option) => switch (option) {
            DrawerOptions.go => GoRoute(
                path: option.path,
                builder: (context, state) => const GoScreen(),
              ),
            DrawerOptions.routes => GoRoute(
                path: '/route',
                builder: (context, state) {
                  final hasQuery = state.uri.hasQuery;
                  if (!hasQuery) return const ListRoutesScreen();
                  final routesCode = state.uri.queryParameters['routesCode'];
                  if (routesCode == null) return const ListRoutesScreen();
                  return ListRoutesScreen(
                    routesAsCode: routesCode,
                  );
                },
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (context, state) => const CreateRouteScreen(),
                  ),
                  GoRoute(
                    path: 'display',
                    builder: (context, state) => DisplayRouteScreen(
                      state.extra as Set<RouteEntity>,
                    ),
                  ),
                ],
              ),
            DrawerOptions.about => GoRoute(
                path: option.path,
                builder: (context, state) => const AboutScreen(),
              ),
            DrawerOptions.tAndC => GoRoute(
                path: option.path,
                builder: (context, state) => const TAndCScreen(),
              ),
          },
        ),
        GoRoute(
          path: '/favorite',
          builder: (context, state) => const ListFavorites(),
          routes: [
            GoRoute(
              path: 'create',
              builder: (context, state) => const CreateFavorite(),
            ),
          ],
        ),
      ],
    ),
  ],
);
