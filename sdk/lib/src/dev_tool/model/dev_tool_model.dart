import 'package:fair_pushy/src/delegate.dart';
import 'package:fair_pushy/src/dev_tool/utils/sp_utils.dart';
import 'package:flutter/material.dart';

class DevToolMode extends InheritedWidget {
  static const String MODE_ONLINE = "线上模式";
  static const String MODE_LOCAL = "本地模式";

  ///选择的模式
  final ValueNotifier<String?> _selectMode = ValueNotifier(null);

  get selectMode => _selectMode;

  setSelectMode(value) {
    _selectMode.value = value;
    if (value != null) {
      SPUtils.recordLastSelectMode(value);
    }
    notifyParamsChanged();
  }

  ///选择的线上环境
  ValueNotifier<OnlineEnvInfo?> _selectOnlineEnv = ValueNotifier(null);

  get selectOnlineEnv => _selectOnlineEnv;

  setSelectOnlineEnv(value) {
    _selectOnlineEnv.value = value;
    if (value != null) {
      SPUtils.recordLastSelectEnv(value.envName);
    }
    notifyParamsChanged();
  }

  ///本地模式时的host
  final ValueNotifier<String?> _localModeHost = ValueNotifier(null);

  get localModeHost => _localModeHost;

  setLocalModeHost(value) {
    _localModeHost.value = value;
    notifyParamsChanged();
  }

  ///是否正在加载assets中
  bool _isLoadingFairAssets = false;

  ///参数变更通知
  ValueNotifier<SelectParamsInfo?> selectParamsNotifier = ValueNotifier(null);

  ///所有模式
  final List<String> modeList = const [MODE_ONLINE, MODE_LOCAL];

  ///环境列表，需要代码中配置
  Set<OnlineEnvInfo> envList = {};

  ///当前输入的bundleId
  final ValueNotifier<String?> _bundleId = ValueNotifier(null);

  get bundleId => _bundleId;

  set bundleId(value) {
    _bundleId.value = value;
    notifyParamsChanged();
  }

  DevToolMode({Key? key, required FairDevConfig? config, required Widget child})
      : super(key: key, child: child) {
    envList = config == null ? {} : config._envList;
    notifyParamsChanged();
    init();
  }

  void init() async {
    _selectMode.value = await SPUtils.getLastSelectMode();
    _localModeHost.value = await SPUtils.getLocalHost();
    notifyParamsChanged();
  }

  @override
  bool updateShouldNotify(covariant DevToolMode oldWidget) => false;

  static DevToolMode? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DevToolMode>();

  void clearCache() {
    //TODO
    notifyParamsChanged();
  }

  ///检测参数是否齐全
  void notifyParamsChanged({bool hasLoadedFairAssets = false}) {
    SelectParamsInfo selectParamsInfo;
    switch (_selectMode.value) {
      case MODE_ONLINE:
        if (_selectOnlineEnv.value == null) {
          selectParamsInfo = SelectParamsInfo(
              false, "从线上服务器加载", _isLoadingFairAssets, hasLoadedFairAssets);
        } else {
          final paramsCompleted =
              _selectOnlineEnv.value!.updateUrl?.isNotEmpty == true &&
                  bundleId.value?.isNotEmpty == true;
          selectParamsInfo = SelectParamsInfo(
              paramsCompleted,
              "从线上${_selectOnlineEnv.value!.envName}服务器加载",
              _isLoadingFairAssets,
              hasLoadedFairAssets);
        }
        break;
      case MODE_LOCAL:
        selectParamsInfo = SelectParamsInfo(
            _localModeHost.value?.isNotEmpty == true,
            "从本地服务器加载",
            _isLoadingFairAssets,
            hasLoadedFairAssets);
        break;
      default:
        selectParamsInfo = SelectParamsInfo(
            false, "未选择模式", _isLoadingFairAssets, hasLoadedFairAssets);
    }
    selectParamsNotifier.value = selectParamsInfo;
  }

  Future<Code> loadFairAssetsLocal(String host, {String? port}) async {
    _isLoadingFairAssets = true;
    notifyParamsChanged();
    final code = await Delegate.updateDebugFW(host, port: port);
    _isLoadingFairAssets = false;
    if (code == Code.success) {
      notifyParamsChanged(hasLoadedFairAssets: true);
    }
    return code;
  }

  Future<Code> loadFairAssetsOnline(String bundleId) async {
    _isLoadingFairAssets = true;
    notifyParamsChanged();
    final code = await Delegate.updateFW(bundleId: bundleId);
    _isLoadingFairAssets = false;
    if (code == Code.success) {
      notifyParamsChanged(hasLoadedFairAssets: true);
    }
    return code;
  }
}

/// 线上模式的环境实体
class OnlineEnvInfo {
  String envName;
  String? updateUrl;
  bool readOnly;

  OnlineEnvInfo({required this.envName, this.updateUrl, this.readOnly = false});
}

///Fair开发者配置项
class FairDevConfig {
  Set<OnlineEnvInfo> _envList = {};

  void addEnv(OnlineEnvInfo env) {
    _envList.add(env);
  }
}

///选择的参数信息
class SelectParamsInfo {
  bool completed;
  String loadFairText;
  bool isLoadingFairAssets;
  bool hasLoadedFairAssets;

  SelectParamsInfo(this.completed, this.loadFairText, this.isLoadingFairAssets,
      this.hasLoadedFairAssets) {
    if (hasLoadedFairAssets) {
      loadFairText = "已$loadFairText";
    }
  }
}

///一些参数的持久化保存
class PersistenceInfo {
  String? bundleId;
}
