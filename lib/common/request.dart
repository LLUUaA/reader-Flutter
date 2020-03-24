import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../config/index.dart';
import './global.dart';

class Request {
  static String baseUrl;
  static Map<String, String> headers;

  static Future<void> init() {
    baseUrl = Config.host;
    return null;
  }

  static Future request(
      {String method = "get", String api, Map query, body}) async {
    http.Response resp;
    headers = {"Authorization": "SessionKey ${Global.session ?? ''}"};
    String url = "$baseUrl/$api";
    switch (method) {
      case "get":
        String queryStr = parseQueryString(query);
        resp = await http.get("$url$queryStr", headers: headers);
        break;
      case "post":
        resp = await http.post(url,
            headers: headers, body: convert.json.encode(body ?? null));
        break;
      default:
        return Future.error("method not support");
        break;
    }

    if (resp.statusCode == 204) {
      return body;
    }

    if (resp.statusCode == 200) {
      dynamic body = convert.json.decode(resp.body);
      return body;
    } else {
      // throw Exception(resp.body);
      return Future.error(resp.body);
    }
  }

  static String parseQueryString(Map query) {
    String queryStr = "";
    if (query == null) {
      return "";
    }
    query.forEach((k, v) {
      queryStr += "$k=$v";
    });
    return "?$queryStr";
  }
}
