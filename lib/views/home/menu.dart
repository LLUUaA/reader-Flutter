import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('context size:${MediaQuery.of(context).size}');
    return Scaffold(
      body: Wrap(
        children: <Widget>[
          ViewDemo(
            color: Colors.red[100],
            content: 'Content',
          ),
          ViewDemo(
            color: Colors.red[200],
            content: 'Content',
          ),
          ViewDemo(
            color: Colors.red[300],
            content: 'Content',
          ),
          ViewDemo(
            color: Colors.red[400],
            content: 'Content',
          ),
        ],
      ),
    );
  }
}

class ViewDemo extends StatelessWidget {
  ViewDemo({@required this.color, @required this.content});

  final Color color;
  final String content;

  @override
  Widget build(BuildContext context) {
    print('width${MediaQuery.of(context).size.width}');
    return Container(
      width: MediaQuery.of(context).size.width/3,
      height: MediaQuery.of(context).size.width/2,
      alignment: Alignment.center,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
      color: color,
      child: Text(MediaQuery.of(context).size.width.toString()),
    );
  }
}

