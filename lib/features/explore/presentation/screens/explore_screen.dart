import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/video_model.dart';
import '../../../../services/search_service.dart';
import '../../../../shared/widgets/video_card.dart';

final trendingVideosProvider = FutureProvider<List<VideoModel>>((ref) async {
  final searchService = ref.watch(searchServiceProvider);
  return searchService.getTrendingVideos();
});

final topRatedVideosProvider = FutureProvider<List<VideoModel>>((ref) async {
  final searchService = ref.watch(searchServiceProvider);
  return searchService.getTopRatedVideos();
});

final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final searchService = ref.watch(searchServiceProvider);
  return searchService.getAllCategories();
});

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trendingAsync = ref.watch(trendingVideosProvider);
    final topRatedAsync = ref.watch(topRatedVideosProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search videos...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            // Search results
            if (_searchQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Search Results',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Consumer(
                      builder: (context, ref, _) {
                        final searchAsync = ref.watch(
                          searchResultsProvider(_searchQuery),
                        );
                        return searchAsync.when(
                          data: (results) {
                            if (results.isEmpty) {
                              return const Text('No results found');
                            }
                            return Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: results.take(6).map((video) {
                                return SizedBox(
                                  width: 140,
                                  child: VideoCard(video: video),
                                );
                              }).toList(),
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (error, st) => Text('Error: $error'),
                        );
                      },
                    ),
                  ],
                ),
              ),

            if (_searchQuery.isEmpty) ...[
              // Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    categoriesAsync.when(
                      data: (categories) {
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: categories.map((category) {
                            return FilterChip(
                              label: Text(category),
                              onSelected: (selected) {
                                setState(() {
                                  _searchQuery = 'category:$category';
                                  _searchController.text = _searchQuery;
                                });
                              },
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const SizedBox(
                        height: 40,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (error, st) => Text('Error: $error'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Trending section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  'Trending Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              trendingAsync.when(
                data: (videos) {
                  return SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        return VideoCard(video: videos[index]);
                      },
                    ),
                  );
                },
                loading: () => const SizedBox(
                  height: 280,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, st) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error: $error'),
                ),
              ),

              const SizedBox(height: 24),

              // Top Rated section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  'Top Rated',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              topRatedAsync.when(
                data: (videos) {
                  return SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        return VideoCard(video: videos[index]);
                      },
                    ),
                  );
                },
                loading: () => const SizedBox(
                  height: 280,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, st) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error: $error'),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}
