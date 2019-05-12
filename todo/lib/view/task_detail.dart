import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../route.dart';
import '../service/task_service.dart';
import '../models/task_detail.dart';
import '../models/today_punch.dart';
import '../service/punch_service.dart';
import '../blocs/load.dart';
import '../utils/toast.dart';

class TaskDetail extends StatefulWidget {
  final String taskId;
  TaskDetail(this.taskId);

  @override
  _State createState() => _State(taskId);
}

class _State extends State<TaskDetail> {
  
   final String taskId;
   _State(this.taskId);
   Detail _detail;
   List<Punch> _list;
   int _page=1;
   ScrollController _scrollController = ScrollController(); //listview的控制器
   bool _loding = false;
   bool _can = false;

   @override
   void initState() { 
     super.initState();
     setDetail();
     _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
         print('滑动到了最底部');
        _getMore();
      }
    });
   }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

   
   //加载下一页数据
   _getMore() async{
      setState(() {
         _loding = true;
       });
     TodayPunch p =  await PunchService().getTodayPunch(_page+1, taskId);
     await Future.delayed(Duration(seconds: 2));
     if(p==null || p.list==null||p.list.length==0){
       setState(() {
         _loding = false;
       });
     }else{
       setState(() {
       _page = _page+1;
       _list.addAll(p.list);
       _loding = false;
   });
     }
   }


  //获取数据
    setDetail() async{
     Detail detail = await TaskService().getDetail(taskId);
     TodayPunch p = await PunchService().getTodayPunch(_page, taskId);
     bool can = await TaskService().canInto(taskId);
     print(can);
     setState(() {
       _detail =detail;
       _list = p.list;
       _can = can;
     });
     
    }
  
  //打卡记录列表
  List<Widget> getRecords () {
    List<Widget> recordList = List();
    if (_list!=null&&_list.length>0){
        recordList.add(Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('今日打卡:'+_list[0].total+'人',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'WorkSansBold',
                        fontWeight: FontWeight.bold)),
                Divider(),
              ],
            ),
          ),);
        _list.forEach((p){
           recordList.add(
              Card(
          color: Colors.white,
          margin: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text(p.userName,
                    style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 18.0,
                        color: Colors.black)),
                subtitle: Text("已经打卡"+p.puchDays+"天",
                    style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 14.0,
                        color: Colors.black38)),
                leading: CircleAvatar(
                    backgroundImage: p.avatar != null && p.avatar != " " ? 
                        NetworkImage(p.avatar) : AssetImage('assets/img/avatar.png')
                        ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: (MediaQuery.of(context).size.width-24)/4,
                  child: Text(p.time,textAlign: TextAlign.center,style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold)),),
                  SizedBox(width: (MediaQuery.of(context).size.width-24)/4,
                  child: Text(p.puchDays+"天",textAlign: TextAlign.center,style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold)),),
                  SizedBox(width: (MediaQuery.of(context).size.width-24)/4,
                  child: Text(p.missDays+"天",textAlign: TextAlign.center,style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold)),),
                  SizedBox(width: (MediaQuery.of(context).size.width-24)/4,
                  child: Text(p.rate,textAlign: TextAlign.center,style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold)),),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    SizedBox(width: (MediaQuery.of(context).size.width-24)/4,
                  child: Text('打卡时间',textAlign: TextAlign.center,style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 14.0,
                        color: Colors.black38)),),
                  SizedBox(width: (MediaQuery.of(context).size.width-24)/4,
                  child: Text('打卡数',textAlign: TextAlign.center,style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 14.0,
                        color: Colors.black38)),),
                  SizedBox(width: (MediaQuery.of(context).size.width-24)/4,
                  child: Text('漏打数',textAlign: TextAlign.center,style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 14.0,
                        color: Colors.black38)),),
                  SizedBox(width: (MediaQuery.of(context).size.width-24)/4,
                  child: Text('执行率',textAlign: TextAlign.center,style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 14.0,
                        color: Colors.black38)),),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10),      
              ),
            ],
          ),
        )
           );
        });
    }else{
      recordList.add(Padding(padding: EdgeInsets.all(1),));
    }

    if(_loding){
       recordList.add(Loading().getMoreWidget());
    }
    return recordList;
  }
  
  //加入
  intoTask(BuildContext context) async{
    bool ins = await TaskService().into(taskId);
    if(ins){
       MyToast.info('参加成功');
       Routers.go(context, 'daka?taskId=${taskId}');
    }
  }

  //创建参加按钮
  Widget buildButton(BuildContext context){
    if (_can) {
      return  Padding(
            padding: EdgeInsets.only(left: 50, right: 50),
            child: FlatButton(
              child: Text('马上参加'),
              shape: const Border(),
              color: Colors.greenAccent[400],
              textColor: Colors.white,
              onPressed: () {
                //click callback
                //Routers.go(context, 'daka');
                intoTask(context);
              },
            ),
          );
    }else {
      return  Padding(
            padding: EdgeInsets.only(left: 50, right: 50),
            child: FlatButton(
              child: Text('马上去打卡'),
              shape: const Border(),
              color: Colors.blueAccent[400],
              textColor: Colors.white,
              onPressed: () {
                //click callback
                Routers.go(context, 'daka?taskId=${taskId}');
              },
            ),
          );
    }
     
  }


  @override
  Widget build(BuildContext context) {
    if(_detail !=null){
       return Scaffold(
      appBar: AppBar(
        title: Text('详情'),
      ),
      body: ListView(
        controller: _scrollController,
        children: <Widget>[
          ListTile(
            title: Text(_detail.title,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'WorkSansBold',
                    fontWeight: FontWeight.bold)),
            leading: Icon(
              Icons.bookmark,
              color: Colors.greenAccent[400],
              size: 25,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Image.network(_detail.img!='' ? _detail.img : 'assets/img/bt.png', fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.clock,
                  size: 16,
                ),
                Text('打卡时间',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'WorkSansBold',
                        color: Colors.black26)),
                SizedBox(
                  width: 20,
                ),
                Text(_detail.timeRange,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'WorkSansBold',
                    )),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.user,
                  size: 16,
                ),
                Text('参与人数',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'WorkSansBold',
                        color: Colors.black26)),
                SizedBox(
                  width: 20,
                ),
                Text(_detail.joins,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'WorkSansBold',
                    )),
              ],
            ),
          ),
          buildButton(context),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('目标',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'WorkSansBold',
                        fontWeight: FontWeight.bold)),
                Divider(),
                Text(
                    _detail.desp,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.2,
                      fontFamily: 'WorkSansBold',
                    )),
              ],
            ),
          ),
          Column(children: getRecords(),)
        ],
      ),
    );
    } else {
      return(Padding(padding: EdgeInsets.all(1),));
    }
    
  }
}
