import 'package:flutter/material.dart';

import '../../../../shared/widgets/creator_card.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../../../shared/widgets/video_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Media Crunchy',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          const SectionTitle(title: 'Trending AI Anime'),

          SizedBox(
            height: 240,

            child: ListView(
              scrollDirection: Axis.horizontal,

              children: const [
                VideoCard(title: 'Cyber Samurai'),

                VideoCard(title: 'Neon Future'),

                VideoCard(title: 'AI Wars'),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const SectionTitle(title: 'Popular Creators'),

          SizedBox(
            height: 130,

            child: ListView(
              scrollDirection: Axis.horizontal,

              children: const [
                CreatorCard(creatorName: 'Aether Studio'),

                SizedBox(width: 16),

                CreatorCard(creatorName: 'Nova Arts'),

                SizedBox(width: 16),

                CreatorCard(creatorName: 'Future Frames'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
