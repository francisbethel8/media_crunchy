import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MediaCrunchyApp()));
}

class MediaCrunchyApp extends StatelessWidget {
  const MediaCrunchyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Media Crunchy',
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: Center(
          child: Text('Media Crunchy', style: TextStyle(fontSize: 32)),
        ),
      ),
    );
  }
}
