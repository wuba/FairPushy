import 'package:dio/dio.dart';

class FairInterceptorsWrapper {

  static List<Interceptor> list = List.empty(growable: true);

  static Iterable<Interceptor> addInterceptor({required Interceptor interceptor}) {
    list.add(interceptor);
    return list;
  }

}