import 'package:go_router/go_router.dart';

import '../models/located_place.dart';
import '../ui/screens/favorites_flow/list_favorites.dart';
import '../ui/screens/favorites_flow/new_favorite.dart';
import '../ui/screens/home/home.dart';
import '../ui/screens/route_calculator/route_calculator.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(),
      routes: [
        GoRoute(
          path: 'route-calculator',
          builder: (context, state) {
            final extra = state.extra as Map?;
            final focusSearch = extra?['focusSearch'] as bool?;
            final initialPlace = extra?['initialPlace'] as LocatedPlace?;
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
