import 'dart:math' show pi;
import 'package:flutter/material.dart';

import 'package:myapp/widget/common.dart';
import '../../service/account.dart' show login;
import '../../widget/image.dart';
import '../../service/book.dart' show getBookShelf;
import '../../common/myListen.dart';

class BookShelf extends StatefulWidget {
  BookShelf(this.pageController);
  final PageController pageController;

  @override
  _BookShelf createState() => _BookShelf();
}

class _BookShelf extends State<BookShelf> with AutomaticKeepAliveClientMixin {
  _BookShelf();

  @override
  bool get wantKeepAlive => true;

  List bookShelfList;

  @override
  void initState() {
    super.initState();
    this._init();

    print('MyEvent.addBookShelf => ${MyEvent.addBookShelf}');
    MyListener.on(MyEvent.addBookShelf, (args) {
      print('MyEvent.addBookShelf => $args');
      this.getBookShelfSv();
    });

    // TEST
    ListenerBack _listenerBack = MyListener.on("test", (args) {
      print('test =>1 $args');
    });
    MyListener.on("test", (args) {
      print('test =>2 $args');
    });
    MyListener.emit("test", 'this is first');
    _listenerBack.remove();
    MyListener.emit("test", 'this is secend');
    _listenerBack.clear();
    MyListener.emit("test", 'this is third');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    double boxW = (MediaQuery.of(context).size.width - 10) / 3; // @ p1
    double boxH = MediaQuery.of(context).size.width / 2;

    List<Widget> bookWidgets = [];
    if (bookShelfList != null) {
      this.bookShelfList.forEach((book) {
        bookWidgets.add(BookShelfView(
          width: boxW,
          height: boxH,
          content: book["bookName"],
          bookId: book["bookId"],
          chapterNum: book["chapterNum"] ?? 1,
          coverImg: book["coverImg"],
        ));
      });
      bookWidgets.add(AddWrap(boxW, boxH, () {
        widget.pageController.jumpToPage(1);
      }));
    } else {
      bookWidgets = [Loading()];
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(5.0), // p1
          child: Column(
            children: <Widget>[
              SearchWidget(),
              Container(
                height: MediaQuery.of(context).size.height - 140.0,
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  child: Wrap(children: bookWidgets),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _init() async {
    this.getBookShelfSv();
  }

  Future<void> getBookShelfSv() async {
    var list = await getBookShelf();
    setState(() {
      this.bookShelfList = list;
    });
  }
}

class AddWrap extends StatelessWidget {
  @override
  AddWrap(this.width, this.height, this.tapAddBtn);

  final double width;
  final double height;
  final Function tapAddBtn;

  Widget build(BuildContext context) {
    return Container(
      width: this.width - 10, // view:padding:5.0
      height: this.height - 45, // img height @imageHeigt
      margin: EdgeInsetsDirectional.only(start: 5.0, top: 5.0),

      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey[400]),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: MaterialButton(
        onPressed: this.tapAddBtn,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Divider(
              indent: 20.0,
              endIndent: 20.0,
              thickness: 2.0,
            ),
            Transform.rotate(
              angle: pi / 2,
              child: Divider(
                indent: 20.0,
                endIndent: 20.0,
                thickness: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookShelfView extends StatelessWidget {
  BookShelfView({
    this.color,
    @required this.content,
    @required this.width,
    @required this.height,
    @required this.bookId,
    @required this.chapterNum,
    @required this.coverImg,
  });

  final Color color;
  final String content;
  final double width;
  final double height;
  final int bookId;
  final num chapterNum;
  final String coverImg;

  //

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/reader',
              arguments: {"id": this.bookId, chapterNum: this.chapterNum});
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              top: 0,
              child: ImageLoad(
                this.coverImg,
                width: this.width - 10,
                height: this.height - 45, // p-> imageHeigt
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: this.width - 20,
                height: 45.0,
                alignment: Alignment.center,
                child: Text(
                  this.content ?? "-",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.0,
      height: 40.0,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: Color.fromRGBO(204, 204, 204, 1.0),
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: FlatButton(
        child: Text('搜索你想要的'),
        textColor: Color.fromRGBO(51, 51, 51, 1.0),
        onPressed: () {
          Navigator.pushNamed(context, '/search');
        },
      ),
    );
  }
}
