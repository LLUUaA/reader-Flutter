import 'package:flutter/material.dart';
import 'package:myapp/widget/toast.dart';

import '../../widget/chapterList.dart' show ChapterList;
import '../../service/book.dart'
    show getBook, getChapterList, addBookShelf, removeBookShelf;
import '../../common/myListen.dart';
// import '';

class BookDetails extends StatefulWidget {
  int id;
  final Map arguments;
  BookDetails({this.id, this.arguments}) {
    this.id = this.arguments["id"] ?? this.id;
  }
  _BookDetails createState() => _BookDetails(this.id);
}

class _BookDetails extends State<BookDetails> {
  String name; // app bar name
  String bookName;
  String authorName;
  String catelog;
  String status;
  bool isAddBookShelf;
  String coverImg;
  List chapterList;
  final int id;
  _BookDetails(this.id) {
    this.getBookInfosById(this.id);
    this.getChapterListSv(this.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.name ?? '详情'),
      ),
      body: SafeArea(
        child: Container(
          color: Color.fromRGBO(225, 225, 225, 1),
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: ListView(
            children: <Widget>[
              Container(
                // book infos
                child: Wrap(
                  children: <Widget>[
                    Container(
                      width: 110.0,
                      height: 130.0,
                      child: Image.network(
                        this.coverImg ?? "",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 170.0,
                      margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0),
                      child: Column(
                        children: <Widget>[
                          Infos("书名\t\t${this.bookName ?? '-'}"),
                          Divider(
                            height: 10.0,
                            color: Colors.transparent,
                          ),
                          Infos("作者：${this.authorName ?? '-'}"),
                          Infos(this.catelog ?? '作品类别：'),
                          Infos("进度：${this.status ?? '-'}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                children: <Widget>[
                  HandleButton(
                    '开始阅读',
                    onPressed: () {
                      Navigator.pushNamed(context, '/reader', arguments: {
                        "id": widget.id,
                      });
                    },
                  ),
                  HandleButton(
                    '章节目录',
                    onPressed: () {
                      Navigator.pushNamed(context, '/chapterDetails',
                          arguments: {
                            "id": widget.id,
                          });
                    },
                  ),
                  HandleButton(
                    isAddBookShelf == null
                        ? '-'
                        : isAddBookShelf == true ? '移出书架' : "加入书架",
                    onPressed: this.handleBookShelfState,
                  ),
                  HandleButton(
                    'TXT下载',
                    color: Colors.redAccent,
                    onPressed: () => Toast.toast(context, msg: '暂不支持'),
                  ),
                ],
              ),
              Container(
                // title
                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                child: Text(
                  '章节目录',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),
                ),
              ),
              ChapterList(widget.id, this.chapterList),
              MaterialButton(
                padding: EdgeInsets.all(8.0),
                onPressed: () {
                  Navigator.pushNamed(context, '/chapterDetails',
                      arguments: {"id": widget.id});
                },
                child: Text(
                  '点击查看更多章节',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleBookShelfState() async {
    assert(this.isAddBookShelf != null);

    if (this.isAddBookShelf == null) {
      return null;
    }
    // change add Bookshelf state
    setState(() {
      this.isAddBookShelf = this.isAddBookShelf == true ? false : true;
    });
    // 上面先更新了isAddBookShelf 判断时注意
    if (this.isAddBookShelf) {
      await addBookShelf(widget.id, {
        "bookId": widget.id,
        "bookName": this.bookName,
        "coverImg": this.coverImg,
        "bookAuthor": this.authorName,
        "status": this.status,
      });
    } else {
      await removeBookShelf(widget.id);
    }
    MyListener.emit(MyEvent.addBookShelf, this.isAddBookShelf);
  }

  // get bookInfo
  Future getBookInfosById(int id) async {
    if (id == null) {
      return;
    }
    var resp = await getBook(id);
    var bookInfos = resp["bookInfo"];
    setState(() {
      try {
        this.bookName = bookInfos["bookName"];
        this.authorName = bookInfos["bookAuthor"];
        this.coverImg = bookInfos["coverImg"];
        this.isAddBookShelf = resp["isAddBookShelf"];
        this.status = bookInfos["status"];
        this.catelog = bookInfos["chapter"][0];
      } catch (e) {}
    });
  }

  // get chapter
  void getChapterListSv(int id, {int index}) async {
    var res = await getChapterList(id, pageIndex: index);
    setState(() {
      this.chapterList = res["chapterList"];
    });
  }
}

// Chapter items
class ChapterItems extends StatelessWidget {
  final String chapterName;
  final String updateChapter;
  ChapterItems(this.chapterName, {this.updateChapter});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey[300])),
      ),
      child: MaterialButton(
        onPressed: () {},
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(this.chapterName),
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

// handle button
class HandleButton extends StatelessWidget {
  final String text;
  final Color color;
  final bool disabled;
  final Function onPressed;
  HandleButton(this.text, {this.onPressed, this.color, this.disabled});

  void noop() => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 10.0,
      height: 50.0,
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
      child: FlatButton(
        onPressed: this.onPressed ?? this.noop,
        color: this.color ?? Colors.lightBlue[300],
        child: Text(
          this.text,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class Infos extends StatelessWidget {
  final String text;
  Infos(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      child: Text(
        this.text ?? "-",
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }
}
