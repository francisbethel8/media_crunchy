import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'routes/api_routes.dart';
import 'services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(const ProviderScope(child: MediaCrunchyApp()));
}

class MediaCrunchyApp extends StatelessWidget {
  const MediaCrunchyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Media Crunchy',
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
