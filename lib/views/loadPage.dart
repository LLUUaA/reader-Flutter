import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';

import '../service/account.dart' show login;

class LoadPage extends StatefulWidget {
  @override
  _LoadPage createState() => _LoadPage();
}

class _LoadPage extends State<LoadPage> {
  bool showJumpButton;

  @override
  void initState() {
    super.initState();
    this._init();
  }

  Future _init() async {
    try {
      await this.loginSv();
      setState(() {
        showJumpButton = true;
      });
    } catch (e) {
      // TODO: login error handle
    }
  }

  // get device infos
  Future<String> getDeviceId() async {
    AndroidDeviceInfo android = await DeviceInfoPlugin().androidInfo;
    // IosDeviceInfo ios = await DeviceInfoPlugin().androidInfo;
    return android.androidId;
  }

  // login
  Future loginSv() async {
    String deviceId = await this.getDeviceId();
    try {
      var res = await login(deviceId);
      print('login success => $res');
      return res;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size contentSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        // height: ,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              child: Center(
                child: Image.asset('lib/assets/images/book_lover.png'),
              ),
            ),
            Positioned(
              bottom: 40.0,
              width: contentSize.width,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  '青莲一页',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none),
                ),
              ),
            ),
            Positioned(
              width: contentSize.width,
              bottom: 10.0,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Copyright © 2019-present WuQingSong',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13.0,
                      decoration: TextDecoration.none),
                ),
              ),
            ),
            this.showJumpButton == true
                ? Positioned(
                    bottom: 60.0,
                    right: 5.0,
                    child: CountDown(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

// count down
class CountDown extends StatefulWidget {
  final int secends;
  CountDown({this.secends = 3});

  @override
  _CountDown createState() => _CountDown();
}

class _CountDown extends State<CountDown> {
  bool _lock;
  @override
  void initState() {
    super.initState();
    this._init();
  }

  // init
  void _init() async {
    await Future.delayed(Duration(seconds: widget.secends));
    this.jumpTo();
  }

  // to home
  void jumpTo() {
    if (this._lock == true) {
      return;
    }
    this._lock = true;
    Navigator.of(context).popAndPushNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.all(0),
      onPressed: this.jumpTo,
      child: Text(
        '跳过',
        style: TextStyle(letterSpacing: 2.0),
      ),
    );
  }
}
