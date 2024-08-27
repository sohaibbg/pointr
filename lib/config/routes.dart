import 'package:go_router/go_router.dart';

import '../domain/entities/address_entity.dart';
import '../domain/entities/route_entity.dart';
import '../presentation/screens/favorites_flow/create_favorite.dart';
import '../presentation/screens/favorites_flow/list_favorites.dart';
import '../presentation/screens/home/go/go_screen.dart';
import '../presentation/screens/home/home.dart';
import '../presentation/screens/routes/copy_route_screen.dart';
import '../presentation/screens/routes/create_route_screen.dart';
import '../presentation/screens/routes/display_route_screen.dart';
import '../presentation/screens/routes/list_routes_screen/list_routes_screen.dart';
import '../presentation/screens/routes/route_advisor_screen/route_advisor_screen.dart';

final router = GoRouter(
  redirect: (context, state) => switch (state.fullPath) {
    // default
    "/" || "" => '/go',
    _ => null,
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        final isShellPath = [
          '/go',
          '/favorite',
          '/route',
        ].contains(state.fullPath);
        if (!isShellPath) return child;
        return HomeShell(child: child);
      },
      routes: [
        ...HomeOptions.values.map(
          (option) => switch (option) {
            HomeOptions.go => GoRoute(
                path: '/go',
                builder: (context, state) => const GoScreen(),
              ),
            HomeOptions.routes => GoRoute(
                path: '/route',
                builder: (context, state) => const ListRoutesScreen(),
                routes: [
                  GoRoute(
                    path: 'advisor',
                    builder: (context, state) {
                      final extra = state.extra as Map?;
                      final focusSearch = extra?['focusSearch'] as bool?;
                      final initialPlace =
                          extra?['initialPlace'] as AddressEntity?;
                      return RouteAdvisorScreen(
                        focusSearch: focusSearch ?? false,
                        initialPlace: initialPlace,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'copy',
                    builder: (context, state) => CopyRouteScreen(
                      state.extra as RouteEntity,
                    ),
                  ),
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
