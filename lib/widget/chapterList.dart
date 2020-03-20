import 'package:flutter/material.dart';

import './common.dart';

class ChapterList extends StatelessWidget {
  final List chapterList;
  final int id;
  final bool isLoading;
  final bool isEmpty;
  ChapterList(this.id, this.chapterList, {this.isLoading, this.isEmpty});

  @override
  Widget build(BuildContext context) {
    if(this.isLoading == true) {
      return Loading();
    }

    if (this.isEmpty == true) {
      return Empty();
    }
    if(this.chapterList == null) {
      return Empty(content: '',);
    }
    return Container(
      child: Column(
        children: this.chapterList.map((f) {
          return ChapterItem(f["chapterName"], this.id,
              chapterNum: f["chapterNum"]);
        }).toList(),
      ),
    );
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
              child: Text(
                this.chapterName,
                style: TextStyle(fontSize: 15.0),
              ),
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
