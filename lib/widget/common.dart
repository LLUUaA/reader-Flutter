import 'package:flutter/material.dart';
import '../common/myColors.dart';

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
  ModalSheet(this.items,
      {this.onPressed, this.onCancel, this.showCancel = true});

  final List items;
  final bool showCancel;
  final Function onPressed;
  final Function onCancel;
  static const double boxH = 55.0;
  static const double dividerH = 6.0;
  static const double cancelH = boxH + dividerH;

  @override
  Widget build(BuildContext context) {
    if (items == null || items.isEmpty == true) {
      return Empty();
    }

    List<Widget> _widgets = [];
    // content
    for (var i = 0; i < items.length; i++) {
      _widgets.add(getItemView(
        items[i],
        onPressed: () => this.onPressHandle(context, i),
      ));
    }

    if (showCancel) {
      _widgets.add(Divider(
        height: dividerH,
        thickness: dividerH,
        color: MyColors.hexToRgba("#eee"),
      ));
      _widgets.add(getItemView(
        "取消",
        onPressed: () => this.onPressHandle(context, -1),
      ));
    }

    return Container(
      height: boxH * this.items.length + (showCancel ? cancelH : 0),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: _widgets,
      ),
    );
  }

  void onPressHandle(BuildContext context, int index) {
    Navigator.of(context).pop(); // close modal
    if (index == -1 && onCancel != null) {
      onCancel();
    } else if (index > -1 && onPressed != null) {
      onPressed(index);
    }
  }

  Widget getItemView(String item, {Function onPressed}) {
    return MaterialButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Container(
        // width: MediaQuery.of(context).size.width,
        height: boxH,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.5, color: Colors.black12)),
        ),
        child: Text(
          item,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15.0),
        ),
      ),
    );
  }
}
