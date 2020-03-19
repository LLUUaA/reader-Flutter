import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final Color backgroundColor;
  final double strokeWidth;
  final Color valueColor;

  Loading({this.backgroundColor, this.strokeWidth, this.valueColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          CircularProgressIndicator(
            backgroundColor: this.backgroundColor ?? Colors.transparent,
            valueColor: AlwaysStoppedAnimation(this.valueColor ?? Colors.blueAccent),
            strokeWidth: this.strokeWidth ?? 4.0,
          )
        ],
      ),
    );
  }
}
