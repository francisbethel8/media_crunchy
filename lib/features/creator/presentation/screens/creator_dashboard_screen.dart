import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:media_crunchy/features/auth/logic/auth_notifier.dart';
import 'package:media_crunchy/features/creator/logic/creator_notifier.dart';

class CreatorDashboardScreen extends ConsumerWidget {
  const CreatorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authNotifierProvider);
    final creatorId = auth.user?.id;

    if (creatorId == null) {
      return const Scaffold(body: Center(child: Text('Not authenticated')));
    }

    final videosAsync = ref.watch(creatorVideosProvider(creatorId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Creator Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).signOut();
              context.go('/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => context.push('/creator/upload'),
              child: const Text('Upload New Video'),
            ),
          ),
          Expanded(
            child: videosAsync.when(
              data: (videos) {
                if (videos.isEmpty) {
                  return const Center(
                    child: Text('No videos yet. Upload your first video!'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Image.network(
                          video.thumbnail,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        title: Text(video.title),
                        subtitle: Text(
                          'Status: ${video.status} • Views: ${video.views} • Likes: ${video.likesCount}',
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(child: Text('Edit')),
                            const PopupMenuItem(child: Text('View Analytics')),
                            const PopupMenuItem(child: Text('Delete')),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, st) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
