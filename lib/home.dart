import 'package:flutter/material.dart';

import 'package:tedxhkpolyu/newesttab.dart';
import 'package:tedxhkpolyu/trendingtab.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBarView(
        children: <Widget>[
          TrendingTab(), NewestTab()
        ],
      ),
    );
  }
}