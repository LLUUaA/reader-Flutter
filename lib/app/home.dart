import 'package:flutter/material.dart';

import './home/bookShelf.dart';
import './home/discover.dart';
import './home/menu.dart';

class Home extends StatefulWidget {
  int currentIndex = 0;
  PageController pageController;
  Home() {
    this.pageController = new PageController(initialPage: this.currentIndex);
  }
  _HomeWidget createState() => _HomeWidget();
}

class _HomeWidget extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: (int index) {
          /// jump to
          widget.pageController.jumpToPage(index);
          // widget.pageController.animateToPage(
          //   index,
          //   duration: Duration(milliseconds: 300),
          //   curve: Curves.ease,
          // );
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            title: Text('Book'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            title: Text('Menu'),
          ),
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: widget.pageController,
          // physics: NeverScrollableScrollPhysics(),
          onPageChanged: (int index) {
            /// set bottomBar index
            setState(() {
              widget.currentIndex = index;
            });
          },
          children: <Widget>[
            BookShelf(),
            Discover(),
            Menu(),
          ],
        ),
      ),
    );
  }
}

class ViewDemo extends StatelessWidget {
  final String content;
  final Color color;
  ViewDemo(this.content, this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(content),
      ),
    );
  }
}
