
import 'dart:async';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



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
        iconTheme: IconThemeData(color: iconColor),
      ),
      body:FutureBuilder(
      future: _getMyList(),
      builder: (_, snapshot){
        if (!snapshot.hasData) return Container();
        else {
            List<String> _currentList = [];
            List<Widget> listTiles = [];
            ListTile temp;
            _currentList = []..addAll(snapshot.data);
            for(int i = 0; i < _currentList.length; i++){
              temp = new ListTile(
                leading: Icon(Icons.bookmark),
                title:Text(_currentList[i], overflow: TextOverflow.ellipsis, maxLines: 1,),
              );
              listTiles.add(temp);
              listTiles.add(Divider());
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
  Future<List<String>> _getMyList() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'myList';
    List<String> value = prefs.getStringList(key) ?? [];
    return value;
  }
}

class HistoryPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Color iconColor = DynamicTheme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: iconColor),
      ),
      body:FutureBuilder(
      future: _getHistory(),
      builder: (_, snapshot){
        if (!snapshot.hasData) return Container();
        else {
            List<String> _currentList = [];
            List<Widget> listTiles = [];
            ListTile temp;
            _currentList = []..addAll(snapshot.data);
            for(int i = 0; i < _currentList.length; i++){
              temp = new ListTile(
                leading: Icon(Icons.bookmark),
                title:Text(_currentList[i], overflow: TextOverflow.ellipsis, maxLines: 1,),
              );
              listTiles.add(temp);
              listTiles.add(Divider());
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

  Future<List<String>> _getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'history';
    List<String> value = prefs.getStringList(key) ?? [];
    return value;
  }

  
}