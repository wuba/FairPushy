class FairRequesterConstants {
  static const String baseUrl = 'http://127.0.0.1:8080';
  static const String packingPlatformHost = 'http://127.0.0.1:8080';
  static const String cdnFileHost = '';
  static const String cdnTokenHost = '';

  //上传文件私有写接口
  static String cdnUploadFile() {
    return '/kLRHgFeDkLkL/dynamic/';
  }

  //获取token
  static String getCdnToken() {
    return '/get_token';
  }

  //打包平台在线构建接口
  static String onlineBuildInPackingPlatform() {
    return "/app/onlineBuild/";
  }

  //打包平台检查构建状态
  static String checkBuildStatusInPackingPlatform() {
    return "/app/checkBuildStatus/";
  }

}
