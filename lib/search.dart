import 'package:flutter/material.dart';
import 'package:tedxhkpolyu/blog.dart';
import 'package:tedxhkpolyu/video.dart';

class SearchPage extends StatefulWidget {
  final String query;
  const SearchPage(this.query);

  @override
  _SearchPageState createState(){
    return new _SearchPageState(query);
  } 
}

class _SearchPageState extends State<SearchPage> {
  final String query;

  _SearchPageState(this.query);
  
  @override
  Widget build(BuildContext context) {
    //TODO: Finish the searching of result for video and blog
    return _searchResult(this.query);
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
    return FutureBuilder(
      future: _loadResult(query),
      builder: (_,snapshot){
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          //Process to get videos and blogs
          List<Widget> result = snapshot.data;
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