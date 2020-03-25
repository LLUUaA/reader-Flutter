import 'package:flutter/material.dart';

class ImageLoad extends StatefulWidget {
  ImageLoad(this.src,
      {this.height,
      this.width,
      this.fit,
      this.alignment,
      this.defaultPath = 'lib/assets/images/no_image.jpg'});

  final String src;
  final double height;
  final double width;
  final Alignment alignment;
  final BoxFit fit;
  final String defaultPath;
  @override
  _ImageLoad createState() => _ImageLoad();
}

class _ImageLoad extends State<ImageLoad> {
  Widget _widget;
  static const int MAX_LOAD_TIMES = 1;
  int errTimes = 0;
  String lastSrc;

  @override
  void initState() {
    super.initState();
    // load(); @p1
  }

  // TODO: add load image state

  @override
  Widget build(BuildContext context) {
    // fix src changed but image not update
    if(lastSrc != widget.src) {
      lastSrc = widget.src;
      this.load(); // =>p1
    }
    return _widget ??
        Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[300],
          child: Center(
            child: Text(
              'loading',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
  }

  // load image
  void load() {
    Image image = Image.network(widget.src,
        width: widget.width,
        height: widget.height,
        alignment: widget.alignment ?? Alignment.center,
        fit: widget.fit ?? BoxFit.contain);
    ImageStream imageStream = image.image.resolve(ImageConfiguration.empty);
    imageStream.addListener(
      ImageStreamListener(
        (_, __) {
          // print("image success.");
          setState(() {
            _widget = image;
          });
        },
        onError: (dynamic exception, StackTrace stackTrace) {
          if (MAX_LOAD_TIMES > errTimes) {
            errTimes++;
            this.load();
            return;
          }

          //----------- Image -----------
          // print("image err");
          setState(() {
            _widget = Center(
              child: Image.asset(widget.defaultPath,
                  width: widget.width,
                  height: widget.height,
                  fit: BoxFit.fitWidth),
            );
          });

          //----------- Text -----------
          // setState(() {
          //   _widget = Container(
          //     width: widget.width,
          //     height: widget.height,
          //     color: Colors.grey[300],
          //     child: Center(
          //       child: Text(
          //         '加载错误',
          //         style: TextStyle(color: Colors.white),
          //       ),
          //     ),
          //   );
          // });
        },
      ),
    );
  }
}
