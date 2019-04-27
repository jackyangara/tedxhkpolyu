import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tedxhkpolyu/model/video_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tedxhkpolyu/videotile.dart';

class NewestTab extends StatelessWidget {

  static const double padding = 5.0;

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
            padding: const EdgeInsets.all(padding),
            itemBuilder: (_, index) {
              var videoModel = videos[index];
              return videoTile.videoTile(videoModel);
            },
          );
        }
      },
    );
  }


  
  //TODO: put in last 6 hours ago uploaded
  ///Mock load data from Backend
  Future<List<VideoModel>> _loadVideos() async {
    // String readTimestamp(int timestamp) {
    //   var now = new DateTime.now();
    //   var format = new DateFormat('HH:mm a');
    //   var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    //   var diff = now.difference(date);
    //   var time = '';

    //   if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
    //     time = format.format(date);
    //   } else if (diff.inDays > 0 && diff.inDays < 7) {
    //     if (diff.inDays == 1) {
    //       time = diff.inDays.toString() + ' DAY AGO';
    //     } else {
    //       time = diff.inDays.toString() + ' DAYS AGO';
    //     }
    //   } else {
    //     if (diff.inDays == 7) {
    //       time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
    //     } else {

    //       time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
    //     }
    //   }

    //   return time;
    // }
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

//  static const TextStyle _whiteText = TextStyle(color: Colors.white, );
}
