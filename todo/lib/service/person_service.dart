import '../route.dart';
import 'dart:io';
import '../utils/api.dart';
import 'package:path/path.dart' as path;
import '../utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../service/store.dart';

class PersonService {
  
  dynamic _imgRes;

  void update(BuildContext context,String nick, String desp, File image) async{
    if (nick==null || nick ==" ") {
      MyToast.info("请填写昵称");
      return;
    }
    
    if (desp==null || desp ==" ") {
      MyToast.info("请填写个人介绍");
      return;
    }
    String userId = await Manager.instance.readShared("userId");
    //修改头像
     if (image!=null) {
        String fileName = path.basename(image.path);
        FormData file = FormData.from({"file": UploadFileInfo(image,fileName)});
        try {
          _imgRes = await Api.getApi().postD('/up/upload', file);
          String imgUrl = _imgRes.data['url'];
          dynamic res = await Api.getApi().getD("/api/user/avatar/${userId}?avatar=${imgUrl}");
          if(res.data.containsKey("msg")){
           MyToast.info(res.data['msg']);
           return;
         }
          Manager.instance.addShared("avatar", imgUrl);
        } catch (e) {
          MyToast.info("头像上传失败");
          return;
        }
      }

      
      try {
        String old1 = await Manager.instance.readShared("nickName");
        String old2 = await Manager.instance.readShared("mydesp");

        //修改昵称
        if (old1 != nick) {
          dynamic res1 = await Api.getApi().getD("/api/user/nick/${userId}?nickName=${nick}");
         if(res1.data.containsKey("msg")){
           MyToast.info(res1.data['msg']);
           return;
         }
         Manager.instance.addShared("nickName", nick);
        }
      
      //修改个人介绍
       if (old2 != desp ) {
        dynamic res2 = await Api.getApi().getD("/api/user/desp/${userId}?desp=${desp}");
          if(res2.data.containsKey("msg")){
           MyToast.info(res2.data['msg']);
           return;
         }
         Manager.instance.addShared("mydesp", desp);
       }
         Routers.go(context, '/');
      } catch (e) {
        MyToast.info("个人信息修改失败");
        return;
      }
  }
}