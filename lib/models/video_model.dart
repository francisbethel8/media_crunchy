class VideoModel {
  final String id;
  final String title;
  final String description;
  final String thumbnail;
  final String videoUrl;
  final Duration duration;
  final double rating;
  final String category;
  final String creator;
  final List<String> episodes;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.videoUrl,
    required this.duration,
    required this.rating,
    required this.category,
    required this.creator,
    required this.episodes,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String,
      videoUrl: json['videoUrl'] as String,
      duration: Duration(seconds: json['duration'] as int),
      rating: (json['rating'] as num).toDouble(),
      category: json['category'] as String,
      creator: json['creator'] as String,
      episodes: List<String>.from(json['episodes'] as List<dynamic>),
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
      'creator': creator,
      'episodes': episodes,
    };
  }
}
