import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:media_crunchy/models/video_model.dart';
import 'package:media_crunchy/services/supabase_service.dart';

// Provider for creator's videos
final creatorVideosProvider = FutureProvider.family<List<VideoModel>, String>((
  ref,
  creatorId,
) async {
  final supabase = ref.watch(supabaseServiceProvider);
  return supabase.fetchCreatorVideos(creatorId);
});

// Provider for pending videos (admin review)
final pendingVideosProvider = FutureProvider<List<VideoModel>>((ref) async {
  final supabase = ref.watch(supabaseServiceProvider);
  return supabase.fetchPendingVideos();
});

// Simple action providers for video submission
final submitVideoProvider = FutureProvider.family<String?, VideoModel>((
  ref,
  video,
) async {
  final supabase = ref.watch(supabaseServiceProvider);
  final videoId = await supabase.createVideoDraft(video);
  if (videoId != null && video.episodes.isNotEmpty) {
    await supabase.createEpisodesForVideo(videoId, video.episodes);
    await supabase.updateVideoStatus(videoId, 'Submitted');
  }
  return videoId;
});

// Simple action provider for updating video status
final updateVideoStatusProvider =
    FutureProvider.family<void, (String videoId, String status)>((
      ref,
      params,
    ) async {
      final supabase = ref.watch(supabaseServiceProvider);
      await supabase.updateVideoStatus(params.$1, params.$2);
    });

// Simple action provider for approving videos
final approveVideoProvider = FutureProvider.family<void, String>((
  ref,
  videoId,
) async {
  final supabase = ref.watch(supabaseServiceProvider);
  await supabase.updateVideoStatus(videoId, 'Published');
});

// Simple action provider for rejecting videos
final rejectVideoProvider =
    FutureProvider.family<void, (String videoId, String reason)>((
      ref,
      params,
    ) async {
      final supabase = ref.watch(supabaseServiceProvider);
      await supabase.updateVideoStatus(params.$1, 'Rejected');
    });
