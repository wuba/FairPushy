import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'api.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
];

/// 全局独立服务
List<SingleChildWidget> independentServices = [
  Provider(create: (_) => Api()),
];

/// 这里使用ProxyProvider来定义需要依赖其他Provider的服务
List<SingleChildWidget> dependentServices = [];
