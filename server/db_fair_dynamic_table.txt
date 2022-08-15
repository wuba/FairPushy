CREATE TABLE `app_info` (
  `app_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `app_name` varchar(45) DEFAULT NULL COMMENT '项目名字',
  `app_key` varchar(45) DEFAULT NULL COMMENT '项目唯一标识',
  `app_description` varchar(300) DEFAULT NULL COMMENT '项目描述',
  `app_pic_url` varchar(300) DEFAULT NULL COMMENT '项目图片',
  `user_member` varchar(255) DEFAULT NULL COMMENT '项目成员',
  `patch_list` varchar(255) DEFAULT NULL COMMENT '补丁列表',
  `version_name` varchar(20) DEFAULT NULL COMMENT '版本名字',
  `remark` varchar(300) DEFAULT NULL COMMENT '版本备注',
  `create_name` varchar(45) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`app_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COMMENT='app项目信息';

CREATE TABLE `online_build` (
  `buildId` int(11) NOT NULL AUTO_INCREMENT COMMENT '在线构建任务id',
  `patchGitUrl` varchar(300) DEFAULT NULL COMMENT '补丁项目git地址',
  `patchGitBranch` varchar(45) DEFAULT NULL COMMENT '补丁项目git分支',
  `patchBuildName` varchar(300) DEFAULT NULL COMMENT '补丁项目构建成功后压缩包名称',
  `flutterVersion` varchar(45) DEFAULT NULL COMMENT '构建项目时使用的flutter版本',
  `buildStatus` int(11) NOT NULL COMMENT '在线构建任务状态 0：成功 1：失败 2：构建中',
  `patchWosUrl` varchar(300) DEFAULT NULL COMMENT '在线构建任务成功后，资源上传到wos后生成的地址 默认为空传，buildStatus为0时该值有效',
  `errorLogUrl` varchar(300) DEFAULT NULL COMMENT '在线构建任务失败的日志 默认为空传，buildStatus为1时该值有效',
  `buildStartTime` datetime DEFAULT NULL COMMENT '构建任务开始时间',
  `buildFinishTime` datetime DEFAULT NULL COMMENT '构建任务结束时间',
  PRIMARY KEY (`buildId`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8 COMMENT='在线构建';

CREATE TABLE `operation_record` (
  `record_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `operation_time` datetime DEFAULT NULL COMMENT '操作时间',
  `operator` varchar(45) DEFAULT NULL COMMENT '操作者',
  `operatio_content` varchar(255) DEFAULT NULL COMMENT '操作内容',
  `app_key` varchar(100) DEFAULT NULL COMMENT 'app唯一表',
  `version_name` varchar(100) DEFAULT NULL COMMENT 'app版本',
  PRIMARY KEY (`record_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='操作记录';

CREATE TABLE `patch_info` (
  `bundle_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '补丁id',
  `app_id` varchar(255) DEFAULT NULL COMMENT '项目id',
  `patch_url` varchar(300) NOT NULL COMMENT '补丁地址url',
  `status` varchar(10) DEFAULT NULL COMMENT '补丁状态：1下发中，2回滚',
  `remark` varchar(255) DEFAULT NULL COMMENT '补丁备注',
  `bundle_version` varchar(20) DEFAULT NULL COMMENT '版本名字',
  `version_code` varchar(20) DEFAULT NULL COMMENT '版本号',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `bundle_name` varchar(20) NOT NULL DEFAULT '' COMMENT '补丁名字',
  `patchGitUrl` varchar(300) DEFAULT NULL COMMENT '补丁项目git地址',
  `patchGitBranch` varchar(45) DEFAULT NULL COMMENT '补丁项目git分支',
  `flutterVersion` varchar(45) DEFAULT NULL COMMENT '构建项目时使用的flutter版本',
  PRIMARY KEY (`bundle_id`)
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8 COMMENT='补丁信息';