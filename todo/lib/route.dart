import 'package:fluro/fluro.dart';
import 'package:/view/login_page.dart';
import 'package:/view/home_page.dart';
import 'package:/view/task_detail.dart';
import 'package:/view/daka_page.dart';
import 'package:flutter/material.dart';
import 'view/public_page.dart';
import 'view/person_page.dart';

class Routers {
  static Router router;
  static void configRouters(Router router){
      router.define('/login',handler: Handler(handlerFunc: (context, params) => Login()));
      router.define('/',handler: Handler(handlerFunc: (context, params) => Home()));
      router.define('/detail',handler: Handler(handlerFunc: (context, params) {
        return TaskDetail(params['taskId']?.first);})
        );
      router.define('/daka',handler: Handler(handlerFunc: (context, params) => DaKa(params['taskId']?.first)));
      router.define('/public',handler: Handler(handlerFunc: (context, params) => Public()));
      router.define('/person',handler: Handler(handlerFunc: (context, params) => Person()));
      Routers.router =router;
  }

  static void go(BuildContext context,String url){
      Routers.router.navigateTo(
        context, url,//跳转路径
        transition: TransitionType.inFromRight
    ).then((result) {//回传值
      if (result != null) {
        
      }
    });

  }
}