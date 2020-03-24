import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final double height;
  final Color backgroundColor;
  final double strokeWidth;
  final Color valueColor;

  Loading(
      {this.backgroundColor, this.height, this.strokeWidth, this.valueColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      height: this.height,
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        backgroundColor: this.backgroundColor ?? Colors.transparent,
        valueColor:
            AlwaysStoppedAnimation(this.valueColor ?? Colors.blueAccent),
        strokeWidth: this.strokeWidth ?? 4.0,
      ),
    );
  }
}

class Empty extends StatelessWidget {
  final String content;
  Empty({this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[Text(this.content ?? 'Empty')],
      ),
    );
  }
}

class ModalSheet extends StatelessWidget {
  ModalSheet(this.items, {this.onPressed});

  final List items;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    if (this.items == null || this.items.isEmpty == true) {
      return Empty();
    }
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
      itemCount: this.items.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 0.5, color: Colors.black12))),
          child: MaterialButton(
            onPressed: () => this.onPressed(index),
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Text(
                  this.items[index],
                  style: TextStyle(fontSize: 15.0),
                ),
              ],
            ),
          ),
        );
      },
    );

    // return ListView(
    //   padding: EdgeInsets.fromLTRB(20.0,0,20.0,0),
    //   children: this.items.map((item) {
    //     return Container(
    //       decoration: BoxDecoration(
    //         border: Border(
    //           bottom: BorderSide(width: 0.5, color: Colors.black12)
    //         )
    //       ),
    //       child: MaterialButton(
    //         onPressed: () {},
    //         padding: EdgeInsets.all(15.0),
    //         child: Column(
    //           children: <Widget>[
    //             Text(
    //               item,
    //               style: TextStyle(fontSize: 15.0),
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   }).toList(),
    // );
  }
}
