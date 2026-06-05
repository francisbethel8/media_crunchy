import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:media_crunchy/models/video_model.dart';
import 'package:media_crunchy/shared/widgets/custom_video_player.dart';
import 'package:media_crunchy/features/library/logic/library_notifier.dart';

class WatchScreen extends ConsumerWidget {
  final VideoModel video;

  const WatchScreen({super.key, required this.video});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final library = ref.watch(libraryProvider);
    final inLibrary = library.any((item) => item.id == video.id);

    return Scaffold(
      appBar: AppBar(title: Text(video.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomVideoPlayer(videoUrl: video.videoUrl),
          const SizedBox(height: 20),
          Text(
            video.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Chip(
                label: Text(video.category),
                backgroundColor: Colors.red.shade900,
              ),
              const SizedBox(width: 10),
              Text(
                '${video.duration.inMinutes} min',
                style: const TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    video.rating.toStringAsFixed(1),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            video.description,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: inLibrary
                ? null
                : () async {
                    await ref.read(libraryProvider.notifier).addVideo(video);
                  },
            icon: Icon(inLibrary ? Icons.check : Icons.add),
            label: Text(inLibrary ? 'Saved to Library' : 'Save to Library'),
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
                      child: const Icon(Icons.play_arrow, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        episode.title,
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
