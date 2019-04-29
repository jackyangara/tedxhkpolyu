import 'package:flutter/material.dart';
import 'package:tedxhkpolyu/blog.dart';
import 'package:tedxhkpolyu/video.dart';

class SearchPage extends StatefulWidget {
  final String query;
  SearchPage(this.query);
  int _i = 1;
  int get i => _i;
  @override
  _SearchPageState createState(){
    return new _SearchPageState();
  } 
}

class _SearchPageState extends State<SearchPage> {
  
  @override
  Widget build(BuildContext context) {
    //TODO: Finish the searching of result for video and blog
    return _searchResult(widget.query);
  }
  
  Future<List<Widget>> _loadResult(String query) async {
    BlogPageState blogPageState = new BlogPageState();
    Video video = new Video();
    List<Widget> blogTiles = await blogPageState.createBlogsWidget(context, query);
    List<Widget> videoTiles = await video.createVideoWidget(context, query);
    List<Widget> allTiles = new List.from(blogTiles)..addAll(videoTiles);
    return allTiles;
  }
  
  FutureBuilder _searchResult(String query){
    List<Widget> result;
    ConnectionState connectionState;
    return FutureBuilder(
      future: _loadResult(query),
      builder: (_,snapshot){
        connectionState = snapshot.connectionState;
        if (connectionState.index == 1) {
          return Center(child: CircularProgressIndicator());
        }
        else if(connectionState.index == 3)
        {
          //Process to get videos and blogs
          result = snapshot.data;
          return Container(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal:7.0,
              ),
              children: result,
            ),
          );
        }
      }
    );
  }
}