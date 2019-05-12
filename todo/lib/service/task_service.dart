
import '../utils/api.dart';
import '../utils/toast.dart';
import '../models/task_list.dart';
import '../models/task_detail.dart';
import '../service/store.dart';
import '../models/item_list.dart';
import '../models/my_punch.dart';

class TaskService{
  int pageSize= 4;


  getTaskList(String sort,int page) async{
    try {
      dynamic res = await Api.getApi().getD('/auth/page/${pageSize}/${page}/${sort}');
      if (res.data is Map && res.data.containsKey("msg")){
         MyToast.info(res.data['msg']);
      } else {
        return TaskList(res.data);
      }
    } catch (e) {
      print(e);
      MyToast.info('加载数据出错');
    }
      
  }

  getDetail(String taskId) async{
      try {
      dynamic res = await Api.getApi().getD('/api/task/find/$taskId');
      if (res.data is Map && res.data.containsKey("msg")){
         MyToast.info(res.data['msg']);
      } else {
        return Detail(res.data);
      }
    } catch (e) {
      print(e);
      MyToast.info('加载数据出错');
    }
  }
  
  //不做分页  下拉加载总是不完美
  getMyInto(int page) async{
     try {

      String userId = await Manager.instance.readShared('userId');
      dynamic res = await Api.getApi().getD('/api/view/my-into/${userId}/500/${page}');
      if (res.data is Map && res.data.containsKey("msg")){
         MyToast.info(res.data['msg']);
      } else {
        return ItemList(res.data);
      }
    } catch (e) {
      print(e);
      MyToast.info('加载数据出错');
    }
  }
  
  //不做分页 下拉加载总是不完美
  getMyCreate(int page) async {
      try {
      String userId = await Manager.instance.readShared('userId');
      dynamic res = await Api.getApi().getD('/api/view/my-create/${userId}/500/${page}');
      if (res.data is Map && res.data.containsKey("msg")){
         MyToast.info(res.data['msg']);
      } else {
        return ItemList(res.data);
      }
    } catch (e) {
      print(e);
      MyToast.info('加载数据出错');
    }
  }

  canInto(String taskId) async {
      try {
      String userId = await Manager.instance.readShared('userId');
      dynamic res = await Api.getApi().getD('/api/task/enable/${taskId}/${userId}');
      if (res.data is Map && res.data.containsKey("msg")){
         return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e);
      MyToast.info('后台数据出错');
    }
  }

  into(String taskId) async {
      try {
      String userId = await Manager.instance.readShared('userId');
      dynamic res = await Api.getApi().getD('/api/task/into/${taskId}/${userId}');
      if (res.data is Map && res.data.containsKey("msg")){
        MyToast.info(res.data['msg']);
         return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e);
      MyToast.info('后台数据出错');
    }
  }

canPunch(String taskId) async {
      try {
      String userId = await Manager.instance.readShared('userId');
      dynamic res = await Api.getApi().getD('/api/task/enablePunch/${taskId}/${userId}');
      if (res.data is Map && res.data.containsKey("msg")){
         return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e);
      MyToast.info('后台数据出错');
    }
  }

  createPunch(String taskId) async {
      try {
      String userId = await Manager.instance.readShared('userId');
      dynamic res = await Api.getApi().getD('/api/task//record/${taskId}/${userId}');
      if (res.data is Map && res.data.containsKey("msg")){
         MyToast.info(res.data['msg']);
         return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e);
      MyToast.info('后台数据出错');
    }
  }


  getMyPunchList(String taskId,int page) async {
      try {
      String userId = await Manager.instance.readShared('userId');
      dynamic res = await Api.getApi().getD('/api/view/my-puch/${userId}/${taskId}/120/${page}');
      if (res.data is Map && res.data.containsKey("msg")){
         MyToast.info(res.data['msg']);
      } else {
        return MyRecord(res.data);
      }
    } catch (e) {
      print(e);
      MyToast.info('后台数据出错');
    }
  }
}