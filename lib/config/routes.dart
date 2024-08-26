import 'package:go_router/go_router.dart';

import '../domain/entities/address_entity.dart';
import '../domain/entities/route_entity.dart';
import '../presentation/screens/favorites_flow/list_favorites.dart';
import '../presentation/screens/favorites_flow/new_favorite.dart';
import '../presentation/screens/home/home.dart';
import '../presentation/screens/home/routes/display_route_screen.dart';
import '../presentation/screens/route_calculator/route_calculator.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(
        homeScreenOptions: HomeScreenOptions.go,
      ),
      routes: [
        GoRoute(
          path: 'display-routes',
          builder: (context, state) => DisplayRouteScreen(
            state.extra as Set<RouteEntity>,
          ),
        ),
        GoRoute(
          path: 'route-calculator',
          builder: (context, state) {
            final extra = state.extra as Map?;
            final focusSearch = extra?['focusSearch'] as bool?;
            final initialPlace = extra?['initialPlace'] as AddressEntity?;
            return RouteCalculator(
              focusSearch: focusSearch ?? false,
              initialPlace: initialPlace,
            );
          },
        ),
        GoRoute(
          path: 'new-favorite',
          builder: (context, state) => const NewFavorite(),
        ),
        GoRoute(
          path: 'favorites',
          builder: (context, state) => const ListFavorites(),
        ),
        // GoRoute(
        //   path: '/custom-routes',
        //   // builder: (context, state) {},
        // ),
        // GoRoute(
        //   path: '/contribute',
        //   // builder: (context, state) {},
        //   routes: [
        //     GoRoute(
        //       path: '/stream-location',
        //       // builder: (context, state) {},
        //     ),
        //     GoRoute(
        //       path: '/new-route',
        //       // builder: (context, state) {},
        //     ),
        //   ],
        // ),
      ],
    ),
  ],
);
