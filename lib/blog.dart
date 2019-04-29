import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      future: loadBlogs(""),
      builder: (_,snapshot){
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {

          //Obtain blogs loaded from loadBlogs
          final List<BlogDB> blogDBs = snapshot.data;

          //Create a ListView with separator,
          //With length equal to number of blogs
          //And returns a ListTile for each blog (see itemBuilder)
          return ListView.separated(
            itemCount: blogDBs.length,

            itemBuilder: (_, index){
              final BlogDB blog = blogDBs[index];
              return ListTile(
                  leading: Icon(Icons.bookmark),
                  title:Text(blog.title, overflow: TextOverflow.ellipsis, maxLines: 1,),
                  subtitle: Text(blog.subtitle),
                  onTap: () {
                    _addToHistory(blog.blog_id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BlogDetailPage(
                        blogDB: blog,
                      )),
                    );
                  },

                  trailing: Column(
                      children: <Widget>[
                        _overflowButton(context, blog.blog_id),
                      ]
                  )
              );
            },
            separatorBuilder:(_,index){
              return Divider();
            },
            padding: const EdgeInsets.symmetric(
              horizontal:7.0,
            ),
          );
        }
      }
    );
  }

  Future<List<Widget>> createBlogsWidget(context, String query) async {

    List<BlogDB> result = await loadBlogs(query);
    await Future.delayed(Duration(milliseconds: 50));
    List<Widget> listTiles = [];
    ListTile temp;
    int i;
    for(i = 0; i < result.length; ++i){
      final BlogDB currentBlog = result[i];
      temp = new ListTile(
        key: Key(currentBlog.blog_id),
        leading: Icon(Icons.bookmark),
        title:Text(currentBlog.title, overflow: TextOverflow.ellipsis, maxLines: 1,),
        subtitle: Text(currentBlog.subtitle),
        onTap: () {
          _addToHistory(currentBlog.blog_id);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BlogDetailPage(
              blogDB: currentBlog,
            )),
          );
        },
        trailing: Column(
          children: <Widget>[
            _overflowButton(context, currentBlog.blog_id),
          ]
        )
      );
      listTiles.add(temp);
      listTiles.add(Divider());
    }

    return listTiles;
  }

  _addToHistory(String blogId) async{
    final prefs = await SharedPreferences.getInstance();
    final key = 'history';
    List<String> value = prefs.getStringList(key) ?? [];
    if(value.isEmpty){
      value.add(blogId);
    }
    else if(value.contains(blogId))
    {
      if(value[0] != blogId){
        value.remove(blogId);
        value.insert(0, blogId);
      }
    }
    else{
      value.add(blogId);
    }
    prefs.setStringList(key, value);
    return;
  }
  Widget _overflowButton(context, title) =>
    PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (_) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: '1',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Text('Add to My List'),
            onTap: (){_addToList(context, title);}
            
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
  _addToList(context, title) async {
    Navigator.of(context).pop();
    final prefs = await SharedPreferences.getInstance();
    final key = 'myList';
    List<String> value = prefs.getStringList(key) ?? [];
    if(value.isEmpty){
      _showDialog(context, 'Added to Your List'); _closeDialog(context);
      value.add(title);
    }
    else if(value.contains(title))
    {
      _showDialog(context, 'Item Exists'); _closeDialog(context);
    }
    else{
      _showDialog(context, 'Added to Your List'); _closeDialog(context);
      value.add(title);
    }
    prefs.setStringList(key, value);
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
