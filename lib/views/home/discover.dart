import 'package:flutter/material.dart';

import 'package:myapp/widget/bookList.dart' show BookList;
import 'package:myapp/service/book.dart' show getHotBook, getBookByType;
import '../../widget/loading.dart';

class Discover extends StatefulWidget {
  @override
  _Discover createState() => _Discover();
}

class _Discover extends State<Discover> with AutomaticKeepAliveClientMixin {
  List bookList;
  List maleMenu;
  List femaleMenu;
  bool loading = true; // 加载状态
  double opacity = 0;
  ScrollController _controller = new ScrollController();
  List mainMenu = [
    {"type": "hot", "subTxt": "热门"},
    {"type": "female", "subTxt": "女频"},
    {"type": "male", "subTxt": "男频"},
  ];
  String total;
  _Discover() {
    getBookList();
    _controller.addListener(() {
      double op = this._controller.offset / 450.0;
      if (op == 1 || op == 0) {
        return;
      }
      if (op > 1) {
        op = 1;
      }
      if (op < 0.1) {
        op = 0;
      }
      setState(() {
        this.opacity = op;
      });
    });
  }

  @override
  bool get wantKeepAlive => true;

  // handle refresh
  Future<void> handleRefresh() async {
    await this.getBookList();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('内容已更新'),
      action: SnackBarAction(
        label: '好的',
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }

  // get book by type
  void getBookByTypeSv(String type) async {
    if (type == null) {
      return;
    }
    setState(() {
      this.loading = true;
    });
    Map res = await getBookByType(type);
    setState(() {
      this.bookList = res["bookList"];
      this.total = res["total"];
      this.opacity = 0;
      this.loading = false;
    });
    this._controller.jumpTo(1);
  }

  // handle main menu
  void handleChooseMainMenu(String type) {
    if (type == null) {
      return;
    }
    setState(() {
      this.loading = true;
    });
    switch (type) {
      case "hot":
        this._controller.jumpTo(1);
        this.getBookList();
        break;
      case "male":
        this.getBookByTypeSv(this.maleMenu[1]["href"]);
        break;
      case "female":
        this.getBookByTypeSv(this.femaleMenu[1]["href"]);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: RefreshIndicator(
              onRefresh: this.handleRefresh,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(10.0),
                child: ListView(
                  controller: this._controller,
                  children: <Widget>[
                    Flex(
                      direction: Axis.horizontal,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '分类',
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.w500),
                        ),
                        Text(this.total ?? ""),
                      ],
                    ),
                    Divider(
                      height: 5.0,
                    ),
                    new Catelog(this.maleMenu, (item) {
                      this.getBookByTypeSv(item["href"]);
                      List femaleMenu = this.femaleMenu.map((f) {
                        if (f["current"] == true) {
                          f["current"] = false;
                        }
                        return f;
                      }).toList();
                      setState(() {
                        this.femaleMenu = femaleMenu;
                      });
                    }),
                    Divider(
                      height: 5.0,
                    ),
                    new Catelog(this.femaleMenu, (item) {
                      this.getBookByTypeSv(item["href"]);
                      List maleMenu = this.maleMenu.map((f) {
                        if (f["current"] == true) {
                          f["current"] = false;
                        }
                        return f;
                      }).toList();
                      setState(() {
                        this.maleMenu = maleMenu;
                      });
                    }),
                    Divider(
                      height: 5.0,
                    ),
                    this.loading == true
                        ? Loading()
                        : new BookList(this.bookList)
                  ],
                ),
              ),
            ),
          ),
          this.opacity > 0
              ? Container(
                  // main menu
                  color: Color.fromRGBO(10, 10, 10, this.opacity - 0.1),
                  child: Flex(
                    direction: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: this.mainMenu.map((item) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 30.0,
                        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                        margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 1.0, color: Colors.white))),
                        child: MaterialButton(
                          onPressed: () =>
                              this.handleChooseMainMenu(item["type"]),
                          padding: EdgeInsets.all(0),
                          child: Text(
                            item["subTxt"],
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  // get book lsit
  Future<void> getBookList() async {
    var res = await getHotBook();
    this.bookList = res["hotBook"];
    List femaleMenu = res["femaleMenu"];
    List maleMenu = res["maleMenu"];
    femaleMenu.insert(0, {"subTxt": "【女频】"});
    maleMenu.insert(0, {"subTxt": "【男频】"});

    setState(() {
      this.maleMenu = maleMenu;
      this.femaleMenu = femaleMenu;
      this.total = null;
      this.opacity = 0;
      this.loading = false;
    });
    // this._controller.jumpTo(0);
  }
}

class Catelog extends StatefulWidget {
  final List menuList;
  final Function chooseCatelog;
  Catelog(this.menuList, this.chooseCatelog);

  _Catelog createState() => _Catelog();
}

class _Catelog extends State<Catelog> {
  Map lastItem;

  void handleChoose(item) {
    if (item["href"] == null) {
      return;
    }
    widget.chooseCatelog(item);
    setState(() {
      if (this.lastItem != null) {
        this.lastItem["current"] = false;
      }
      item["current"] = true;
    });
    this.lastItem = item;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: widget.menuList != null
            ? widget.menuList.map((f) {
                return Container(
                  height: 35.0,
                  color: f["current"] == true
                      ? Color.fromRGBO(251, 188, 5, 1)
                      : Colors.white,
                  child: MaterialButton(
                    padding: EdgeInsets.all(0),
                    minWidth: 53.0,
                    onPressed: () => this.handleChoose(f),
                    child: Text(
                      f["subTxt"] ?? "-",
                      style: TextStyle(
                        color:
                            f["current"] == true ? Colors.white : Colors.black,
                        fontSize: 16.0,
                        wordSpacing: 2.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                );
              }).toList()
            : Text('-'),
      ),
    );
  }
}
