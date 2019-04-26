import 'package:flutter/material.dart';
import 'package:tedxhkpolyu/model/video_model.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoTile{
  
  Widget videoTile(VideoModel videoModel){
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
}