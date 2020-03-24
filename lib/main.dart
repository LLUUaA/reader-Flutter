import 'package:flutter/material.dart' show runApp;
import './common/global.dart';
import './config/index.dart';
import './common/request.dart';
import './views/app.dart';

void main() async {
  await Global.init(); // global
  await Config.init(); // config
  await Request.init();
  runApp(new MyApp());
}
