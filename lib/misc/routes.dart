import 'package:go_router/go_router.dart';

import '../models/coordinates.dart';
import '../ui/dashboard/screens/home/home.dart';
import '../ui/dashboard/screens/route_calculator/route_calculator.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(),
      routes: [
        GoRoute(
          path: '/route-calculator',
          builder: (context, state) {
            final extra = state.extra as Map?;
            final focusSearch = extra?['focusSearch'] as bool?;
            final initialCoordinates =
                extra?['initialCoordinates'] as Coordinates?;
            return RouteCalculator(
              focusSearch: focusSearch ?? false,
              initialCoordinates: initialCoordinates,
            );
          },
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
