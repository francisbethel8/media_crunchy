class EpisodeModel {
  final String? id;
  final int episodeNumber;
  final String title;
  final String? thumbnail;
  final String? videoUrl;
  final int? durationSeconds;

  EpisodeModel({
    this.id,
    required this.episodeNumber,
    required this.title,
    this.thumbnail,
    this.videoUrl,
    this.durationSeconds,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id']?.toString(),
      episodeNumber: (json['episode_number'] as num).toInt(),
      title: json['title'] as String? ?? 'Episode ${json['episode_number']}',
      thumbnail: json['thumbnail'] as String?,
      videoUrl: json['video_url'] as String?,
      durationSeconds: json['duration'] == null
          ? null
          : (json['duration'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'episode_number': episodeNumber,
    'title': title,
    'thumbnail': thumbnail,
    'video_url': videoUrl,
    'duration': durationSeconds,
  };
}
