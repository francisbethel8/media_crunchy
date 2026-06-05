import 'package:supabase_flutter/supabase_flutter.dart';

class EngagementService {
  SupabaseClient get client => Supabase.instance.client;

  // ===== LIKES =====
  Future<bool> isVideoLikedByUser(String videoId, String userId) async {
    final response = await client
        .from('likes')
        .select('id')
        .eq('video_id', videoId)
        .eq('user_id', userId)
        .maybeSingle();

    return response != null;
  }

  Future<void> likeVideo(String videoId, String userId) async {
    await client.from('likes').insert({
      'video_id': videoId,
      'user_id': userId,
      'episode_id': null,
    });
  }

  Future<void> unlikeVideo(String videoId, String userId) async {
    // Find the like row where episode_id is null and delete by id
    final rows = await client
        .from('likes')
        .select('id, episode_id')
        .eq('video_id', videoId)
        .eq('user_id', userId);
    final list = List<Map<String, dynamic>>.from(rows as List<dynamic>);
    for (final row in list) {
      if (row['episode_id'] == null) {
        await client.from('likes').delete().eq('id', row['id']);
        break;
      }
    }
  }

  Future<int> getVideoLikesCount(String videoId) async {
    final response = await client
        .from('likes')
        .select('episode_id')
        .eq('video_id', videoId);
    final list = List<Map<String, dynamic>>.from(response as List<dynamic>);
    return list.where((r) => r['episode_id'] == null).length;
  }

  Future<bool> isEpisodeLikedByUser(String episodeId, String userId) async {
    final response = await client
        .from('likes')
        .select('id')
        .eq('episode_id', episodeId)
        .eq('user_id', userId)
        .maybeSingle();

    return response != null;
  }

  Future<void> likeEpisode(String episodeId, String userId) async {
    await client.from('likes').insert({
      'video_id': null,
      'episode_id': episodeId,
      'user_id': userId,
    });
  }

  Future<void> unlikeEpisode(String episodeId, String userId) async {
    await client
        .from('likes')
        .delete()
        .eq('episode_id', episodeId)
        .eq('user_id', userId);
  }

  // ===== COMMENTS =====
  Future<List<Map<String, dynamic>>> getVideoComments(String videoId) async {
    final response = await client
        .from('comments')
        .select('*, users(username, avatar_url)')
        .eq('video_id', videoId)
        .order('created_at', ascending: false);
    final list = List<Map<String, dynamic>>.from(response as List<dynamic>);
    return list
        .where((c) => c['episode_id'] == null && c['parent_comment_id'] == null)
        .toList();
  }

  Future<List<Map<String, dynamic>>> getEpisodeComments(
    String episodeId,
  ) async {
    final response = await client
        .from('comments')
        .select('*, users(username, avatar_url)')
        .eq('episode_id', episodeId)
        .order('created_at', ascending: false);

    final list = List<Map<String, dynamic>>.from(response as List<dynamic>);
    return list.where((c) => c['parent_comment_id'] == null).toList();
  }

  Future<List<Map<String, dynamic>>> getCommentReplies(String commentId) async {
    final response = await client
        .from('comments')
        .select('*, users(username, avatar_url)')
        .eq('parent_comment_id', commentId)
        .order('created_at', ascending: true);

    return List<Map<String, dynamic>>.from(response as List<dynamic>);
  }

  Future<String?> addComment(
    String userId,
    String videoId, {
    String? episodeId,
    String? parentCommentId,
    required String content,
  }) async {
    final response = await client.from('comments').insert({
      'user_id': userId,
      'video_id': videoId,
      'episode_id': episodeId,
      'parent_comment_id': parentCommentId,
      'content': content,
      'likes_count': 0,
    }).select();

    if (response.isNotEmpty) {
      return (response.first)['id'] as String?;
    }
    return null;
  }

  Future<void> updateComment(String commentId, String content) async {
    await client
        .from('comments')
        .update({'content': content})
        .eq('id', commentId);
  }

  Future<void> deleteComment(String commentId) async {
    // Delete all replies first
    await client.from('comments').delete().eq('parent_comment_id', commentId);
    // Then delete the comment
    await client.from('comments').delete().eq('id', commentId);
  }

  Future<void> likeComment(String commentId, String userId) async {
    // Update comment's likes_count
    final comment = await client
        .from('comments')
        .select('likes_count')
        .eq('id', commentId)
        .single();

    await client
        .from('comments')
        .update({'likes_count': (comment['likes_count'] as int) + 1})
        .eq('id', commentId);
  }

  Future<void> unlikeComment(String commentId, String userId) async {
    // Update comment's likes_count
    final comment = await client
        .from('comments')
        .select('likes_count')
        .eq('id', commentId)
        .single();

    await client
        .from('comments')
        .update({
          'likes_count': ((comment['likes_count'] as int) - 1).clamp(0, 999999),
        })
        .eq('id', commentId);
  }

  // ===== VIEWS =====
  Future<void> incrementVideoViews(String videoId) async {
    final video = await client
        .from('videos')
        .select('views')
        .eq('id', videoId)
        .single();

    await client
        .from('videos')
        .update({'views': (video['views'] as int) + 1})
        .eq('id', videoId);
  }

  Future<void> incrementEpisodeViews(String episodeId) async {
    final episode = await client
        .from('episodes')
        .select('views')
        .eq('id', episodeId)
        .single();

    await client
        .from('episodes')
        .update({'views': (episode['views'] as int) + 1})
        .eq('id', episodeId);
  }
}
