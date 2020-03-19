import 'package:flutter/material.dart';

class BookItem extends StatelessWidget {
  final int id;
  final String name;
  final String coverImgSrc;
  final String descript;
  BookItem({this.id, this.name, this.coverImgSrc, this.descript});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/bookDetails',
            arguments: <String, int>{
              "id": this.id,
            });
      },
      child: Container(
        height: 130.0,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                width: 0.5, color: Colors.grey[300], style: BorderStyle.solid),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 90.0,
              height: 110.0,
              alignment: Alignment.center,
              color: Colors.grey[300],
              child: Image.network(
                this.coverImgSrc,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 110.0,
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      this.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(2.0, 5.0, 0.0, 0.0),
                    child: Text(
                      this.descript,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BookList extends StatelessWidget {
  final List bookList;
  BookList(this.bookList);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: this.bookList.map((item) {
        return BookItem(
          id: item["bookId"],
          name: item["name"] ?? "-",
          coverImgSrc: item["coverImg"] ?? "",
          descript: item["description"] ?? "-",
        );
      }).toList(),
    );
  }
}
