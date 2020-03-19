import 'package:myapp/common/request.dart';

Request request = new Request();

Future readBook(int bookId, int chapterNum) {
  return request.request(api: "book/chapter/details/$bookId/${chapterNum ?? 1}");
}

Future getHotBook() {
  return request.request(api: "book/home");
}

Future getBook(int bookId, {bool onlyBookInfo = true}) async {
  var res = await request.request(
      api: "book/chapter/$bookId", query: {"onlyBookInfo": onlyBookInfo});
  return res["bookInfo"];
}

Future getChapterList(int bookId, {int pageIndex}) {
  return request.request(api: "book/chapter/other/$bookId/${pageIndex ?? 1}");
}

Future getBookByType(String type) {
  return request.request(api: "book$type");
}
