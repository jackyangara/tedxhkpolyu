
import 'dart:async';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tedxhkpolyu/blog.dart';
import 'package:tedxhkpolyu/video.dart';



class MyTedPage extends StatefulWidget {
  @override
  MyTedPageState createState() {
    return new MyTedPageState();
  }
}

class MyTedPageState extends State<MyTedPage> {
  bool _boolLoading = true;
  List<String> _history = [];
  List<String> _myList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadAPI();
    
  }


  @override
  Widget build(BuildContext context) {  
    return Container(
      alignment: Alignment.center,
          child: _boolLoading?CircularProgressIndicator():ListView(
        children: <Widget>[
          ListTile(
            title: Text("My List"),
            subtitle: Text(_myList.length.toString()),
            leading: Icon(Icons.view_list),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyListPage(
                )),
              );
            },
          ),
          Divider()
          ,
          ListTile(
            title: Text("History"),
            subtitle: Text(_history.length.toString()),
            leading: Icon(Icons.access_time),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage(
                )),
              );
            },
          ),
        ],
      ),
    );
  }


  void _loadAPI() async {
    await Future.delayed(Duration(milliseconds: 500));
    // call API/database disini
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList('history') ?? [];
      _myList = prefs.getStringList('myList') ?? [];
      _boolLoading = false;
    });
  }
}

class MyListPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Color iconColor = DynamicTheme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: Text('My List', style: TextStyle(color: iconColor),),
        iconTheme: IconThemeData(color: iconColor),
      ),
      body:FutureBuilder(
      future: _getMyList(context),
      builder: (_, snapshot){
        if (!snapshot.hasData) return Center(child:CircularProgressIndicator());
        else {
            
            List<Widget> _currentList = [];
            List<Widget> listTiles = [];
            _currentList = []..addAll(snapshot.data);
            for(int i = 0; i < _currentList.length; i++){
              listTiles.add(_currentList[i]);
            }
            return Container(
              alignment: Alignment.center,
              child:ListView(
                padding: const EdgeInsets.symmetric(horizontal:7.0,),
                children: listTiles
              )
            );

        }
      }));
  }
  Future<List<Widget>> _getMyList(context) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'myList';
    List<Widget> listTiles = [];
    List<String> value = prefs.getStringList(key) ?? [];
    for(int i = 0; i < value.length; i++){
      List<Widget> x = await _loadResult(context, value[i]);
      listTiles.add(x[0]);
      listTiles.add(Divider());
    }
    return listTiles;
  }

  Future<List<Widget>> _loadResult(context, String query) async {
    BlogPageState blogPageState = new BlogPageState();
    Video video = new Video();
    List<Widget> blogTiles = await blogPageState.createBlogsWidget(context, query);
    List<Widget> videoTiles = await video.createVideoWidget(context, query);
    List<Widget> allTiles = new List.from(blogTiles)..addAll(videoTiles);
    return allTiles;
  }
}

class HistoryPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Color iconColor = DynamicTheme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: Text('History', style: TextStyle(color: iconColor),),
        iconTheme: IconThemeData(color: iconColor),
      ),
      body:FutureBuilder(
      future: _getHistory(context),
      builder: (_, snapshot){
        if (!snapshot.hasData) return Center(child:CircularProgressIndicator());
        else {
            
            List<Widget> _currentList = [];
            List<Widget> listTiles = [];
            ListTile temp;
            _currentList = []..addAll(snapshot.data);
            for(int i = 0; i < _currentList.length; i++){
              listTiles.add(_currentList[i]);
            }
            return Container(
              alignment: Alignment.center,
              child:ListView(
                padding: const EdgeInsets.symmetric(horizontal:7.0,),
                children: listTiles
              )
            );

        }
      }));
  }

  Future<List<Widget>> _getHistory(context) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'history';
    List<Widget> listTiles = [];
    List<String> value = prefs.getStringList(key) ?? [];
    for(int i = 0; i < value.length; i++){
      List<Widget> x = await _loadResult(context, value[i]);
      listTiles.add(x[0]);
      listTiles.add(Divider());
    }
    return listTiles;
  }

  Future<List<Widget>> _loadResult(context, String query) async {
    BlogPageState blogPageState = new BlogPageState();
    Video video = new Video();
    List<Widget> blogTiles = await blogPageState.createBlogsWidget(context, query);
    List<Widget> videoTiles = await video.createVideoWidget(context, query);
    List<Widget> allTiles = new List.from(blogTiles)..addAll(videoTiles);
    return allTiles;
  }
}