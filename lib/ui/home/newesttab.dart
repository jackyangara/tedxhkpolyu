import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tedxhkpolyu/model/video_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
              return _videoTile(videoModel);
            },
          );
        }
      },
    );
  }

  Widget _videoTile(VideoModel videoModel){
    var durationMin = (videoModel.duration / 60).round();
    var durationSec = videoModel.duration % 60;

    return Padding(
      ///Think of this padding as spacing between items
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () => _openVideoUrl(videoModel.videoUrl),

        ///Text widgets on top of Image
        child: Stack(
          ///Position ListTile to bottom of Stack
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[

            Image.network(videoModel.videoThumbUrl,
              width: double.infinity,
              height: 200.0,
              fit: BoxFit.fitWidth,
            ),

            ///ListTile containing Text Widgets
            ListTile(
              contentPadding: EdgeInsets.only(bottom: 5.0, left: 8.0),
              title: _videoAuthor(videoModel.author),
              subtitle: _videoTitle(videoModel.title),

              ///Trailing is the space at the end of ListTile
              trailing: Column(
                children: <Widget>[
                  _overflowButton(),
                  _videoDuration('$durationMin:$durationSec'),
                ],
              ),
            )



          ],
        ),
      ),
    );
  }


  ///Package url_launcher
  ///https://github.com/flutter/plugins/tree/master/packages/url_launcher
  ///
  ///Troubleshooting
  ///If you encountered MissingPluginException: https://github.com/flutter/flutter/issues/10967
  void _openVideoUrl(String url) async {
    if (await canLaunch(url)) {
    await launch(url);
    } else {
    throw 'Could not launch $url';
    }
  }

  Widget _overflowButton() =>
      PopupMenuButton(
        icon: Icon(Icons.more_vert, color: Colors.white,),
        itemBuilder: (_) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: '1',
            child: Text('Option 1'),
          ),
          const PopupMenuItem<String>(
            value: '2',
            child: Text('Option 2',),
          )
        ],
      );

  Text _videoTitle(String title) =>
      Text(title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
          fontSize: 15.0,
          color: Colors.white,
          fontWeight: FontWeight.bold)
      );

  Text _videoAuthor(String author) =>
      Text(author,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.white)
      );

  Text _videoDuration(String duration) =>
      Text(duration,
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.white,
              fontWeight: FontWeight.w300)
      );
  //TODO: put in last 6 hours ago uploaded
  ///Mock load data from Backend
  Future<List<VideoModel>> _loadVideos() async {
    await Future.delayed(Duration(milliseconds: 1000));

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
    return res;
  }

//  static const TextStyle _whiteText = TextStyle(color: Colors.white, );
}
