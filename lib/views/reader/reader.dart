import 'package:flutter/material.dart';

import 'package:myapp/service/book.dart' show readBook;
import '../../widget/loading.dart';

class Reader extends StatefulWidget {
  int id;
  int chapterNum;
  final Map arguments;
  Reader({this.id, this.chapterNum = 1, this.arguments}) {
    this.id = this.arguments["id"] ?? this.id;
    this.chapterNum = this.arguments["chapterNum"] ?? this.chapterNum;
  }
  _Reader createState() => _Reader(this.id, this.chapterNum);
}

class _Reader extends State<Reader> {
  List chapterContent = [];
  String chapterName;
  final int id;
  final int chapterNum;

  bool loading;
  _Reader(this.id, this.chapterNum) {
    this.getBookDetails();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: this.chapterContent.map((book) {
              return Text(
                '$book',
                style: TextStyle(
                  fontSize: 20,
                  textBaseline: TextBaseline.alphabetic,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void getBookDetails() async {
    if (this.id != null) {
      var res = await readBook(this.id, this.chapterNum);
      setState(() {
        this.chapterContent = res["chapterContent"];
        this.chapterName = res["chapterName"];
      });
    }
  }
}
