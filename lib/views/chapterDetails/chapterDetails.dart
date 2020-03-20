import 'package:flutter/material.dart';

import '../../widget/chapterList.dart' show ChapterList;
import '../../service/book.dart' show getChapterList;
import '../../widget/common.dart' show ModalSheet;
import '../../widget/toast.dart';

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
  List chapterPager;
  List chapterList;
  bool loading;
  int currentPage;
  int totalPage;

  _ChapterDetails(this.id) {
    this.getChapterListSv(this.id);
    this.loading = true;
  }

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
                child: Text(
                  '章节目录',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ),
              PagerHandle(this.currentPage, this.totalPage, this.handlePager),
              Container(
                child: ChapterList(
                  this.id,
                  this.chapterList,
                  isLoading: this.loading,
                ),
              ),
              PagerHandle(this.currentPage, this.totalPage, this.handlePager),
            ],
          ),
        ),
      ),
    );
  }

  // handle page button
  void handlePager(String type) {
    if (this.loading == true) {
      return;
    }
    switch (type) {
      case "prev":
        if (this.currentPage > 1) {
          setState(() {
            this.loading = true;
          });
          this.getChapterListSv(this.id, index: this.currentPage - 1);
        } else {
            Toast.toast(context, msg: '这已经是第一页了');
        }
        break;
      case "page":
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ModalSheet(this.chapterPager, onPressed: (int index) {
                setState(() {
                  this.loading = true;
                });
                Navigator.of(context).pop(); // close modal
                this.getChapterListSv(this.id, index: index + 1);
              });
            });
        break;
      case "next":
        if (this.currentPage < this.totalPage) {
          setState(() {
            this.loading = true;
          });
          this.getChapterListSv(this.id, index: this.currentPage + 1);
        } else {
          Toast.toast(context, msg: '这已经是最后一页了');
        }
        break;
      default:
    }
  }

  // get chapter
  void getChapterListSv(int id, {int index}) async {
    try {
      var res = await getChapterList(id, pageIndex: index);
      this.loading = false;
      setState(() {
        this.chapterList = res["chapterList"];
        this.chapterPager = res["chapterPager"];
        this.totalPage = this.chapterPager.length;
        this.currentPage = index ?? 1;
      });
    } catch (e) {
      setState(() {
        this.loading = false;
      });
    }
  }
}

class PagerHandle extends StatelessWidget {
  final int currentPage;
  final int totalPage;
  final Function cb;
  PagerHandle(this.currentPage, this.totalPage, this.cb);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BaseButtom("上一页", () => this.cb('prev')),
          BaseButtom("${currentPage ?? '-'}/${totalPage ?? '--'}",
              () => this.cb('page')),
          BaseButtom("下一页", () => this.cb('next')),
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
      onPressed: this.onPressed,
      highlightedBorderColor: Colors.black54,
      borderSide: BorderSide(
        color: Colors.black54,
      ),
      child: Text(this.text),
    );
  }
}
