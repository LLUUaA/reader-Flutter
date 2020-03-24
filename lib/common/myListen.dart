// import 'dart:math' show Random;
typedef void EventCallback(args);

class MyEvent {
  static String login = "_EVENT_LOGIN";
  static String addBookShelf = "_EVENT_ADDBOOKSHELF";
}

class ListenerBack {
  final Function remove; // [remove] remove 当前函数回调
  final Function clear; // [clear] clear 整个事件回调 (有需求可开放clear任意事件)
  ListenerBack(this.remove, this.clear);
}

class MyListener {
  static Map callbacks = new Map<String, dynamic>();
  static const int MAX_NUM = 1000000;
  static int currentNum = 1;

  static String generateKey() {
    // int kNum = Random().nextInt(1000000);
    // String key = kNum.toRadixString(36);
    // String key = currentNum.toRadixString(36);
    return currentNum.toRadixString(36);
  }

  static ListenerBack on(String eventName, EventCallback cb) {
    String key = generateKey();
    currentNum++;
    callbacks[eventName] ??= new Map();
    callbacks[eventName][key] = cb;
    // print('callbacks[eventName] ${callbacks[eventName]} callbacks =${MyListener.callbacks}');

    // backFn.addAll({
    //   // [remove] remove 当前函数回调
    //   "remove": () => callbacks[eventName].remove(key),
    //   // [clear] clear 整个事件回调 (有需求可开放clear任意事件)
    //   "clear": () => callbacks.remove(eventName),
    // });
    return new ListenerBack(
      () => callbacks[eventName].remove(key),
      () => callbacks.remove(eventName),
    );
  }

  static void emit(String eventName, [args]) {
    if (callbacks.containsKey(eventName) == true) {
      Map eventMap = callbacks[eventName];
      eventMap.forEach((key, cb) {
        try {
          cb(args);
        } catch (e) {
          // do someting
        }
      });
    }
  }
}
