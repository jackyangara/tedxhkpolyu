import 'package:flutter/material.dart';
import 'package:tedxhkpolyu/blog.dart';
import 'package:tedxhkpolyu/video.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState(){
    return new _SearchPageState();
  } 
}

class _SearchPageState extends State<SearchPage> {
  BlogPageState blogPageState = new BlogPageState();
  Video video = new Video();
  final TextEditingController _textController = TextEditingController();
  //TODO: Make the search work. Cannot update tree.
  @override
  void initState() {
    super.initState();
    FutureBuilder searchResult;
    _textController.addListener((){
      setState(() {
        searchResult = _searchResult(_textController.text);
        return searchResult;
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _textController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    //TODO: Finish the searching of result for video and blog
    return _searchResult("");
  }
  
  Future<List<Widget>> _loadResult(String query) async {
    List<Widget> blogTiles = await blogPageState.createBlogsWidget(query);
    List<Widget> videoTiles = await video.createVideoWidget(query);
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
          result.insert(0, _searchBar());
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
    );
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
              hintText: "Search",
            ),
          ),
        ),
      ),
    );
  }
}