import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tedxhkpolyu/model/video_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Video{


  

  Future<List<VideoModel>> loadVideos(String query) async {
    //TODO: ADD IMAGE_URL TO FIRESTORE

    List<VideoModel> res = [];
    int i, _numberOfLikes;
    
    VideoModel temp;
    String _title, _author, _videoUrl, _videoThumbUrl, _category;
    DocumentReference speakerRef;
    DocumentReference categoryRef;
    int _duration;
        Firestore.instance.collection('videos').snapshots().listen((data) =>{
          data.documents.forEach((doc) => {
            _title = doc["title"],
            speakerRef = doc["speaker_id"],
            _author = speakerRef.documentID.toString(),
            _videoUrl = doc["video_url"],
            _videoThumbUrl = doc["thumbnail_url"],
            _duration = doc["duration"],
            categoryRef = doc["category_id"],
            _category = categoryRef.documentID.toString(),
            _numberOfLikes = doc["numberOfLikes"],
            temp = new VideoModel(_title, _author, _videoUrl, _videoThumbUrl, _duration, _category,_numberOfLikes),
            res.add(temp),
      })
    });
    await Future.delayed(Duration(milliseconds: 2000));
    if(query==""){
      return res;
    }
    else{
      List<VideoModel> resQuery = [];
      for(i = 0; i < res.length; i++){
        if(
        res[i].author.contains(query) || 
        res[i].title.contains(query) ||
        res[i].category.contains(query)
        ){
          resQuery.add(res[i]);
        }
      }
      return resQuery;
    }
    
  }
  Widget videoTile(context, VideoModel videoModel){
    var durationMin = (videoModel.duration / 60).round();
    var durationSec = videoModel.duration % 60;
    
    return Padding(
      ///Think of this padding as spacing between items
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () => _openVideoUrl(context, videoModel.videoUrl),

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
                  _overflowButton(context, videoModel.videoUrl),
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
  void _openVideoUrl(context, String url) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'history';
    List<String> value = prefs.getStringList(key) ?? [];
    if(value.isEmpty){
      value.add(url);
    }
    else if(value.contains(url))
    {
      if(value[0] != url){
        value.remove(url);
        value.insert(0, url);
      }
    }
    else{
      value.add(url);
    }
    prefs.setStringList(key, value);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _overflowButton(context, url) =>
      PopupMenuButton(
        icon: Icon(Icons.more_vert, color: Colors.white,),
        itemBuilder: (_) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: '1',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Text('Add to My List'),
              onTap: (){_addToList(context, url);
        },
              
            ),
          )
        
        ],
      );

  void _closeDialog(context) async{
    await new Future.delayed(const Duration(milliseconds: 750));
    Navigator.of(context).pop();
  }
  void _showDialog(contextP,text) async {
    
    // flutter defined function
    showDialog(
      context: contextP,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Center(child:Text(text), heightFactor: 2.0, widthFactor: 0.6,),
          content: new Center(child:Icon(Icons.receipt),heightFactor: 2.0,widthFactor: 0.6),
        );
        // return object of type Dialog
          
      },
    );
  }
  _addToList(context, url) async {
    Navigator.of(context).pop();
    final prefs = await SharedPreferences.getInstance();
    final key = 'myList';
    List<String> value = prefs.getStringList(key) ?? [];
    if(value.isEmpty){
      _showDialog(context, 'Added to Your List'); _closeDialog(context);
      value.add(url);
    }
    else if(value.contains(url))
    {
      _showDialog(context, 'Item Exists'); _closeDialog(context);
    }
    else{
      _showDialog(context, 'Added to Your List'); _closeDialog(context);
      value.add(url);
    }
    prefs.setStringList(key, value);
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
  Future<List<Widget>> createVideoWidget(context, String query) async {
    List<VideoModel> result = await loadVideos(query);
    await Future.delayed(Duration(milliseconds: 50));
    List<Widget> listTiles = [];
    ListTile temp;
    VideoModel currentVideo;
    int i;
    for(i = 0; i < result.length; ++i){
      currentVideo = result[i];
      temp = new ListTile(
        leading: Icon(Icons.video_library),
        title:Text(result[i].title, overflow: TextOverflow.ellipsis, maxLines: 1,), 
        subtitle: Text(result[i].author),
        onTap: () => _openVideoUrl(context, currentVideo.videoUrl),
      );
      listTiles.add(temp);
      listTiles.add(Divider());
    }
    return listTiles;
  }
}