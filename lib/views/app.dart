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
        '/load': (BuildContext context) => LoadPage(),
        '/reader': (BuildContext context) =>
            Reader(arguments: this.getArgs(context)),
        '/bookDetails': (BuildContext context) =>
            BookDetails(arguments: this.getArgs(context)),
        '/chapterDetails': (BuildContext context) =>
            ChapterDetails(arguments: this.getArgs(context)),
      },
      initialRoute: '/load',
      // onGenerateRoute: (setting) {},
      // onUnknownRoute: (setting) {},
    );
  }
}

class LoadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // height: ,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Center(
              child: Text(
                '青莲一页',
                style: TextStyle(
                  color: Colors.blueAccent,
                  decoration: TextDecoration.none
                ),
              ),
            ),
            Container(
              child: Text(
                'Copyright © 2020-present WuQingSong',
                style: TextStyle(color: Colors.grey[600], 
                fontSize: 13.0,
                 decoration: TextDecoration.none),
              ),
            )
          ],
        ),
      ),
    );
  }
}
