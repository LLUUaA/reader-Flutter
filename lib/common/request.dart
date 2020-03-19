import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../config/index.dart' as config;

class Request {
  String api;
  String method;
  String baseUrl;
  Map<String, String> headers;
  Map data;
  Map query;

  Request() {
    this.init();
  }

  void init() {
    this.baseUrl = "http://192.168.0.104:3000";
    this.headers = {"authorizationHeader": "token"};
  }

  Future request({String method = "get", String api, Map query, Map body}) async {
    var resp;
    switch (method) {
      case "get":
        String queryStr = this.parseQueryString(query);
        resp = await http.get("${this.baseUrl}/$api$queryStr", headers: this.headers);
        break;
      case "post":
        resp = await http.post(api, headers: this.headers, body: body);
        break;
      default:
        break;
    }

    if (resp.statusCode == 200) {
      Map body = convert.json.decode(resp.body);
      return body;
    } else {
      throw Future.error(resp);
    }
  }

  String parseQueryString(Map query) {
    String queryStr = "";
    if (query == null) {
      return "";
    }
    query.forEach((k,v){
      queryStr += "$k=$v";
    });
    return "?$queryStr";
  }
}
