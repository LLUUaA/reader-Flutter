import 'package:myapp/common/request.dart';

Future readBook(int bookId, int chapterNum) {
  return Request.request(
      api: "book/chapter/details/$bookId/${chapterNum ?? 1}");
}

Future getHotBook() {
  return Request.request(api: "book/home");
}

Future getBook(int bookId, {bool onlyBookInfo = true}) async {
  return await Request.request(
      api: "book/chapter/$bookId", query: {"onlyBookInfo": onlyBookInfo});
}

Future getChapterList(int bookId, {int pageIndex}) {
  return Request.request(api: "book/chapter/other/$bookId/${pageIndex ?? 1}");
}

Future getBookByType(String type) {
  return Request.request(api: "book$type");
}

// add bookshelf
Future addBookShelf(int bookId, Map<String, dynamic> bookInfo) {
  return Request.request(
      api: "book/bookshelf/add",
      method: 'post',
      body: {"bookId": bookId, "bookInfo": bookInfo});
}

// remove BookShelf
Future removeBookShelf(int bookId) {
  return Request.request(
      api: "book/bookshelf/remove", method: 'post', body: {"bookId": bookId});
}

// 获取首页书架
Future getBookShelf() {
  return Request.request(api: "book/bookshelf");
}

// 搜索
Future searchBook(String keyword, {int pageIndex = 1, int pageSize = 20}) {
  if (keyword == null || keyword.isEmpty) {
    Future.error('params error');
  }

  keyword = keyword.trim();
  return Request.request(
      api: "book/search/$keyword",
      query: {pageIndex: pageIndex, pageSize: pageSize});
}
