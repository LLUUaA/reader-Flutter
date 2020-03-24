import 'package:flutter/material.dart';

import './bookShelf.dart' show BookShelf;
import './discover.dart' show Discover;

// import './menu.dart' show Menu;

class Home extends StatefulWidget {
  int currentIndex;
  PageController pageController;
  Home({this.currentIndex = 0}) {
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.menu),
          //   title: Text('Menu'),
          // ),
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
            BookShelf(widget.pageController),
            Discover(),
            // Menu(),
          ],
        ),
      ),
    );
  }
}