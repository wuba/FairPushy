class ResListData {
  List<ResListItemData>? resList;

  ResListData({this.resList});

  ResListData.fromJson(Map<String, dynamic> json) {
    if (json['bundleList'] != null) {
      resList = <ResListItemData>[];
      var dataList = json['bundleList'];

      dataList.forEach((v) {
        print(v);
        resList!.add(ResListItemData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (resList != null) {
      data['bundleList'] = resList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResListItemData {
  String? app_id;
  int? bundle_id;
  String? patch_url;
  String? status;
  String? remark;
  String? bundle_name;
  String? bundle_version;
  String? update_time;
  String? patchGitUrl;
  String? patchGitBranch;
  String? flutterVersion;


  ResListItemData({
    this.app_id,
    this.bundle_id,
    this.patch_url,
    this.status,
    this.remark,
    this.bundle_name,
    this.bundle_version,
    this.update_time,
    this.patchGitUrl,
    this.patchGitBranch,
    this.flutterVersion,
  });

  ResListItemData.fromJson(Map<String, dynamic> json) {
    app_id = json['appId'];
    bundle_id = json['bundleId'];
    patch_url = json['patchUrl'];
    status = json['status'];
    remark = json['remark'];
    bundle_name = json['bundleName'];
    bundle_version = json['bundleVersion'];
    update_time = json['updateTime'];
    patchGitUrl = json['patchGitUrl'];
    patchGitBranch = json['patchGitBranch'];
    flutterVersion = json['flutterVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app_id'] = app_id;
    data['bundle_id'] = bundle_id;
    data['patch_url'] = patch_url;
    data['status'] = status;
    data['remark'] = remark;
    data['bundle_name'] = bundle_name;
    data['bundle_version'] = bundle_version;
    data['update_time'] = update_time;
    data['patchGitUrl'] = patchGitUrl;
    data['patchGitBranch'] = patchGitBranch;
    data['flutterVersion'] = flutterVersion;
    return data;
  }
}
