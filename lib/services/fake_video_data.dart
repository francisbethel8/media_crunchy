import '../models/video_model.dart';

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
    creator: 'Aurora Studio',
    episodes: ['Episode 1', 'Episode 2', 'Episode 3'],
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
    creator: 'Neon Labs',
    episodes: ['Episode 1', 'Episode 2', 'Episode 3', 'Episode 4'],
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
    creator: 'Titan Engine',
    episodes: ['Episode 1', 'Episode 2', 'Episode 3'],
  ),
];
