import 'package:flutter/material.dart';
import 'package:/route.dart';
import '../utils/api.dart';
import '../utils/toast.dart';
import '../models/auth_data.dart';
import './store.dart';


class LoginService {
  dynamic result;

  void onLogin(BuildContext context, TextEditingController email,
      TextEditingController password) async {
    String e = email.text;
    String p = password.text;
    RegExp reg = RegExp(r"^[A-Za-z\d]+([-_.][A-Za-z\d]+)*@([A-Za-z\d]+[-.])+[A-Za-z\d]{2,4}$");
    if (e == "") {
      MyToast.info("请输入邮箱地址");
      return;
    } else if (!reg.hasMatch(e)) {
        MyToast.info("邮箱格式不正确");
        return;
    }
    
    if (p == "") {
      MyToast.info("请输入密码");
      return;
    } 

    try {
      result =await Api.getApi().postD("/auth/login", {"loginName":e,"password":p});
      print(result.data.containsKey("msg"));
      if (result.data.containsKey("msg")) {
         MyToast.info(result.data['msg']);
      } else {
         MyToast.info("登陆成功");
         AuthData auth = AuthData(result.data);
         //设置请求token
        // Api.token = auth.tooken;
        //缓存登陆用户数据
         Manager.instance.addShared("nickName", auth.user.nickName);
         Manager.instance.addShared("userId", auth.user.id);
         Manager.instance.addShared("avatar", auth.user.img);
         Manager.instance.addShared("code", auth.user.code);
         Manager.instance.addShared("money", auth.user.money);
         Manager.instance.addShared("mydesp", auth.user.desp);
         Manager.instance.addShared("token", auth.tooken);
         Manager.instance.addShared("loginName", auth.user.loginName);
         Routers.go(context, '/');
      }
    } catch (e) {
      print(e.toString());
      MyToast.info("登陆失败");
    }

  }

    void onRegin(PageController pageController, TextEditingController email,
      TextEditingController password,TextEditingController confirmPasseord) async {
    String e = email.text;
    String p = password.text;
    String cp = confirmPasseord.text;

    RegExp reg = RegExp(r"^[A-Za-z\d]+([-_.][A-Za-z\d]+)*@([A-Za-z\d]+[-.])+[A-Za-z\d]{2,4}$");
    if (e == "") {
      MyToast.info("请输入邮箱地址");
      return;
    } else if (!reg.hasMatch(e)) {
        MyToast.info("邮箱格式不正确");
        return;
    }
    
    if (p == "") {
      MyToast.info("请输入密码");
      return;
    } else if (p.length<8) {
       MyToast.info("密码长度必须大于8");
      return;
    }

    if (cp=="") {
       MyToast.info("请输入确认密码");
       return;
    } else if (p!=cp){
       MyToast.info("两次输入密码不一致");
       return;
    }

    try {
      result =await Api.getApi().postD("/auth/regin", {"loginName":e,"password":p});
     if (result.data.containsKey("msg")) {
        MyToast.info(result.data['msg']);
     } else{
        pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
        email.clear();
        password.clear();
        confirmPasseord.clear();
        MyToast.info("注册成功");
     }
      
    } catch (e) {
      MyToast.info("注册失败");
    }

  }
  }

