import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatefulWidget {
  final Uri videoUrl;
  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late CachedVideoPlayerController _controller;
  late bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller =
        CachedVideoPlayerController.network(widget.videoUrl.toString())
          ..initialize().then((_) {
            setState(() {
              _controller.play();
              _isPlaying = true;
            });
          });
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: CachedVideoPlayer(_controller),
      ),
      Positioned(
        bottom: 8,
        right: 12,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color.fromARGB(100, 0, 0, 0),
          ),
          child: IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              size: 22,
              color: Colors.white, // Icon color
            ),
            onPressed: _togglePlayPause,
          ),
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
