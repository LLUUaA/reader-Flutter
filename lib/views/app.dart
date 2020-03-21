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
    Size contentSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        // height: ,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              child: Center(
                child: Image.asset('lib/assets/image/book_lover.png'),
              ),
            ),
            Positioned(
              bottom: 60.0,
              right: 5.0,
              child: CountDown(),
            ),
            Positioned(
              bottom: 40.0,
              width: contentSize.width,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  '青莲一页',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none),
                ),
              ),
            ),
            Positioned(
              width: contentSize.width,
              bottom: 10.0,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Copyright © 2019-present WuQingSong',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13.0,
                      decoration: TextDecoration.none),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// count down
class CountDown extends StatefulWidget {
  final int secends;
  CountDown({this.secends = 3});
  @override
  _CountDown createState() => _CountDown(this.secends);
}

class _CountDown extends State<CountDown> {
  final int secends;
  _CountDown(this.secends) {
    this._init();
  }
  // init
  void _init() async {
    await Future.delayed(Duration(seconds: this.secends));
    this.jumpTo();
  }

  // to home
  void jumpTo() {
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.all(0),
      onPressed: this.jumpTo,
      child: Text(
        '跳过',
        style: TextStyle(letterSpacing: 2.0),
      ),
    );
  }
}
