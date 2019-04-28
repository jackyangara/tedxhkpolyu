import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:tedxhkpolyu/model/blog_db.dart';

class SettingsPage extends StatefulWidget {
  //TODO: Fix the font and positions
  final BlogDB blogDB;
  SettingsPage({this.blogDB});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextStyle titleStyle = TextStyle(fontSize: 30.0, fontFamily: 'CharterITC', fontWeight: FontWeight.w500);

  final TextStyle contentStyle = TextStyle(fontSize: 16.0, fontFamily: 'Kievit', height: 1.5);

  bool _nightMode;

  @override
  void initState() {
    super.initState();
    _nightMode = DynamicTheme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    Color iconColor = DynamicTheme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        iconTheme: IconThemeData(color: iconColor),
      ),
      body: _buildBody()
    );
  }

  Widget _buildBody(){
    return ListView(
      padding: EdgeInsets.all(12.0),
      children: <Widget>[
        Row(
            children: <Widget>[
              Text('Night Mode'),
              Flexible(
                child: Switch(
                  onChanged: (nightMode) => changeBrightness(nightMode),
                  value: _nightMode,
                ),
              )
            ],
          ),
      ],
    );
  }

  void changeBrightness(bool nightMode){
      DynamicTheme.of(context).setBrightness(nightMode ? Brightness.dark : Brightness.light);
      setState(() {
        _nightMode = nightMode;
      });
  }
}
