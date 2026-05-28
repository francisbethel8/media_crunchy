import 'package:go_router/go_router.dart';

import '../features/video/presentation/screens/watch_screen.dart';
import '../shared/components/main_navigation_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainNavigationScreen(),
    ),

    GoRoute(path: '/watch', builder: (context, state) => const WatchScreen()),
  ],
);
