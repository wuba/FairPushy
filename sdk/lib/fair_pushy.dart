export 'src/project.dart';
export 'src/widget/widget.dart';
import 'package:flutter/material.dart';
import 'src/log/logger.dart';
import 'src/delegate.dart';
import 'src/http/entity/config.dart';
import 'src/project.dart';
import 'src/widget/page_builder.dart';

class FairPushy {
  /// [FairPushy] 初始化数据
  /// productID ：热更新web平台上创建的项目id
  /// bundleConfigUrl : 获取bundle的config数据的url
  /// debug：是否是debug模式
  ///
  static void init({String? appID, required String updateUrl, bool? debug}) {
    ProjectConfig product = ProjectConfig.instance;
    product.appID = appID;
    product.BUNDLE_PATCH_URL = updateUrl;
    product.isDebug = debug ?? false;
    Delegate.loadFolderPath();
  }

  /// 通过bundleid更新
  /// '''
  /// 先获取bundleid对应的补丁config，再调用downloadConfig
  /// '''
  static Future<Code> updateBundle({required String bundleId}) {
    return Delegate.updateFW(bundleId: bundleId);
  }

  /// 获取项目中所有bundle的config文件
  /// url 部署的获取补丁列表的url
  /// '''
  /// 如果想一进app就下载所有bundle的文件，先调用getConfigs获取所有的补丁配置，
  /// 再调用downloadConfig下载所有的补丁
  /// '''
  static Future<List<Config>?> getConfigs(String url) {
    if (ProjectConfig.instance.appID == null) {
      Logger.logi('请先在初始化方法中填入appid，appid可在热更新可视化平台中查看');
      return Future.value(null);
    }
    return Delegate.getConfigs(url, appId: ProjectConfig.instance.appID ?? "");
  }

  /// 通过config下载补丁文件，如果已经是最新的，直接返回Code.success
  static Future<Code> downloadConfig(Config config) async {
    return Delegate.downloadConfig(config);
  }

  /// 设置代理
  static void setProxy(String proxy) {
    ProjectConfig.instance.URL_PROXY = proxy;
  }

  /// 返回热更新文件路径
  static String getFilePath(
      {required String bundleId, required String? filename}) {
    return Delegate.getFairPath(bundleId: bundleId, filename: filename);
  }

  /// 注册widgets
  /// 只需要注册module间跳转的本地目标页面，如果目标页面是动态界面，不需要注册
  static void registerPageBuilders(Map<String, FPageBuilder>? builders) {
    PageBuilder.instance.registerPageBuilders(builders);
  }

  static void registerPageBuilder(String pageName, FPageBuilder? builder) {
    PageBuilder.instance.registerPageBuilder(pageName, builder);
  }

  static void registerPlaceholderBuilder(WidgetBuilder builder) {
    PageBuilder.instance.placeholderBuilder = builder;
  }
}
