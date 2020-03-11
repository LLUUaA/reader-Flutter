import 'package:flutter/material.dart';

class BookShelf extends StatefulWidget {
  @override
  _BookShelf createState() => _BookShelf();
}

class _BookShelf extends State<BookShelf> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SearchWidget(),
            Container(
              height: MediaQuery.of(context).size.height - 150.0,
              decoration: BoxDecoration(
                  // image: DecorationImage(
                  //   image: NetworkImage('http://pic.3gbizhi.com/2016/0422/20160422013335974.jpg.720.1280.jpg'),
                  //   fit: BoxFit.fitWidth,
                  // ),
                  ),
              child: SingleChildScrollView(
                child: Wrap(
                  children: <Widget>[
                    ViewDemo(
                      // color: Colors.red[100],
                      content: 'Content',
                    ),
                    ViewDemo(
                      // color: Colors.red[200],
                      content: 'Content',
                    ),
                    ViewDemo(
                      // color: Colors.red[300],
                      content: 'Content',
                    ),
                    ViewDemo(
                      // color: Colors.red[400],
                      content: 'Content',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewDemo extends StatelessWidget {
  ViewDemo({this.color, @required this.content});

  final Color color;
  final String content;

  //https://img.xiashu.app/cover/12/12188.jpg

  @override
  Widget build(BuildContext context) {
    // const cWidth = MediaQuery.of(context).size.width;
    return Container(
      width:  MediaQuery.of(context).size.width / 3,
      // height: MediaQuery.of(context).size.width / 2,
      alignment: Alignment.center,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
      color: color,
      child: Column(
        children: <Widget>[
          Image.network('https://image-res.mzres.com/image/flyme-icon/99103bd85a1042ae9365833a55857ca4z',
          width: MediaQuery.of(context).size.width * 0.26,
          height: MediaQuery.of(context).size.width * 0.31,
          fit: BoxFit.cover,
          ),
          Text('<<三体>>')
        ],
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
      margin: EdgeInsets.all(10.0),
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
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return AboutWidget();
          // }));
          Navigator.pushNamed(context, 'about');
        },
      ),
    );
  }
}
