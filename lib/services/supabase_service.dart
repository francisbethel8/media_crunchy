import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/video_model.dart';

class SupabaseService {
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(url: url, anonKey: anonKey);
  }

  SupabaseClient get client => Supabase.instance.client;

  Future<List<VideoModel>> fetchVideos() async {
    final response = await client.from('videos').select();

    final data = response as List<dynamic>?;
    if (data == null) {
      return [];
    }

    return data.map((item) {
      return VideoModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }

  Future<void> createVideo(VideoModel video) async {
    await client.from('videos').insert(video.toJson());
  }
}
