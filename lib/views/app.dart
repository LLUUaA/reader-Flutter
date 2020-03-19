import 'package:flutter/material.dart';

import './home/home.dart' show Home;
import './reader/reader.dart' show Reader;
import './bookDetails/bookDetails.dart' show BookDetails;
import './chapterDetails/chapterDetails.dart' show ChapterDetails;

class MyApp extends StatefulWidget {
  _MyApp createState() => new _MyApp();
}

class _MyApp extends State<MyApp> {
  Map getArgs(BuildContext context) {
    return ModalRoute.of(context).settings.arguments ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '青莲一页',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => Home(),
        '/reader': (BuildContext context) => Reader(arguments: this.getArgs(context)),
        '/bookDetails': (BuildContext context) => BookDetails(arguments: this.getArgs(context)),
        '/chapterDetails': (BuildContext context) =>  ChapterDetails(arguments: this.getArgs(context)),
      },
      initialRoute: '/',
      // onGenerateRoute: (setting) {},
      // onUnknownRoute: (setting) {},
    );
  }
}
