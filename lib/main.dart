import 'package:flutter/material.dart';
import 'package:tedxhkpolyu/myted.dart';
import 'package:tedxhkpolyu/search.dart';
import 'package:tedxhkpolyu/settings.dart';
import 'package:tedxhkpolyu/ui/home/home.dart';
import 'package:tedxhkpolyu/blog.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => _buildThemeData(brightness),
      themedWidgetBuilder: (_, theme){
        return MaterialApp(
        theme: theme,
        debugShowCheckedModeBanner: false,
        title: "TEDxHKPolyU",
        home: RootPage()
      );}
    );
  }

  ThemeData _buildThemeData(Brightness brightness){
    return brightness == Brightness.dark

        ? ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        backgroundColor: Colors.black)


        : ThemeData.light().copyWith(
        primaryColor: Colors.white,
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
        backgroundColor: Colors.white);
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
  bool _nightMode;

  @override
  void initState() {
    super.initState();
    _nightMode = DynamicTheme.of(context).brightness == Brightness.dark;
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
          child: Scaffold(
        appBar: AppBar(
          title: Image.asset("img/logo.png",height: 25.0,),
          actions: _actions(),
          bottom: _selectBottom(_currentIndex),
        ),
        body: _selectWidget(_currentIndex),
        bottomNavigationBar: _bottomNavBar()
      ),
    );
  }

  PreferredSizeWidget _selectBottom(int index) {
    switch (index) {
      case 0:
        return null;
      case 1:
        return null;
      case 2:
        return _searchBar();
      case 2:
        return null;
      default:
        return null;
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

  Color determineColor(){
    return DynamicTheme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor ;
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
        return BlogPage();
      case 2:
        return SearchPage();
      case 3:
        return MyTedPage();
      default:
        return HomePage();
    }
  }

  

  

  _bottomNavBar() {

    var brightness = DynamicTheme.of(context).brightness;
    var themeData = brightness == Brightness.dark ? ThemeData.dark() : ThemeData.light().copyWith(
        canvasColor: Colors.white,
        // sets the active color of the `BottomNavigationBar` if `Brightness` is light
        primaryColor: Colors.black,
        textTheme: Theme
            .of(context)
            .textTheme
            .copyWith(caption: new TextStyle(color: Colors.grey))
    );

    return Theme(
      data: themeData,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),title:Text("Home"), ),
          BottomNavigationBarItem(icon: Icon(Icons.book),title:Text("Blog"), ),
          BottomNavigationBarItem(icon: Icon(Icons.search),title:Text("Discover"),),
          BottomNavigationBarItem(icon: Icon(Icons.person),title:Text("My TED"),),
        ],
        currentIndex: _currentIndex,
        onTap: onTapped,
      ),
    );
  }

  List<Widget> _actions() {
    var brightness = DynamicTheme.of(context).brightness;

    var popupMenu = PopupMenuButton<Options>(
      icon: Icon(
        Icons.more_vert,
        color: brightness == Brightness.dark ? Colors.white : Colors.black,
      ),
      onSelected: null,
      itemBuilder: (_) => <PopupMenuEntry<Options>>[
        PopupMenuItem<Options>(
          value: Options.NIGHT_MODE,
          child: GestureDetector(
            child: Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage(
                )),
              );
            },
          )
        ),
        const PopupMenuItem<Options>(
          value: Options.ABOUT_US,
          child: Text("About Us"),
        )
      ],
    );

    return <Widget>[
      popupMenu,
    ];
  }


  void changeBrightness(bool nightMode){
      DynamicTheme.of(context).setBrightness(nightMode ? Brightness.dark : Brightness.light);
      setState(() {
        _nightMode = nightMode;
      });
  }


}

enum Options {
  NIGHT_MODE,
  ABOUT_US
}


