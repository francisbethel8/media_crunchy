import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/video_model.dart';
import 'supabase_service.dart';

abstract class VideoService {
  Future<List<VideoModel>> fetchVideos();
  Future<List<VideoModel>> fetchVideosByCategory(String category);
}

final videoServiceProvider = Provider<VideoService>(
  (ref) => SupabaseVideoService(ref.read(supabaseServiceProvider)),
);

final videoListProvider = FutureProvider<List<VideoModel>>(
  (ref) => ref.watch(videoServiceProvider).fetchVideos(),
);

final videoCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final videos = await ref.watch(videoListProvider.future);
  return videos.map((video) => video.category).toSet().toList();
});

class SupabaseVideoService implements VideoService {
  SupabaseVideoService(this._supabaseService);

  final SupabaseService _supabaseService;

  @override
  Future<List<VideoModel>> fetchVideos() async {
    return _supabaseService.fetchVideos();
  }

  @override
  Future<List<VideoModel>> fetchVideosByCategory(String category) async {
    final response = await _supabaseService.client
        .from('videos')
        .select()
        .eq('category', category);

    final data = response as List<dynamic>?;
    if (data == null) {
      return [];
    }

    return data.map((item) {
      return VideoModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }
}
