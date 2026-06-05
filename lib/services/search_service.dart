import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/video_model.dart';

final searchServiceProvider = Provider<SearchService>((ref) => SearchService());

// Search results for a given query (family)
final searchResultsProvider = FutureProvider.family<List<VideoModel>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) return [];
  final service = ref.watch(searchServiceProvider);
  return service.searchVideos(query);
});

class SearchService {
  SupabaseClient get client => Supabase.instance.client;

  Future<List<VideoModel>> searchVideos(String query) async {
    if (query.isEmpty) return [];

    // Search on published videos (simple filter search)
    final response = await client
        .from('videos')
        .select('*, episodes(*)')
        .eq('status', 'Published')
        .limit(50);

    final data = response as List<dynamic>?;
    if (data == null) {
      return [];
    }

    // Filter locally for case-insensitive title/description search
    return data
        .map(
          (item) => VideoModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .where(
          (video) =>
              video.title.toLowerCase().contains(query.toLowerCase()) ||
              (video.description.toLowerCase().contains(query.toLowerCase()) ??
                  false),
        )
        .toList();
  }

  Future<List<VideoModel>> getVideosByCategory(String category) async {
    final response = await client
        .from('videos')
        .select('*, episodes(*)')
        .eq('category', category)
        .eq('status', 'Published')
        .order('created_at', ascending: false)
        .limit(50);

    final data = response as List<dynamic>?;
    if (data == null) {
      return [];
    }

    return data.map((item) {
      return VideoModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }

  Future<List<VideoModel>> getVideosByTag(String tag) async {
    final response = await client
        .from('videos')
        .select('*, episodes(*)')
        .contains('tags', [tag])
        .eq('status', 'Published')
        .order('created_at', ascending: false)
        .limit(50);

    final data = response as List<dynamic>?;
    if (data == null) {
      return [];
    }

    return data.map((item) {
      return VideoModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }

  Future<List<VideoModel>> getVideosByCreator(String creatorId) async {
    final response = await client
        .from('videos')
        .select('*, episodes(*)')
        .eq('creator_id', creatorId)
        .eq('status', 'Published')
        .order('created_at', ascending: false)
        .limit(50);

    final data = response as List<dynamic>?;
    if (data == null) {
      return [];
    }

    return data.map((item) {
      return VideoModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }

  Future<List<VideoModel>> getTrendingVideos({int limit = 20}) async {
    final response = await client
        .from('videos')
        .select('*, episodes(*)')
        .eq('status', 'Published')
        .order('views', ascending: false)
        .limit(limit);

    final data = response as List<dynamic>?;
    if (data == null) {
      return [];
    }

    return data.map((item) {
      return VideoModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }

  Future<List<VideoModel>> getTopRatedVideos({int limit = 20}) async {
    final response = await client
        .from('videos')
        .select('*, episodes(*)')
        .eq('status', 'Published')
        .order('rating', ascending: false)
        .limit(limit);

    final data = response as List<dynamic>?;
    if (data == null) {
      return [];
    }

    return data.map((item) {
      return VideoModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }

  Future<List<String>> getAllCategories() async {
    final response = await client
        .from('videos')
        .select('category')
        .eq('status', 'Published');

    final data = response as List<dynamic>?;
    if (data == null) {
      return [];
    }

    // Get unique categories
    final categories = <String>{};
    for (final item in data) {
      final category = (item as Map<String, dynamic>)['category'] as String?;
      if (category != null) categories.add(category);
    }
    return categories.toList();
  }

  Future<List<String>> getPopularTags({int limit = 30}) async {
    final response = await client
        .from('videos')
        .select('tags')
        .eq('status', 'Published')
        .limit(1000);

    final data = response as List<dynamic>?;
    if (data == null) {
      return [];
    }

    // Flatten and count tags
    final tagCounts = <String, int>{};
    for (final item in data) {
      final tags = List<String>.from(
        (item as Map<String, dynamic>)['tags'] as List? ?? [],
      );
      for (final tag in tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }

    // Sort by count and return top ones
    final sorted = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(limit).map((e) => e.key).toList();
  }
}
