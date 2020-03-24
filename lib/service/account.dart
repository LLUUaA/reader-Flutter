import 'package:myapp/common/request.dart';
import '../common/global.dart';

Future login(String deviceId) async {
  var resp = await Request.request(api: "account/login",method: 'post', body: {
    "deviceId": deviceId
  });
  Global.session = resp["session"];
  return resp;
}