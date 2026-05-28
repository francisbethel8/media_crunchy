import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/video_card.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../../../services/video_service.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosAsync = ref.watch(videoListProvider);
    final categoriesAsync = ref.watch(videoCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionTitle(title: 'Browse by Category'),
          categoriesAsync.when(
            data: (categories) => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categories
                  .map(
                    (category) => Chip(
                      label: Text(category),
                      backgroundColor: Colors.grey.shade900,
                    ),
                  )
                  .toList(),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('Failed to load categories: $error'),
          ),
          const SizedBox(height: 30),
          const SectionTitle(title: 'Top Picks'),
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
              child: Center(
                child: Text('Unable to load explore content: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
