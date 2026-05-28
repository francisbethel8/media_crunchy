import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/video_model.dart';

class VideoCard extends StatelessWidget {
  final VideoModel video;

  const VideoCard({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/watch', extra: video);
      },

      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),

        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(16),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),

                child: const Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),

              child: Text(
                video.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
