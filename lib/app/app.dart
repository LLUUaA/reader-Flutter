import 'package:flutter/material.dart';

import './home.dart';
import 'about.dart';

class MyApp extends StatefulWidget {
  _MyApp createState() => new _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '青莲一页',
      routes:<String, WidgetBuilder> {
      '/': (BuildContext context) => Home(),
      'about': (BuildContext context) => About(),
    },
      initialRoute: '/',
      // onGenerateRoute: (setting) {},
      // onUnknownRoute: (setting) {},
    );
  }
}
