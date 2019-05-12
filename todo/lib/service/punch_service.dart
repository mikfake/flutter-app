import '../utils/api.dart';
import '../models/today_punch.dart';
import '../utils/toast.dart';

class PunchService{

   int pageSize =5;
   getTodayPunch(int page,String taskId) async{
     try {
      dynamic res = await Api.getApi().getD('/api/view/punch/${pageSize}/${page}/${taskId}');
      if (res.data is Map && res.data.containsKey("msg")){
         MyToast.info(res.data['msg']);
      } else {
        return TodayPunch(res.data);
      }
    } catch (e) {
      print(e);
      MyToast.info('加载数据出错');
    }
   }
}