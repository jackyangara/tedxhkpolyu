import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
                  _overflowButton(videoModel.videoUrl),
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

  Widget _overflowButton(url) =>
      PopupMenuButton(
        icon: Icon(Icons.more_vert, color: Colors.white,),
        itemBuilder: (_) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: '1',
            child: GestureDetector(
              child: Text('Add to My List'),
              onTap: (){_addToList(url);},
              
            ),
          )
        
        ],
      );

  _addToList(url) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'myList';
    List<String> value = prefs.getStringList(key) ?? [url.toString()];
    value.add(url);
    prefs.setStringList(key, value);
    print(value.length);
  }

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
