import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:media_crunchy/features/library/logic/library_notifier.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final library = ref.watch(libraryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Library')),
      body: library.isEmpty
          ? const Center(
              child: Text(
                'Your library is empty.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: library.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final video = library[index];
                return GestureDetector(
                  onTap: () => context.push('/watch', extra: video),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                video.creator,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ref
                                .read(libraryProvider.notifier)
                                .removeVideo(video.id);
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
