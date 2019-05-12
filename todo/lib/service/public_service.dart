
import 'package:flutter/material.dart';
import 'package:/route.dart';
import '../utils/api.dart';
import 'dart:io';
import '../utils/toast.dart';
import './store.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

class PublicService {
  dynamic _imgRes;
  dynamic _tasRes;

  void onSubmit(BuildContext context, TextEditingController title,
      TextEditingController desp,File image,String timeRange) async{
      String t = title.text;
      String d = desp.text;
      print(timeRange);
      if (t=='') {
         MyToast.info('请输入目标标题');
         return;
      }

      if (d=='') {
         MyToast.info('请输入目标描述');
         return;
      }
      if (timeRange!='全天') {
        print(timeRange);
        List list= timeRange.split('-');
        List satrt = list[0].split(':');
        List end = list[1].split(':');
        if (list[0]==list[1]){
           MyToast.info('打卡开始时间不能等于结束时间');
           return;
        }
        if (int.parse(satrt[0])>int.parse(end[0])) {
           MyToast.info('打卡开始时间不能大于结束时间');
           return;
        }  
        
        if(int.parse(satrt[0])==int.parse(end[0])&&int.parse(satrt[1])>int.parse(end[1])){
           MyToast.info('打卡开始时间不能大于结束时间');
           return;
        }
        
      }
      

      if (image!=null) {
        String fileName = path.basename(image.path);
        FormData file = FormData.from({"file": UploadFileInfo(image,fileName)});
        try {
          _imgRes = await Api.getApi().postD('/up/upload', file);
        } catch (e) {
          MyToast.info("图片上传失败");
          return;
        }
      }

      try {
        String userId = await Manager.instance.readShared('userId');
        _tasRes = await Api.getApi().postD('/api/task/add', {"user":{"id":userId},"title":t,"desp":d,"img":_imgRes!=null?_imgRes.data['url']:'',"timeRange":timeRange});
        if(_tasRes.data.containsKey("msg")){
           MyToast.info(_tasRes.data['msg']);
        }else{
           Routers.go(context, '/');
        }
      } catch (e) {
        MyToast.info("发布目标失败");
        return;
      }

  }
}