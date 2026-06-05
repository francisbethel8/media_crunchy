import 'episode_model.dart';

class VideoModel {
  final String id;
  final String title;
  final String description;
  final String thumbnail;
  final String videoUrl;
  final Duration duration;
  final double rating;
  final String category;
  final String creatorId;
  final String creatorName;
  String get creator => creatorName;
  final String status;
  final int views;
  final int likesCount;
  final int commentsCount;
  final int episodesCount;
  final DateTime createdAt;
  final List<EpisodeModel> episodes;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.videoUrl,
    required this.duration,
    required this.rating,
    required this.category,
    required this.creatorId,
    required this.creatorName,
    required this.status,
    required this.views,
    required this.likesCount,
    required this.commentsCount,
    required this.episodesCount,
    required this.createdAt,
    required this.episodes,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    final episodesJson = json['episodes'];
    List<EpisodeModel> parsedEpisodes = [];
    if (episodesJson is List) {
      parsedEpisodes = episodesJson
          .map((e) => EpisodeModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return VideoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String,
      videoUrl: json['videoUrl'] as String,
      duration: Duration(seconds: (json['duration'] ?? 0) as int),
      rating: (json['rating'] as num).toDouble(),
      category: json['category'] as String,
      creatorId: json['creator_id'] as String? ?? '',
      creatorName:
          json['creator_name'] as String? ??
          json['creator'] as String? ??
          'Unknown',
      status: json['status'] as String? ?? 'Published',
      views: (json['views'] as num?)?.toInt() ?? 0,
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      commentsCount: (json['comments_count'] as num?)?.toInt() ?? 0,
      episodesCount:
          (json['episodes_count'] as num?)?.toInt() ?? parsedEpisodes.length,
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      episodes: parsedEpisodes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'videoUrl': videoUrl,
      'duration': duration.inSeconds,
      'rating': rating,
      'category': category,
      'creator_id': creatorId,
      'creator_name': creatorName,
      'status': status,
      'views': views,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'episodes_count': episodesCount,
      'created_at': createdAt.toIso8601String(),
      'episodes': episodes.map((e) => e.toJson()).toList(),
    };
  }
}
