import 'package:flutter/material.dart';

import 'package:tedxhkpolyu/ui/home/newesttab.dart';
import 'package:tedxhkpolyu/ui/home/trendingtab.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TrendingTab()
      );
  }
}