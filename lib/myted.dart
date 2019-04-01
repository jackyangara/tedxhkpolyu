import 'package:flutter/material.dart';



class MyTedPage extends StatefulWidget {
  @override
  MyTedPageState createState() {
    return new MyTedPageState();
  }
}

class MyTedPageState extends State<MyTedPage> {
  bool _boolLoading = true;
  int _likes = 0;
  int _history = 0;
  int _myList = 0;
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
          _createTile(Icon(Icons.view_list), "My List", _myList),
          _createTile(Icon(Icons.favorite), "Likes", _likes),
          _createTile(Icon(Icons.access_time), "History", _history)
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
    setState(() {
      _likes = 3;
      _history = 1;
      _myList = 20;
      _boolLoading = false;
    });
  }
}