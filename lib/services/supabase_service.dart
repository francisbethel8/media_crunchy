import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/episode_model.dart';
import '../models/video_model.dart';
import '../models/user_profile_model.dart';
import 'fake_video_data.dart';

final supabaseServiceProvider = Provider<SupabaseService>(
  (ref) => SupabaseService(),
);

class SupabaseService {
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(url: url, anonKey: anonKey);
  }

  SupabaseClient get client => Supabase.instance.client;

  Future<List<VideoModel>> fetchVideos() async {
    return fetchPublishedVideos();
  }

  Future<List<VideoModel>> fetchPublishedVideos() async {
    final response = await client
        .from('videos')
        .select('*, episodes(*)')
        .eq('status', 'Published');

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

  Future<void> seedVideosIfEmpty() async {
    final response = await client.from('videos').select('id').limit(1);

    final existing = response as List<dynamic>?;
    if (existing != null && existing.isNotEmpty) {
      return;
    }

    for (final video in fakeVideos) {
      final videoMap = video.toJson();
      videoMap.remove('id');
      videoMap.remove('episodes');
      videoMap['status'] = 'Published';
      videoMap['views'] = 0;
      videoMap['likes_count'] = 0;
      videoMap['comments_count'] = 0;
      videoMap['episodes_count'] = video.episodes.length;

      final insertedVideo = await client
          .from('videos')
          .insert(videoMap)
          .select()
          .single();

      final String videoId = insertedVideo['id'] as String;

      final episodesPayload = video.episodes.map((ep) {
        return {
          'video_id': videoId,
          'episode_number': ep.episodeNumber,
          'title': ep.title,
          'thumbnail': ep.thumbnail ?? video.thumbnail,
          'video_url': ep.videoUrl ?? video.videoUrl,
          'duration': ep.durationSeconds ?? video.duration.inSeconds,
          'views': 0,
        };
      }).toList();

      if (episodesPayload.isNotEmpty) {
        await client.from('episodes').insert(episodesPayload);
      }
    }
  }

  Future<UserProfileModel?> fetchUserProfile(String userId) async {
    final Map<String, dynamic>? response = await client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) {
      return null;
    }
    return UserProfileModel.fromJson(response);
  }

  Future<UserProfileModel> ensureUserProfile(
    User user, {
    String role = 'viewer',
  }) async {
    final existing = await fetchUserProfile(user.id);
    if (existing != null) {
      return existing;
    }

    final username =
        user.email?.split('@').first ?? 'user_${user.id.substring(0, 8)}';
    final profile = {
      'id': user.id,
      'email': user.email,
      'username': username,
      'role': role,
      'avatar_url': null,
      'created_at': DateTime.now().toIso8601String(),
    };

    final insertResponse = await client.from('users').insert(profile).single();
    return UserProfileModel.fromJson(
      Map<String, dynamic>.from(insertResponse as Map),
    );
  }

  Future<List<VideoModel>> fetchPendingVideos() async {
    final response = await client
        .from('videos')
        .select('*, episodes(*)')
        .eq('status', 'Submitted');

    final data = response as List<dynamic>?;
    if (data == null) {
      return [];
    }
    return data.map((item) {
      return VideoModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }

  Future<void> updateVideoStatus(String videoId, String status) async {
    await client.from('videos').update({'status': status}).eq('id', videoId);
  }

  Future<List<VideoModel>> fetchCreatorVideos(String creatorId) async {
    final response = await client
        .from('videos')
        .select('*, episodes(*)')
        .eq('creator_id', creatorId);

    final data = response as List<dynamic>?;
    if (data == null) {
      return [];
    }
    return data.map((item) {
      return VideoModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }

  Future<String?> createVideoDraft(VideoModel video) async {
    final videoMap = video.toJson();
    videoMap.remove('id');
    videoMap.remove('episodes');
    videoMap['status'] = 'Draft';
    videoMap['views'] = 0;
    videoMap['likes_count'] = 0;
    videoMap['comments_count'] = 0;
    videoMap['episodes_count'] = video.episodes.length;

    final Map<String, dynamic> response = await client
        .from('videos')
        .insert(videoMap)
        .select()
        .single();
    return response['id'] as String?;
  }

  Future<void> createEpisodesForVideo(
    String videoId,
    List<EpisodeModel> episodes,
  ) async {
    final episodesPayload = episodes.map((ep) {
      return {
        'video_id': videoId,
        'episode_number': ep.episodeNumber,
        'title': ep.title,
        'thumbnail': ep.thumbnail,
        'video_url': ep.videoUrl,
        'duration': ep.durationSeconds,
        'views': 0,
      };
    }).toList();

    if (episodesPayload.isNotEmpty) {
      await client.from('episodes').insert(episodesPayload);
    }
  }

  Future<List<VideoModel>> fetchSavedVideos(String userId) async {
    final response = await client
        .from('saved_library')
        .select('video_data')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    final data = response as List<dynamic>?;
    if (data == null) {
      return [];
    }

    return data.map((item) {
      final videoData = Map<String, dynamic>.from(
        (item as Map<String, dynamic>)['video_data'] as Map,
      );
      return VideoModel.fromJson(videoData);
    }).toList();
  }

  Future<void> saveVideoForUser(String userId, VideoModel video) async {
    await client.from('saved_library').insert({
      'user_id': userId,
      'video_id': video.id,
      'video_data': video.toJson(),
    });
  }

  Future<void> removeSavedVideo(String userId, String videoId) async {
    await client
        .from('saved_library')
        .delete()
        .eq('user_id', userId)
        .eq('video_id', videoId);
  }
}
