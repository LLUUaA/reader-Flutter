import 'dart:io' show File, FileSystemEntity, Directory;

enum dd { x, y, z }

abstract class StorageInstant {
  Future<void> setStorage(String key, dynamic data);
  Future<dynamic> getStorage(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

class Storage extends StorageInstant {
  static const String storageDir = "./storage";
  static const String storageFileName = "storage.json";

  File _file;
  Directory _directory;

  Storage() {
    this._init();
  }

  Future<void> _initDirectory() {
    print('storageDir= $storageDir');
    _directory = new Directory(storageDir);
    if (_directory.existsSync() == false) {
      /// 如果[recursive]为false，则仅创建路径中的最后一个目录。 如果[recursive]为true，则创建所有不存在的路径组件。 如果目录已经存在，则不执行任何操作。
      /// 如果无法创建目录，则会引发异常。

      _directory.createSync();
    }

    return null;
  }

  Future<void> _initFile() {
    _file = new File('$storageDir/$storageFileName');
    if (_file.existsSync() == false) {
      /// 同步创建文件。 [createSync]使现有文件保持不变。 如果对现有文件具有限制性权限，则在该文件上调用[createSync]可能会失败。
      /// 如果[recursive]为false（默认值），则仅当路径中的所有目录都存在时才创建文件。 如果[recursive]为true，则创建所有不存在的路径组件。
      _file.createSync();
    }
    // String readAsString = file.readAsStringSync();
    return null;
  }

  void _init() async {
    await _initDirectory();
    await _initFile();

    print('file existsSync= ${_file.existsSync()}');
  }

  @override
  Future<void> setStorage(String key, data) {
    // TODO: implement setStorage
    return null;
  }

  @override
  Future getStorage(String key) {
    // TODO: implement getStorage
    return null;
  }

  @override
  Future<void> remove(String key) {
    // TODO: implement remove
    return null;
  }

  @override
  Future<void> clear() {
    // TODO: implement clear
    return null;
  }
}
