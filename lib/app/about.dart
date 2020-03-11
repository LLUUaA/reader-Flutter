import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: SafeArea(
        child: FlatButton(
          color: Colors.lightBlue,
          child: Text('Back'),
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('tips'),
                    content: Text('content'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
