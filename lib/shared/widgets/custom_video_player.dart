import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const CustomVideoPlayer({super.key, required this.videoUrl});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController controller;
  bool errorLoading = false;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize()
          .then((_) {
            setState(() {});
          })
          .catchError((_) {
            setState(() {
              errorLoading = true;
            });
          });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (errorLoading) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'Unable to load video',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    if (!controller.value.isInitialized) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if (controller.value.isPlaying) {
                  controller.pause();
                } else {
                  controller.play();
                }
              });
            },
            icon: Icon(
              controller.value.isPlaying
                  ? Icons.pause_circle
                  : Icons.play_circle,
              size: 70,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
