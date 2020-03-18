import 'package:flutter/material.dart';
import 'package:wanandroid/pages/user_login_page.dart';

import 'application.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'wan android',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: Application(),
    );
  }
}

