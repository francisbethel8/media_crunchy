import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../models/video_model.dart';
import '../../../../shared/widgets/custom_video_player.dart';

class WatchScreen extends StatelessWidget {
  final VideoModel video;

  const WatchScreen({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          const CustomVideoPlayer(),

          const SizedBox(height: 20),

          Text(
            video.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Text(
            video.description,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),

          const SizedBox(height: 30),

          const Text(
            'Episodes',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Column(
            children: video.episodes.map((episode) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),

                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 60,

                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: const Icon(Icons.play_arrow),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        episode,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
