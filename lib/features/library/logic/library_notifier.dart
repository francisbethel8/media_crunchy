import 'package:flutter_riverpod/legacy.dart';

import 'package:media_crunchy/features/auth/logic/auth_notifier.dart';
import 'package:media_crunchy/models/video_model.dart';
import 'package:media_crunchy/services/auth_service.dart';
import 'package:media_crunchy/services/supabase_service.dart';

class LibraryNotifier extends StateNotifier<List<VideoModel>> {
  LibraryNotifier(this._authService, this._supabaseService) : super([]);

  final AuthService _authService;
  final SupabaseService _supabaseService;

  Future<void> loadLibrary() async {
    final user = _authService.currentUser;
    if (user == null) {
      state = [];
      return;
    }

    final savedVideos = await _supabaseService.fetchSavedVideos(user.id);
    state = savedVideos;
  }

  Future<void> addVideo(VideoModel video) async {
    final user = _authService.currentUser;
    if (user == null || state.any((item) => item.id == video.id)) return;

    await _supabaseService.saveVideoForUser(user.id, video);
    state = [...state, video];
  }

  Future<void> removeVideo(String id) async {
    final user = _authService.currentUser;
    if (user == null) return;

    await _supabaseService.removeSavedVideo(user.id, id);
    state = state.where((video) => video.id != id).toList();
  }
}

final libraryProvider =
    StateNotifierProvider<LibraryNotifier, List<VideoModel>>((ref) {
      final notifier = LibraryNotifier(
        ref.read(authServiceProvider),
        ref.read(supabaseServiceProvider),
      );

      ref.listen<AuthState>(authNotifierProvider, (previous, next) {
        if (previous?.user?.id != next.user?.id) {
          notifier.loadLibrary();
        }
      });

      notifier.loadLibrary();
      return notifier;
    });
