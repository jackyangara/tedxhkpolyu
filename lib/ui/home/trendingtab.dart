import 'dart:async';
import 'package:tedxhkpolyu/video.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:tedxhkpolyu/model/video_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tedxhkpolyu/videotile.dart';

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
    
    VideoTile videoTile = new VideoTile();
    
    return FutureBuilder(
      future: _loadVideos(),
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
              return videoTile.videoTile(videoModel);
            },
          );
        }
      },
    );
  }

  ///Mock load data from Backend
  Future<List<VideoModel>> _loadVideos() async {
    //TODO: fetch data firebase

    final url = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";
    final imageUrl = 'https://yt3.ggpht.com/a-/AAuE7mAu_-wIFvVO-HT01aQiwmI4GHd_aEXw3HQ-OA=s900-mo-c-c0xffffffff-rj-k-no';
    List<VideoModel> res = [];
    VideoModel temp;
    String _title, _author, _videoUrl, _videoThumbUrl;
    DocumentReference speakerRef;
    int _duration;
        Firestore.instance.collection('videos').snapshots().listen((data) =>{
          data.documents.forEach((doc) => {
            _title = doc["title"],
            speakerRef = doc["speaker_id"],
            _author = speakerRef.documentID.toString(),
            _videoUrl = doc["video_url"],
            _videoThumbUrl = imageUrl,
            _duration = doc["duration"],
            temp = new VideoModel(_title, _author, _videoUrl, _videoThumbUrl, _duration),
            res.add(temp),
      })
    });
    await Future.delayed(Duration(milliseconds: 2000));

    return res;
  }
}
