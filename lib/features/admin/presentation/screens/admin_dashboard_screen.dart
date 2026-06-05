import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:media_crunchy/features/auth/logic/auth_notifier.dart';
import 'package:media_crunchy/features/creator/logic/creator_notifier.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authNotifierProvider);

    if (auth.profile?.role != 'admin') {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin Dashboard')),
        body: const Center(child: Text('Access denied. Admin only.')),
      );
    }

    final pendingAsync = ref.watch(pendingVideosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => context.push('/admin/reviews'),
                  child: _DashboardCard(
                    title: 'Content Review Queue',
                    icon: Icons.list_alt,
                    subtitle: 'Pending submissions',
                  ),
                ),
                _DashboardCard(
                  title: 'Users',
                  icon: Icons.people,
                  subtitle: 'Manage users',
                ),
                _DashboardCard(
                  title: 'Analytics',
                  icon: Icons.analytics,
                  subtitle: 'View stats',
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pending Content',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: pendingAsync.when(
              data: (videos) {
                if (videos.isEmpty) {
                  return const Center(
                    child: Text('No pending content. All caught up!'),
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
                        subtitle: Text('By ${video.creatorName}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                ref.read(approveVideoProvider(video.id));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Video approved!'),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                ref.read(
                                  rejectVideoProvider((
                                    video.id,
                                    'Admin decision',
                                  )),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Video rejected!'),
                                  ),
                                );
                              },
                            ),
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

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String subtitle;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 40, color: Colors.blue),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
