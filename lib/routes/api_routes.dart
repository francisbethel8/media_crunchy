import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/video/presentation/screens/watch_screen.dart';
import '../models/video_model.dart';
import '../shared/components/main_navigation_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/',
      builder: (context, state) => const MainNavigationScreen(),
    ),
    GoRoute(
      path: '/watch',
      builder: (context, state) {
        final video = state.extra as VideoModel;
        return WatchScreen(video: video);
      },
    ),
  ],
  redirect: (context, state) {
    final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
    final loggingIn = state.uri.path == '/login';

    if (!isLoggedIn) {
      return loggingIn ? null : '/login';
    }
    if (loggingIn) {
      return '/';
    }
    return null;
  },
);
