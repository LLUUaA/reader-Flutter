import 'dart:ui';
class Util {
  /// flutter中默认组件尺寸单位都是dp,我们还要进行px->dp的操作.除以像素密度就好了.
  /// dp = px / (ppi / 160)
  /// 
  static double wPixelRatio = window.devicePixelRatio;

  /// 获取
  double getDeviceDp (double size) {
    return size / (wPixelRatio/160);
  }
}