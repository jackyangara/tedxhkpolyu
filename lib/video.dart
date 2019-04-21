import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tedxhkpolyu/fade_animation.dart';
import 'package:video_player/video_player.dart';


class VideoPage extends StatefulWidget {
  @override
  VideoPageState createState() {
    return new VideoPageState();
  }
}

class VideoPageState extends State<VideoPage> {
  VideoPlayerController _controller;
  bool _isPlaying = false;

  Widget videoStatusAnimation;

  @override
  void initState() {
    super.initState();

    videoStatusAnimation = Container();

    _controller = VideoPlayerController.network(
        'http://techslides.com/demos/sample-videos/small.mp4')
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize().then((_) {
        Timer(Duration(milliseconds: 1500), () {
          if (!mounted) return;

          setState(() {});
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 16/9,
        child: _controller.value.initialized
            ? videoPlayer()
            : CircularProgressIndicator(),
      );

  Widget videoPlayer() => Stack(
        children: <Widget>[
          video(),
          Align(
            alignment: Alignment.bottomCenter,
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              padding: EdgeInsets.all(16.0),
            ),
          ),
          Center(child: videoStatusAnimation),
        ],
      );

  Widget video() => GestureDetector(
        child: VideoPlayer(_controller),
        onTap: () {
          if (!_controller.value.initialized) {
            return;
          }
          if (_controller.value.isPlaying) {
            videoStatusAnimation =
                FadeAnimation(child: const Icon(Icons.pause, size: 100.0));
            _controller.pause();
          } else {
            videoStatusAnimation =
                FadeAnimation(child: const Icon(Icons.play_arrow, size: 100.0));
            _controller.play();
          }
        },
      );
}