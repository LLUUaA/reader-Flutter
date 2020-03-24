import 'package:flutter/material.dart';

import '../../widget/bookList.dart' show BookList;
import '../../service/book.dart' show searchBook;

class Search extends StatefulWidget {
  Search();

  @override
  _Search createState() => _Search();
}

class _Search extends State<Search> {
  List bookList;
  bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('搜索'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 50.0,
                child: TextField(
                  keyboardType: TextInputType.text,
                  onSubmitted: this._searchSv,
                  decoration: InputDecoration(
                    hintText: "搜索",
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                        gapPadding: 0,
                        borderSide: BorderSide(
                          width: 1.0,
                        )),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 150,
                child: SingleChildScrollView(
                  child: BookList(
                    this.bookList,
                    defaultString: '搜索',
                    isLoading: this.isLoading,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _searchSv(String val) async {
    setState(() {
      this.isLoading = true;
    });
    try {
      Map res = await searchBook(val);
      setState(() {
        this.bookList = res['result'];
        this.isLoading = false;
      });
    } catch (e) {
      setState(() {
        this.isLoading = false;
      });
    }
  }
}
