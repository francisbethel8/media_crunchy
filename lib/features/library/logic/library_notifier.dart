import 'package:flutter_riverpod/legacy.dart';

import 'package:media_crunchy/models/video_model.dart';

class LibraryNotifier extends StateNotifier<List<VideoModel>> {
  LibraryNotifier() : super([]);

  void addVideo(VideoModel video) {
    if (state.any((item) => item.id == video.id)) return;
    state = [...state, video];
  }

  void removeVideo(String id) {
    state = state.where((video) => video.id != id).toList();
  }
}

final libraryProvider =
    StateNotifierProvider<LibraryNotifier, List<VideoModel>>(
      (ref) => LibraryNotifier(),
    );
