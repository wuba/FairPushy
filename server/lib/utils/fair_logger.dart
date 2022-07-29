import 'dart:io';

import 'package:logging/logging.dart';

/*
* log日志不打印内容黑名单
* 用途：主要用于规避第三方库里写好的日志输出，以及日志持久化存储
* 规则：黑名单数组中的内容相关的日志不会在终端输出
* 规则：黑名单数组中的内容相关的日志不会持久化保存到本地文件中
* */
//
const blackLogList = ["releaseExcess called"];

/**
 * 初始化log库
 *
 *只记录等级大于等于info的信息
 *
 * /opt/log为服务器路径
 * log为当前项目下的路径
 */
void LoggerInit() async {
  Directory? logDirectory = null;
  try {
    logDirectory = await new Directory('/opt/log').create(recursive: true);
  } catch (e) {
    try {
      logDirectory = await new Directory('log').create(recursive: true);
    } catch (e) {}
  }
  File? file = null;
  if (logDirectory != null) {
    try {
      file = await new File('${logDirectory.path}/fair_dynamic_server.log');
    } catch (e) {}
  }

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    if (blackLogList.contains(rec.message)) {
      //黑名单不做处理
      return;
    }

    String log =
        '${rec.sequenceNumber}::${rec.level}::${rec.time}::${rec.message}';
    if (rec.error != null) {
      log += '\n::${rec.error}';
    }
    if (rec.stackTrace != null) {
      log += '\n::${rec.stackTrace.toString()}';
    }

    print(log);
    //只记录等级大于等于info的信息
    if (rec.level.value >= Level.INFO.value && file != null) {
      writeLog(log, file);
    }
  });
}

/**
 * 在文件中写入log信息
 */
void writeLog(String log, File file) async {
  /*
  * /opt/log/fair_dynamic_server.log 为云平台日志备份文件路径
  * */
  await file.exists().then((isExists) {
    file.writeAsStringSync(isExists ? '\n\n$log' : log, mode: FileMode.append);
  });
}
