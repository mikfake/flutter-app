import 'package:dio/dio.dart';
import '../service/store.dart';
import 'package:flutter/material.dart';
import '../view/login_page.dart';

class Api {
  static String baseUrl = "https://www.easy-mock.com/mock/5cd7955575f03c3784d2bc7e/mike";
  static int connectTimeout = 10 * 1000;
  static int receiveTimeout = 10 * 1000;
  static Api api;
  static String token = '';
  static Dio _dio;
  static BaseOptions _options;

  static Api getApi() {
    if (api == null) {
      api = new Api();
    }
    return api;
  }

  static initDio() async {
    if (_dio == null) {
      _dio = new Dio(_options);
    }

    String f = await Manager.instance.readShared("token");
    print("设置token" + f);
    Api.token = f;
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      options.headers.addAll({"auth": token});
      return options;
    }, onError: (DioError e) {
      print("errrrrrrr" + e.toString());
      return e;
    }, onResponse: (Response res) {
      print("收到response：");
      if (res.statusCode == 200 && res.data['code'] == '00') {
        print(res.data);
        return res.data['data'];
      } else {
        if (res.data['msg'] == 'token error') {
          //清除缓存数据
          Manager.instance.removeShared("nickName");
          Manager.instance.removeShared("userId");
          Manager.instance.removeShared("avatar");
          Manager.instance.removeShared("code");
          Manager.instance.removeShared("money");
          Manager.instance.removeShared("mydesp");
          Manager.instance.removeShared("token");
          Manager.instance.removeShared("loginName");
          //跳转到了页面
          runApp(new MaterialApp(
            theme: ThemeData(
                brightness: Brightness.light,
                primarySwatch: Colors.red,
                primaryColor: Color(0xFFf7418c),
                iconTheme: IconThemeData(color: Color(0xFFf7418c))),
            home: Login(),
          ));
        }
        return {"msg": res.data['msg']};
      }
    }));
  }

  Api() {
    // 初始化 Options
    _options = new BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        headers: {});
  }

  getD(url) async {
    await initDio();
    Response response;
    print("开始请求");
    response = await _dio.get(url);
    print(response);
    return response;
  }

  postD(url, data) async {
    await initDio();
    print(data);
    Response response;
    response = await _dio.post(url, data: data);
    print("wodeshuju");
    print(response);
    return response;
  }
}
