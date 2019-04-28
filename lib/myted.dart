
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
          _createTile(Icon(Icons.view_list), "My List", _myList.length),
          _createTile(Icon(Icons.access_time), "History", _history.length)
        ],
      ),
    );
  }

  Widget _createTile(Icon icon, String title, int subtitle){
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle.toString()),
      leading: icon,
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