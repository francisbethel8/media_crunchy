import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/continue_watching_card.dart';
import '../../../../shared/widgets/creator_card.dart';
import '../../../../shared/widgets/hero_banner.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../../../shared/widgets/video_card.dart';
import '../../../../services/video_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosAsync = ref.watch(videoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Media Crunchy',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const HeroBanner(),
          const SizedBox(height: 30),
          const SectionTitle(title: 'Continue Watching'),
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                ContinueWatchingCard(title: 'Cyber Samurai Ep 3'),
                ContinueWatchingCard(title: 'Neon Future Ep 7'),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const SectionTitle(title: 'Trending Picks'),
          videosAsync.when(
            data: (videos) => SizedBox(
              height: 280,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: videos
                    .map((video) => VideoCard(video: video))
                    .toList(),
              ),
            ),
            loading: () => SizedBox(
              height: 280,
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            error: (error, stack) => SizedBox(
              height: 280,
              child: Center(child: Text('Unable to load videos: $error')),
            ),
          ),
          const SizedBox(height: 30),
          const SectionTitle(title: 'Popular Creators'),
          SizedBox(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                CreatorCard(creatorName: 'Nova Arts'),
                SizedBox(width: 16),
                CreatorCard(creatorName: 'Aether Studio'),
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
