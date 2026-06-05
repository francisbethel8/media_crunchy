import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../features/auth/logic/auth_notifier.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/signup_screen.dart';
import '../features/creator/presentation/screens/creator_dashboard_screen.dart';
import '../features/video/presentation/screens/watch_screen.dart';
import '../models/video_model.dart';
import '../shared/components/main_navigation_screen.dart';

// Create a router that supports role-based routing
GoRouter createAppRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
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
      // Creator routes
      GoRoute(
        path: '/creator/dashboard',
        builder: (context, state) {
          return const CreatorDashboardScreen();
        },
      ),
      GoRoute(
        path: '/creator/upload',
        builder: (context, state) {
          return const CreatorUploadPlaceholder();
        },
      ),
      // Admin routes
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) {
          return const AdminDashboardScreen();
        },
      ),
      GoRoute(
        path: '/admin/reviews',
        builder: (context, state) {
          return const AdminReviewQueuePlaceholder();
        },
      ),
    ],
    redirect: (context, state) {
      final auth = ref.watch(authNotifierProvider);
      final isLoggedIn = auth.user != null;
      final loggingIn = state.uri.path == '/login';
      final signingUp = state.uri.path == '/signup';

      // Redirect to login if not authenticated
      if (!isLoggedIn) {
        return loggingIn || signingUp ? null : '/login';
      }

      // Redirect from login/signup if authenticated
      if (loggingIn || signingUp) {
        return '/';
      }

      // Role-based route protection
      final userRole = auth.profile?.role ?? 'viewer';
      if (state.uri.path.startsWith('/creator/') &&
          userRole != 'creator' &&
          userRole != 'admin') {
        return '/';
      }
      if (state.uri.path.startsWith('/admin/') && userRole != 'admin') {
        return '/';
      }

      return null;
    },
  );
}

// Temporary placeholders for screens not yet implemented

class CreatorUploadPlaceholder extends StatelessWidget {
  const CreatorUploadPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Video')),
      body: const Center(child: Text('Upload Screen - Coming Soon')),
    );
  }
}

class AdminReviewQueuePlaceholder extends StatelessWidget {
  const AdminReviewQueuePlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Content Review Queue')),
      body: const Center(child: Text('Review Queue - Coming Soon')),
    );
  }
}

// Legacy router for compatibility (basic version without role checking)
final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
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
    final signingUp = state.uri.path == '/signup';

    if (!isLoggedIn) {
      return loggingIn || signingUp ? null : '/login';
    }
    if (loggingIn || signingUp) {
      return '/';
    }
    return null;
  },
);
