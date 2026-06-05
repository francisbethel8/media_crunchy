import '../models/video_model.dart';
import '../models/episode_model.dart';

final List<VideoModel> fakeVideos = [
  VideoModel(
    id: 'cyber-samurai',
    title: 'Cyber Samurai',
    description: 'A futuristic warrior fights rogue AI forces in a neon city.',
    thumbnail:
        'https://images.unsplash.com/photo-1512428559087-560fa5ceab42?auto=format&fit=crop&w=800&q=80',
    videoUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    duration: const Duration(minutes: 14),
    rating: 4.8,
    category: 'AI Anime',
    creatorId: 'aurora-studio',
    creatorName: 'Aurora Studio',
    status: 'Published',
    views: 0,
    likesCount: 0,
    commentsCount: 0,
    episodesCount: 3,
    createdAt: DateTime.now(),
    episodes: [
      EpisodeModel(episodeNumber: 1, title: 'Episode 1'),
      EpisodeModel(episodeNumber: 2, title: 'Episode 2'),
      EpisodeModel(episodeNumber: 3, title: 'Episode 3'),
    ],
  ),
  VideoModel(
    id: 'neon-future',
    title: 'Neon Future',
    description: 'A cyberpunk city struggles against machine rule.',
    thumbnail:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=800&q=80',
    videoUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    duration: const Duration(minutes: 22),
    rating: 4.6,
    category: 'Cyberpunk',
    creatorId: 'neon-labs',
    creatorName: 'Neon Labs',
    status: 'Published',
    views: 0,
    likesCount: 0,
    commentsCount: 0,
    episodesCount: 4,
    createdAt: DateTime.now(),
    episodes: [
      EpisodeModel(episodeNumber: 1, title: 'Episode 1'),
      EpisodeModel(episodeNumber: 2, title: 'Episode 2'),
      EpisodeModel(episodeNumber: 3, title: 'Episode 3'),
      EpisodeModel(episodeNumber: 4, title: 'Episode 4'),
    ],
  ),
  VideoModel(
    id: 'ai-wars',
    title: 'AI Wars',
    description: 'Humans battle sentient AI armies in a desperate war.',
    thumbnail:
        'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
    videoUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    duration: const Duration(minutes: 18),
    rating: 4.9,
    category: 'Action',
    creatorId: 'titan-engine',
    creatorName: 'Titan Engine',
    status: 'Published',
    views: 0,
    likesCount: 0,
    commentsCount: 0,
    episodesCount: 3,
    createdAt: DateTime.now(),
    episodes: [
      EpisodeModel(episodeNumber: 1, title: 'Episode 1'),
      EpisodeModel(episodeNumber: 2, title: 'Episode 2'),
      EpisodeModel(episodeNumber: 3, title: 'Episode 3'),
    ],
  ),
];
