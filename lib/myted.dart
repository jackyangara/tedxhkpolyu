
import 'dart:async';

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
    Future<List<String>> hist = _getMyList();
    hist.then((val) {
      print(val);
    });
    return Container(child: Text(hist.toString()),);
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
    Future<List<String>> hist = _getHistory();
    hist.then((val) {
      print(val);
    });
    return Container(child: Text('a'),);
  }

  Future<List<String>> _getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'history';
    List<String> value = prefs.getStringList(key) ?? [];
    return value;
  }

  
}