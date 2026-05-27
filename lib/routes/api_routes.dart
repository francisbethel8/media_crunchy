import 'package:go_router/go_router.dart';

import '../shared/components/main_navigation_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainNavigationScreen(),
    ),
  ],
);
