import 'package:flutter/material.dart' show Color;

class MyColors {
  static Color hexToRgba(String hex, {double opacity = 1.0}) {
    hex = hex.trim();
    if (hex.indexOf('#') == 0) {
      hex = hex.substring(1);
    }
    // 色号
    if (hex.length != 3 && hex.length != 6) {
      return Color.fromRGBO(0, 0, 0, opacity);
    }
    // 3位色号
    if (hex.length == 3) {
      hex = hex.split("").map((str) {
        return '$str$str';
      }).join("");
    }
    int r = int.parse(hex.substring(0, 2), radix: 16);
    int g = int.parse(hex.substring(2, 4), radix: 16);
    int b = int.parse(hex.substring(4, 6), radix: 16);
    // print('hex=$hex r=$r g=$g b=$b');
    return Color.fromRGBO(r, g, b, opacity);
  }

  static Color grey = hexToRgba("#c5c9cd");
}
