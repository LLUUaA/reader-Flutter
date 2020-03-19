import 'package:flutter/material.dart';

import '../service/book.dart' show getChapterList;
import './loading.dart';

class ChapterList extends StatefulWidget {
  final int id;
  final int pageIndex;
  ChapterList(this.id, {this.pageIndex});

  _ChapterList createState() => _ChapterList(this.id, pageIndex: this.pageIndex);
}

class _ChapterList extends State<ChapterList> {
  List chapterList;
  final int id;
  final int pageIndex;
  bool loading = true;

  _ChapterList(this.id, {this.pageIndex}) {
    this.getChapterListById(this.id, index: this.pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: this.loading
          ? Loading()
          : Column(
              children: <Widget>[
                Column(
                  children: this.chapterList.map((f) {
                    return ChapterItem(f["chapterName"], widget.id,
                        chapterNum: f["chapterNum"]);
                  }).toList(),
                ),
              ],
            ),
    );
  }

  void getChapterListById(int id, {int index}) async {
    if (id != null) {
      var res = await getChapterList(id, pageIndex: index);
      setState(() {
        this.loading = false;
        this.chapterList = res["chapterList"].sublist(0, 30);
      });
    }
  }
}

// Chapter items
class ChapterItem extends StatelessWidget {
  final String chapterName;
  final int id;
  final int chapterNum;
  final String updateChapter;
  ChapterItem(this.chapterName, this.id, {this.updateChapter, this.chapterNum});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey[300])),
      ),
      child: MaterialButton(
        onPressed: () {
          Navigator.pushNamed(context, '/reader',
              arguments: {"id": this.id, "chapterNum": this.chapterNum ?? 1});
        },
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(this.chapterName,style: TextStyle(fontSize: 15.0),),
            ),
            Divider(height: 10.0, color: Colors.transparent),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                '更新：${this.updateChapter ?? '未知'}',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
