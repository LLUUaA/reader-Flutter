import './dev.dart';
import './prod.dart';
import '../common/global.dart';

class Config {
  static Future<void> init() async {
    void _initDev() {
      host = DevConfig.host;
    }

    void _initProd() {
      host = ProdConfig.host;
    }

    Global.isRelease == true ? _initProd() : _initDev();
    return null;
  }

  static String host; // host
}
