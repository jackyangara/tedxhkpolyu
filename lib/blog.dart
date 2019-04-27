import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tedxhkpolyu/model/blog_db.dart';

class BlogPage extends StatefulWidget {
  //TODO: index- title subtitle 
  @override
  BlogPageState createState(){
    return new BlogPageState();
  }
}

class BlogPageState extends State<BlogPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: createBlogsWidget(""),
      builder: (_,snapshot){
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          final List<Widget> listTiles = snapshot.data;
          return Container(
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

  Future<List<Widget>> createBlogsWidget(String query) async {
    
    List<BlogDB> result = await loadBlogs(query);
    await Future.delayed(Duration(milliseconds: 50));
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
    
    return listTiles;
  }

  Future<List<BlogDB>> loadBlogs(String query) async {
    
    List<BlogDB> res = [];
    BlogDB temp;
    int i;
    String blog_id, title, subtitle, content;
    DocumentReference speaker_id, category_id;
    int numberOfLikes;
    List<dynamic> comment_id;
    Timestamp created_at;
    Firestore.instance.collection("blogs")
    .snapshots().listen((data) =>{
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
    await Future.delayed(Duration(milliseconds: 2000));
    // return res.isEmpty?Container():res;
    if(query==""){
      return res;
    }
    else{
      List<BlogDB> resQuery = [];
      for(i = 0; i < res.length; i++){
        if(
        res[i].subtitle.contains(query) || 
        res[i].title.contains(query) ||
        res[i].content.contains(query) ||
        res[i].category_id.documentID.toString().contains(query) ||
        res[i].speaker_id.documentID.toString().contains(query)
        ){
          resQuery.add(res[i]);
        }
      }
      print("This is: "+query);
      return resQuery;
    }
    
  }
}

class BlogDetailPage extends StatelessWidget {
  //TODO: Fix the font and positions
  final BlogDB blogDB;
  BlogDetailPage({this.blogDB});

  final TextStyle titleStyle = TextStyle(fontSize: 30.0, fontFamily: 'CharterITC', fontWeight: FontWeight.w500);
  final TextStyle contentStyle = TextStyle(fontSize: 16.0, fontFamily: 'Kievit', height: 1.5);
  
  @override
  Widget build(BuildContext context) {
    Color iconColor = DynamicTheme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: iconColor),
      ),
      body: _buildBody()
    );
  }

  Widget _buildBody(){
    return ListView(
      padding: EdgeInsets.all(12.0),
      children: <Widget>[
        Text(blogDB.title, style: titleStyle,),
        Text('\n', style: TextStyle(fontSize: 8.0),),
        Text(blogDB.content, style: contentStyle,),
      ],
    );
  }

}
