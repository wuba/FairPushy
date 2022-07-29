class Routes {
  /**
   * APP-获取补丁文件
   */
  static const GET_APP_PATCH = '/app/patch'; //获取补丁文件

  /**
   * WEB-配置平台相关接口
   */
  static const GET_PROJECT = '/web/project'; //获取项目
  static const CREATE_PROJECT = '/web/createApp'; //创建项目
  static const PROJECT_LIST = '/web/getAppList'; //获取项目列表
  static const GET_APP_PATCH_LIST = '/web/module_patch'; //获取补丁列表
  static const CREATE_APP_PATCH = '/web/create_patch'; //创建补丁
  static const OPERATING_RECORD = '/web/operating_record'; //获取操作记录

  /**
   * 打包平台-在线构建相关接口
   */
  static const ONLINE_BUILD = '/web/onlineBuild'; //打包平台-在线构建
  static const CHECK_BUILD_STATUS = '/web/checkBuildStatus'; //打包平台-检查构建状态
  static const CREATE_APP_PATCH_AND_BUILD ="/web/create_patch_and_build"; //创建模块补丁并在线构建
}
