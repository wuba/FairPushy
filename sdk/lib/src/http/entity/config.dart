class Config {
  String? id;
  String? patchUrl;
  String? bundleVersion;
  String? bundleId;
  String? bundleName;
  String? status;
  String? remark;
  String? updateTime;

  Config(
      {this.patchUrl,
      this.bundleVersion,
      this.id,
      this.bundleId,
      this.bundleName,
      this.remark,
      this.status,
      this.updateTime});

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      patchUrl: json['patchUrl'],
      bundleVersion: json['bundleVersion'],
      id: json['_id'].toString(),
      bundleId: json['bundleId'].toString(),
      bundleName: json['bundleName'],
      status: json['status'].toString(),
      remark: json['remark'],
      updateTime: json['updateTime'],
    );
  }
}
