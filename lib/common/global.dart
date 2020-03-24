class Global {
  static bool isRelease;

  static Future<void> init() async {
    isRelease = bool.fromEnvironment("dart.vm.product");
    return null;
  }

  static String session;
  // get session => this.session;
}
