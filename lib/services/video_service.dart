import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/video_model.dart';
import 'fake_video_data.dart';

abstract class VideoService {
  Future<List<VideoModel>> fetchVideos();
  Future<List<VideoModel>> fetchVideosByCategory(String category);
}

final videoServiceProvider = Provider<VideoService>(
  (ref) => FakeVideoService(),
);

final videoListProvider = FutureProvider<List<VideoModel>>(
  (ref) => ref.watch(videoServiceProvider).fetchVideos(),
);

final videoCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final videos = await ref.watch(videoListProvider.future);
  return videos.map((video) => video.category).toSet().toList();
});

class FakeVideoService implements VideoService {
  @override
  Future<List<VideoModel>> fetchVideos() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return fakeVideos;
  }

  @override
  Future<List<VideoModel>> fetchVideosByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return fakeVideos.where((video) => video.category == category).toList();
  }
}
