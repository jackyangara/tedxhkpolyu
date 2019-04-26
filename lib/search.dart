import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tedxhkpolyu/model/blog_db.dart';
import 'package:tedxhkpolyu/model/video_model.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState(){
    return new _SearchPageState();
  } 
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadBlogs(),
      builder: (_,snapshot){
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          //Process to get videos and blogs
        }
      }
    );
  }
  
  Future<List<BlogDB>> _loadBlogs() async {
    await Future.delayed(Duration(milliseconds: 2000));
    List<BlogDB> res = [];
    BlogDB temp;
    String blog_id, title, subtitle, content;
    DocumentReference speaker_id, category_id;
    int numberOfLikes;
    List<dynamic> comment_id;
    Timestamp created_at;
    Firestore.instance.collection("blogs").snapshots().listen((data) =>{
      data.documents.forEach((doc) => {
        blog_id = doc.documentID.toString(),
        title = doc["title"],
        subtitle = doc["subtitle"],
        content = doc["content"],
        speaker_id = doc["speaker_id"],
        category_id = doc["category_id"],
        numberOfLikes = doc["numberOfLikes"],
        comment_id = doc["comment_id"],
        created_at = doc["created_at"],
        temp = new BlogDB(blog_id, title, subtitle, content, speaker_id, category_id, numberOfLikes, comment_id, created_at),
        res.add(temp),
      })
    });
    return res;
  }
  Future<List<VideoModel>> _loadVideos() async {
    //TODO: fetch data firebase
    await Future.delayed(Duration(milliseconds: 2000));

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
}