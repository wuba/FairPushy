class AppListData {
  List<AppList>? appList;

  AppListData({this.appList});

  AppListData.fromJson(Map<String, dynamic> json) {
    if (json['appList'] != null) {
      appList = <AppList>[];
      json['appList'].forEach((v) {
        appList!.add(new AppList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appList != null) {
      data['appList'] = this.appList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppList {
  int? appId;
  String? appName;
  String? appInfo;
  String? appLogoUrl;
  String? appCreateTime;

  AppList(
      {this.appId,
        this.appName,
        this.appInfo,
        this.appLogoUrl,
        this.appCreateTime});

  AppList.fromJson(Map<String, dynamic> json) {
    appId = json['appId'];
    appName = json['appName'];
    appInfo = json['appInfo'];
    appLogoUrl = json['appLogoUrl'];
    appCreateTime = json['appCreateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appId'] = this.appId;
    data['appName'] = this.appName;
    data['appInfo'] = this.appInfo;
    data['appLogoUrl'] = this.appLogoUrl;
    data['appCreateTime'] = this.appCreateTime;
    return data;
  }
}
