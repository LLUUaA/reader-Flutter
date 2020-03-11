import 'package:flutter/material.dart';

class Discover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (BuildContext context, int i) {
            return Center(
              child: FlatButton(
                child: Text('List $i'),
                onPressed: (){},
              ),
            );
          },
          // itemExtent: 50.0,
        ),
      ),
    );
  }
}
