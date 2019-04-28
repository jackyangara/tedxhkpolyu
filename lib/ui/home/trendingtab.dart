import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:tedxhkpolyu/model/video_model.dart';

import 'package:tedxhkpolyu/video.dart';

class TrendingTab extends StatefulWidget {
  static const double padding = 8.0;
  @override
  TrendingTabState createState() {
    return new TrendingTabState();
  }
}

class TrendingTabState extends State<TrendingTab> {
  VideoPlayerController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'http://techslides.com/demos/sample-videos/small.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///FutureBuilder doc: https://docs.flutter.io/flutter/widgets/FutureBuilder-class.html
    ///
    ///Pass in method to load data in future
    ///snapshot.hasData will return true if data is loaded
    ///Pass in loading animation when hasData returns false
    ///
    ///Kalo mau animasi lebi keren https://pub.dartlang.org/packages/shimmer
    
    Video video = new Video();
    return FutureBuilder(
      future: video.loadVideos(""),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          ///Retrieve data from snapshot
          final List<VideoModel> videos = snapshot.data;

          ///Build video tiles
          return ListView.builder(
            itemCount: snapshot.data.length,
            padding: const EdgeInsets.all(TrendingTab.padding),
            itemBuilder: (_, index) {
              var videoModel = videos[index];
              return video.videoTile(context, videoModel);
            },
          );
        }
      },
    );
  }

  
}
