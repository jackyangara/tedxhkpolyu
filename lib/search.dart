import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tedxhkpolyu/model/blog_db.dart';
import 'package:tedxhkpolyu/model/video_model.dart';
import 'package:tedxhkpolyu/blog.dart';
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState(){
    return new _SearchPageState();
  } 
}

class _SearchPageState extends State<SearchPage> {
  BlogPageState blogPageState = new BlogPageState();
  final TextEditingController _textController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return 
    ListView(children: <Widget>[
      _searchBar()
      ,
      FutureBuilder(
      future: blogPageState.createBlogsWidget("Data Analytics"),
      builder: (_,snapshot){
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          //Process to get videos and blogs
          List<Widget> result = snapshot.data;
          return Container(
          color: Colors.white,
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal:7.0,
              ),
              children: result,
            ),
          );
        }
      }
    )
    ],);
    
  }
  

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

  PreferredSize _searchBar(){

    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
        child: Container(
          margin: EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            bottom: 5.0,),
          decoration: BoxDecoration(
            
            border: Border(
              top: BorderSide(width: 0.5, color: Color(0xFFFF888888)),
              left: BorderSide(width: 0.5, color: Color(0xFFFF888888)),
              right: BorderSide(width: 0.5, color: Color(0xFFFF888888)),
              bottom: BorderSide(width: 0.5, color: Color(0xFFFF888888)),
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          padding: const EdgeInsets.symmetric(
            horizontal:7.0,
          ),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              icon: Icon(Icons.search),
              border: InputBorder.none,
              hintText: "test",
            ),
          ),
        ),
      ),
    );
  }
}