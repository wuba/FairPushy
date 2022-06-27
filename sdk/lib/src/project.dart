class ProjectConfig {
  ProjectConfig._privateConstructor();
  static final ProjectConfig _instance = ProjectConfig._privateConstructor();
  static ProjectConfig get instance {
    return _instance;
  }

  String? appID;
  bool isDebug = false;
  // ignore: non_constant_identifier_names
  String APP_PATCH_URL = "";
  // ignore: non_constant_identifier_names
  String BUNDLE_PATCH_URL = "";
  // ignore: non_constant_identifier_names
  String URL_PROXY = ""; //"PROXY 10.252.200.248:8888";
}
