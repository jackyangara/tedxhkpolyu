import 'package:flutter/material.dart';
import 'package:tedxhkpolyu/home.dart';
import 'package:tedxhkpolyu/myted.dart';
import 'package:tedxhkpolyu/profilebar.dart';
import 'package:tedxhkpolyu/search.dart';
import 'package:tedxhkpolyu/searchbar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white ,
      ),
      debugShowCheckedModeBanner: false,
      title: "TEDxHKPolyU",
      home: RootPage()
    );
  }
}

class RootPage extends StatefulWidget {
  @override
  RootPageState createState() {
    return new RootPageState();
  }
}

class RootPageState extends State<RootPage> {
  final TextEditingController _textController =TextEditingController();
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
          child: Scaffold(
        appBar: AppBar(
          title: Image.asset("img/logo.png",height: 25.0,),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.more_vert
              ),
              onPressed: null,
            )
          ],
          bottom: _selectBottom(_currentIndex)
        ),
        body: _selectWidget(_currentIndex),
        bottomNavigationBar: Theme(
             
          data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Colors.white,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          primaryColor: Colors.black,
          textTheme: Theme
              .of(context)
              .textTheme
              .copyWith(caption: new TextStyle(color: Colors.grey))),
            child: BottomNavigationBar(
            
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home),title:Text("Home"), ),
              BottomNavigationBarItem(icon: Icon(Icons.search),title:Text("Discover"),),
              BottomNavigationBarItem(icon: Icon(Icons.person),title:Text("My TED"),),
            ],
            currentIndex: _currentIndex,
            onTap: onTapped,
          ),
        ),
      ),
    );
  }

  void onTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _selectWidget(int index){
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return SearchPage();
      case 2:
        return MyTedPage();
      default:
    }
  }

  PreferredSizeWidget _selectBottom(int index) {
    switch (index) {
      case 0:
        return TabBar(
          tabs: <Widget>[
            Tab(text: "Trending",),
            Tab(text: "Newest",),
          ],
        );
      case 1:
        return _searchBar();
      case 2:
        return null;
      default:
    }
  }

  PreferredSize _searchBar(){
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
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

