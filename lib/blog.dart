import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tedxhkpolyu/model/blog_db.dart';

class BlogPage extends StatefulWidget {
  //TODO: index- title subtitle 
  @override
  _BlogPageState createState(){
    return new _BlogPageState();
  }
}

class _BlogPageState extends State<BlogPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadBlogs(),
      builder: (_,snapshot){
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          final List<BlogDB> result = snapshot.data;
          List<Widget> listTiles = [];
          ListTile temp;
          BlogDB currentBlog;
          int i;
          for(i = 0; i < result.length; ++i){
            currentBlog = result[i];
            temp = new ListTile(
              leading: Icon(Icons.bookmark),
              title:Text(result[i].title, overflow: TextOverflow.ellipsis, maxLines: 1,), 
              subtitle: Text(result[i].subtitle),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BlogDetailPage(
                    blogDB: currentBlog,
                  )),
                );
              },
              
            );
            listTiles.add(temp);
            listTiles.add(Divider());
          }
          return Container(
          color: Colors.white,
            child: ListView(
              
              padding: const EdgeInsets.symmetric(
                horizontal:7.0,
              ),
              children: listTiles,
            ),
          );
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
}

class BlogDetailPage extends StatelessWidget {
  //TODO: Fix the font and positions
  final BlogDB blogDB;
  BlogDetailPage({this.blogDB});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: RichText(
          text: TextSpan(
            text: blogDB.title, 
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(text: blogDB.subtitle, style: TextStyle()),
              TextSpan(text: blogDB.content),
            ],
          ),
        ),
      ),
    );
  }
}
