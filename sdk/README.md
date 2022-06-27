#### 引入SDK

```
fair_pushy:
   git:
           url: https://github.com/wuba/FairPushy.git
          path: sdk
```

#### 初始化SDK

```dart
FairPushy.init(
      appID: '1001',
      updateUrl: "https://fangfe.58.com/fairapp/module_patch_bundle",
      debug: true);
```

<!--appid：web可视化平台中的项目id-->

<!--updateUrl：接入方更新获取补丁config文件的服务器地址-->

<!--debug：运行环境-->



#### 调用模块更新api

```
FairPushy.updateBundle(bundleid: "6005")
```

 <!--bundleid可视化平台中模块对应的补丁唯一标识-->

该方法内部实现补丁更新逻辑，包括补丁配置文件的获取，判断是否更新，补丁的下载，解压，缓存逻辑。



#### 使用loading中间件

```dart
 FairPushyWidget(
         bundleid: BundleConst.car,
        // targetPageName: "car_cate"
       targetWidgetBuilder: (context) => CarCatePage());
```

 <!--targetPageName：module间跳转时的目标界面pagename，传入pagename需要在FairPushy中进行界面的注册，详见example示例工程-->

 <!--targetWidgetBuilder：module间跳转时的目标界面widget-->

在module间跳转的时候，可以先跳SDK中提供的中间件，中间件中实现了补丁的更新逻辑，走完更新补丁逻辑，会把目标页替换成传入的targetWidget。



#### getConfigs接口

如果接入方在多module的工程结构下，想进app就下载所有的补丁文件，可以调用该接口获取appid对应项目下的所有补丁config信息，然后调用downloadConfig方法进行下载。

```dart
FairPushy.getConfigs("https://fangfe.58.com/fairapp/module_patch_app").then((value) {
  if (null != value && value.isNotEmpty) {
    for (var i = 0; i < value.length; i++) {
      FairPushy.downloadConfig(value[i]);
    }
  }
});
```


