import 'package:flutter/material.dart';
import './toast.dart';

class MyWillPopScope extends StatelessWidget {
  final Widget child;
  MyWillPopScope({this.child});

  DateTime lastClick;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: this.child ?? null,
      onWillPop: () async {
        if (lastClick == null ||
            DateTime.now().difference(lastClick) > Duration(seconds: 1)) {
          lastClick = DateTime.now();
          Toast.toast(context, msg: '再按一次退出',position: ToastPostion.bottom);
          return false;
        }
        return true;
      },
    );
  }
}
