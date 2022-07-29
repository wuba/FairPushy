import 'package:HotUpdateService/server/src/get_server.dart';
import 'package:HotUpdateService/server/fair_server_routes.dart';
import 'package:HotUpdateService/pages/project/view/project_create_page.dart';
import 'package:HotUpdateService/pages/project/view/project_list_page.dart';
import 'package:HotUpdateService/pages/project/view/project_query_page.dart';
import 'package:HotUpdateService/pages/patch/view/patch_create_page.dart';
import 'package:HotUpdateService/pages/patch/view/patch_list_query_page.dart';
import 'package:HotUpdateService/pages/patch/view/patch_create_page_and_build.dart';
import 'package:HotUpdateService/pages/patch/view/patch_query_page.dart';
import 'package:HotUpdateService/pages/compile/view/check_build_status_page.dart';
import 'package:HotUpdateService/pages/compile/view/online_build_page.dart';
import 'package:HotUpdateService/pages/record/view/record_query_page.dart';

/*
* 接口路由配置，Server端提供的所有接口需在routes中配置相关参数
* GetPage中主要参数：
*   name：请求的url名字
*   page：Widget页面主要是当前接口的实现逻辑
*   method：请求方式
*   needAuth：是否需要登录鉴权 true：鉴权：   false：不做鉴权
*
* Created by Wang Meng on 2022/5/11.
* Copyright © 2022 58. All rights reserved.
*
* */
mixin AppPages {
  static final routes = [
    GetPage(
      name: Routes.GET_APP_PATCH, //获取补丁文件
      page: () => GetPatchPage(),
      method: Method.get, //请求方式
      needAuth: false, //
    ),
    GetPage(
      name: Routes.GET_PROJECT, //获取项目详情
      page: () => GetProjectPage(),
      method: Method.post,
    ),
    GetPage(
      name: Routes.CREATE_PROJECT, //创建项目
      page: () => CreateProjectPage(),
      method: Method.post,
    ),
    GetPage(
      name: Routes.PROJECT_LIST, //获取项目列表
      page: () => ProjectListPage(),
      method: Method.post,
      needAuth: false,
    ),
    GetPage(
      name: Routes.GET_APP_PATCH_LIST, //获取补丁列表
      page: () => GetPatchListPage(),
      method: Method.get,
      needAuth: false,
    ),
    GetPage(
      name: Routes.CREATE_APP_PATCH, //创建补丁
      page: () => CreatePatchPage(),
      method: Method.post,
    ),
    GetPage(
      name: Routes.OPERATING_RECORD, //获取操作记录
      page: () => GetRecordPage(),
      method: Method.post,
      needAuth: false,
    ),
    GetPage(
      name: Routes.ONLINE_BUILD, //打包平台-在线构建
      page: () => OnlineBuildPage(),
      method: Method.post,
      needAuth: false,
    ),
    GetPage(
      name: Routes.CHECK_BUILD_STATUS, //打包平台-检查构建状态
      page: () => CheckBuildStatusPage(),
      method: Method.post,
      needAuth: false,
    ),
    GetPage(
      name: Routes.CREATE_APP_PATCH_AND_BUILD, //创建模块补丁并在线构建
      page: () => CreatePatchAndBuildPage(),
      method: Method.post,
      needAuth: false,
    )
  ];
}
