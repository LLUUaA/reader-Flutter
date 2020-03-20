import 'package:myapp/common/request.dart';
Request request = new Request();
Future login(Map data) {
  return request.request(api: "/login",method: 'post', body: data);
}