import 'package:flutter/material.dart';

import 'package:myapp/service/book.dart' show readBook;
import 'package:myapp/widget/toast.dart';
import '../../widget/common.dart' show Loading;
import '../../common//myIcons.dart';
import '../../common/myColors.dart';

typedef void HandleSettings(String event, {String handType});

class DragStart {
  DragStart({this.start, this.pageOffst});
  double start;
  double pageOffst;
}

// ignore: must_be_immutable
class Reader extends StatefulWidget {
  int id;
  int chapterNum;
  final Map arguments;
  Reader({this.id, this.chapterNum = 1, this.arguments}) {
    this.id = this.arguments["id"] ?? this.id;
    this.chapterNum = this.arguments["chapterNum"] ?? this.chapterNum;
  }
  _Reader createState() => _Reader();
}

class _Reader extends State<Reader> {
  List chapterContent;
  String chapterName;
  bool loading;
  bool showSetting;

  double rFontSize = 20.0;
  double rLineheight = 1.6;

  static Map lineHeightInterval = {"max": 2.0, "min": 1.2}; //行高区间 step->0.1
  static Map fontSizeInterval = {"max": 25, "min": 13}; //字体区间

  DragStart _dragStart = new DragStart(start: 0, pageOffst: 0);

  ScrollController _controller = new ScrollController();

  Color backgroundColor = MyColors.hexToRgba("#FDE6E0");
  Color _contentFontColor = MyColors.hexToRgba("#333");

  @override
  void initState() {
    // 滚动时关闭设置框
    _controller.addListener(() {
      // 防止过度build
      if (this.showSetting == true) {
        setState(() {
          this.showSetting = false;
        });
      }
    });
    super.initState();
    this.getBookDetails();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _booksWidget = [];

    if (this.chapterContent == null || this.loading == true) {
      // loading
      _booksWidget.add(Loading(height: MediaQuery.of(context).size.height));
    } else if (this.chapterContent.isNotEmpty) {
      // chapterName
      _booksWidget.add(Text(
        this.chapterName ?? '-',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ));
      // divider
      _booksWidget.add(Divider(
        color: MyColors.hexToRgba('#666'),
        thickness: 1.0,
      ));
      // reader content
      this.chapterContent.forEach((content) {
        _booksWidget.add(
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              '\t\t\t\t$content', // 首行缩进2字符
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: this.rFontSize,
                color: this._contentFontColor,
                height: this.rLineheight,
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
          ),
        );
      });
      // chapter button
      _booksWidget.addAll([
        Button(
          '上一章',
          color: Colors.transparent,
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          borderColor: MyColors.hexToRgba('#cecece'),
          height: 40.0,
          onTap: () => this.handleSettings('prev'),
        ),
        Divider(
          color: Colors.transparent,
          height: 10.0,
        ),
        Button(
          '下一章',
          color: Colors.transparent,
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          borderColor: MyColors.hexToRgba('#cecece'),
          height: 40.0,
          onTap: () => this.handleSettings('next'),
        )
      ]);
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: this.backgroundColor,
          child: GestureDetector(
            onTap: () {
              setState(() {
                this.showSetting = false;
              });
            },
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    controller: this._controller,
                    children: _booksWidget,
                  ),
                ),
                Center(
                  // popu setting click wrap
                  child: Container(
                    width: 140.0,
                    height: 130.0,
                    color: MyColors.hexToRgba("#eee", opacity: 0),
                    child: GestureDetector(
                      onVerticalDragStart: ((DragStartDetails _) {
                        this._dragStart.start = _.localPosition.dy;
                        this._dragStart.pageOffst = this._controller.offset;
                      }),
                      onVerticalDragUpdate: ((DragUpdateDetails _) {
                        double dy =
                            (this._dragStart.start - _.localPosition.dy) +
                                this._dragStart.pageOffst;
                        this._controller.jumpTo(dy);
                      }),
                      onTap: this.toggleShow,
                    ),
                  ),
                ),
                PopuSetting(
                  this.showSetting,
                  fontSize: this.rFontSize,
                  lineHeight: this.rLineheight,
                  cb: this.handleSettings,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // handleSettings
  void handleSettings<HandleSettings>(String event, {dynamic handType}) {
    switch (event) {
      case "changeBg":
        setState(() {
          this.backgroundColor = MyColors.hexToRgba(handType);
        });
        break;
      case "chapterDetails":
        Navigator.of(context)
            .pushNamed('/chapterDetails', arguments: {"id": widget.id});
        break;
      case "prev":
        this.getBookDetails(chapterNum: widget.chapterNum - 1);
        break;
      case "next":
        this.getBookDetails(chapterNum: widget.chapterNum + 1);
        break;
      case "fontSize":
        double fsize = this.rFontSize;
        if (handType == 'decrease') {
          if (fsize <= _Reader.fontSizeInterval["min"]) {
            Toast.toast(context,
                msg: "最大字号为${_Reader.fontSizeInterval['min']}哦");
            return;
          }
          fsize--;
        } else {
          if (fsize >= _Reader.fontSizeInterval["max"]) {
            Toast.toast(context,
                msg: "最大字号为${_Reader.fontSizeInterval['max']}哦");
            return;
          }
          fsize++;
        }
        setState(() {
          this.rFontSize = fsize;
        });
        break;
      case "lineHeight":
        double lh = this.rLineheight;
        if (handType == 'decrease') {
          if (lh <= _Reader.lineHeightInterval["min"]) {
            Toast.toast(context,
                msg: "最小行高为${_Reader.lineHeightInterval['min']}哦");
            return;
          }
          lh -= 0.1;
        } else {
          if (lh >= _Reader.lineHeightInterval["max"]) {
            Toast.toast(context,
                msg: "最大行高为${_Reader.lineHeightInterval['max']}哦");
            return;
          }
          lh += 0.1;
        }
        setState(() {
          this.rLineheight = double.parse(lh.toStringAsPrecision(2));
        });
        break;
      default:
    }
  }

  void toggleShow() {
    setState(() {
      this.showSetting = this.showSetting == true ? false : true;
    });
  }

  void getBookDetails({int chapterNum}) async {
    if (widget.id != null) {
      try {
        // jump to top
        this._controller?.jumpTo(0.1);
      } catch (e) {}

      setState(() {
        this.loading = true;
      });
      try {
        var res = await readBook(widget.id, chapterNum ?? widget.chapterNum);
        setState(() {
          this.chapterContent = res["chapterContent"];
          this.chapterName = res["chapterName"];
          widget.chapterNum = chapterNum ?? widget.chapterNum;
          this.loading = false;
        });
      } catch (e) {
        setState(() {
          this.loading = false;
        });
      }
    }
  }
}

// ignore: must_be_immutable
class PopuSetting extends StatelessWidget {
  PopuSetting(this.show,
      {@required this.cb, @required this.fontSize, @required this.lineHeight});
  final bool show;
  final HandleSettings cb;
  final double fontSize;
  final double lineHeight;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedPositioned(
          bottom: this.show == true ? 0 : -190.0,
          child: GestureDetector(
            onTap: () {
              return false;
            },
            child: Container(
              height: 190.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        HandleWrap(
                          content: '字号',
                          iconData: MyIcons.fontSize,
                          value: this.fontSize.toInt(),
                          onTap: (String type) =>
                              this.cb("fontSize", handType: type),
                        ),
                        HandleWrap(
                          content: '行高',
                          iconData: MyIcons.lineHeight,
                          value: lineHeight.toStringAsPrecision(2),
                          onTap: (String type) =>
                              this.cb("lineHeight", handType: type),
                        ),
                        // bg colors
                        new BgWrap(this.cb),
                        new HandleChapter(this.cb),
                      ],
                    ),
                    Positioned(
                      right: -10.0,
                      top: -5.0,
                      child: FlatButton.icon(
                        padding: EdgeInsets.all(0),
                        onPressed: () => this.cb("chapterDetails"),
                        label: Text(
                          '目录',
                          style: TextStyle(color: MyColors.grey),
                          textAlign: TextAlign.center,
                        ),
                        icon: Icon(
                          MyIcons.chapter,
                          color: MyColors.grey,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          curve: Curves.easeOut,
          duration: Duration(milliseconds: 300)),
    );
  }
}

// popu settings HandleChapter
class HandleChapter extends StatelessWidget {
  HandleChapter(this.cb);
  final HandleSettings cb;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Button(
            "上一章",
            onTap: () => this.cb("prev"),
            width: 150.0,
          ),
          Button(
            '下一章',
            onTap: () => this.cb("next"),
            width: 150.0,
          ),
        ],
      ),
    );
  }
}

class BgWrap extends StatelessWidget {
  static List<String> colors = [
    '#EAEAEF',
    '#FDE6E0',
    '#FAF9DE',
    '#DCE2F1',
    '#E3EDCD',
    '#DCE2F1',
    '#E9EBFE',
  ];
  static List<Widget> _widgts;

  final HandleSettings cb;
  BgWrap(this.cb) {
    _widgts = [];
    _widgts.add(Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Text(
        '背景',
        style: TextStyle(
          color: MyColors.grey,
          fontSize: 18.0,
        ),
      ),
    ));
    colors.forEach((color) {
      _widgts.add(Container(
        width: 28.0,
        height: 28.0,
        child: GestureDetector(
          onTap: () {
            this.cb("changeBg", handType: color);
          },
        ),
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
            color: MyColors.hexToRgba(color),
            borderRadius: BorderRadius.circular(50.0)),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.all(10.0),
      child: Wrap(
        children: BgWrap._widgts,
      ),
    );
  }
}

// popu settings handleWrap
class HandleWrap extends StatelessWidget {
  @override
  HandleWrap({
    @required this.content,
    @required this.onTap,
    @required this.iconData,
    @required this.value,
  });
  final String content;
  final Function onTap;
  final IconData iconData;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            this.iconData,
            size: 16.0,
            color: Color.fromRGBO(197, 201, 205, 1),
          ),
          Text(
            this.content,
            style: TextStyle(
              color: MyColors.grey,
              fontSize: 18.0,
            ),
          ),
          Button(
            '—',
            onTap: () => this.onTap('decrease'),
          ),
          Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Text(
              '${this.value}',
              style: TextStyle(color: MyColors.grey, fontSize: 18),
            ),
          ),
          Button(
            '+',
            onTap: () => this.onTap('increase'),
          ),
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  @override
  Button(this.content,
      {this.onTap,
      this.width,
      this.padding,
      this.margin,
      this.height,
      this.color,
      this.borderColor,
      this.fontColor});
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final String content;
  final Color color;
  final Color fontColor;
  final Color borderColor;
  final Function onTap;
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        width: this.width ?? 85.0,
        height: this.height ?? 35.0,
        padding: this.padding,
        margin: this.margin ?? EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
            color: this.color ?? MyColors.hexToRgba("#eee"),
            border: Border.all(color: this.borderColor ?? Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        alignment: Alignment.center,
        child: Text(
          this.content,
          style: TextStyle(fontSize: 17.0),
        ),
      ),
    );
  }
}
