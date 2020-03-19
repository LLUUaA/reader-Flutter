import 'package:flutter/material.dart';

import '../../widget/chapterList.dart' show ChapterList;

class ChapterDetails extends StatefulWidget {
  int id;
  final arguments;
  ChapterDetails({this.id, this.arguments}) {
    this.id = this.arguments["id"] ?? this.id;
  }
  _ChapterDetails createState() => _ChapterDetails(this.id);
}

class _ChapterDetails extends State<ChapterDetails> {
  int id;
  _ChapterDetails(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('章节详情'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              Container(
                child: Text('章节目录',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
                ),),
              ),
              PagerHandle(),
              Container(
                child: ChapterList(this.id),
              ),
              PagerHandle(),
            ],
          ),
        ),
      ),
    );
  }
}

class PagerHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BaseButtom("上一页", () {}),
          BaseButtom("1/32", () {}),
          BaseButtom("下一页", () {}),
        ],
      ),
    );
  }
}

class BaseButtom extends StatelessWidget {
  final String text;
  final Function onPressed;

  BaseButtom(this.text, this.onPressed);
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      onPressed: () {},
      highlightedBorderColor: Colors.black54,
      borderSide: BorderSide(
        color: Colors.black54,
      ),
      child: Text(this.text),
    );
  }
}
