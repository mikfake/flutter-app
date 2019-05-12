import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../route.dart';
import '../service/task_service.dart';
import '../models/task_detail.dart';
import '../models/my_punch.dart';

class DaKa extends StatefulWidget {
  final String taskId;
  DaKa(this.taskId);

  @override
  _State createState() => _State(taskId);
}

class _State extends State<DaKa> {
  final String taskId;
  _State(this.taskId);
  Detail _detail;
  bool _can = false;
  List<Record> _list;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    setDetail();
  }

  //获取数据
  setDetail() async {
    Detail detail = await TaskService().getDetail(taskId);
    bool can = await TaskService().canPunch(taskId);
    MyRecord myRecord = await TaskService().getMyPunchList(taskId, _page);
    setState(() {
      _detail = detail;
      _can = can;
      _list = myRecord.list;
    });
  }
  
  //打卡
  punch(BuildContext context) async{
    await TaskService().createPunch(taskId);
    bool can = await TaskService().canPunch(taskId);
    MyRecord myRecord = await TaskService().getMyPunchList(taskId, _page);
    setState(() {
      _can = can;
      _list = myRecord.list;
    });
    
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
        ),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Image.network(
                      _detail != null && _detail.img != null ? _detail.img : "",
                      fit: BoxFit.cover),
                ),
                Card(
                    elevation: 1,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          buildGreetingsText(context),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  text: '今天是 \n',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      height: 1.6),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: DateFormat('yyyy年MM月dd日')
                                            .format(DateTime.now()),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              buidTodayStatus(context),
                            ],
                          )
                        ],
                      ),
                    )),
                Text(
                  '我的打卡记录：',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      decoration: TextDecoration.none),
                ),
                Divider(),
                Card(
                    child: Column(
                    children: buildRecord(),
                ))
              ],
            )
          ],
        ));
  }

  buildRecord() {
    List<Widget> list = List();

    if (_list != null && _list.length > 0) {
      _list.forEach((r) {
        list.add(ListTile(
            title: Text(r.time),
            leading: Icon(
              Icons.alarm_on,
              size: 30,
              color: Colors.green,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.attach_money,
                      size: 30,
                      color: Colors.yellow,
                    ),
                    Text('+' + r.code.toString(),
                        style: TextStyle(
                            color: Colors.red[300],
                            fontSize: 20,
                            fontWeight: FontWeight.bold))
                  ],
                )
              ],
            )));
        list.add(Divider());
      });
    } else {
      list.add(Padding(
        padding: EdgeInsets.all(1),
      ));
    }
    return list;
  }


  buidTodayStatus(BuildContext context) {
    if (_can) {
      return FlatButton(
        onPressed: () {
          punch(context);
        },
        color: Colors.deepOrange,
        textColor: Colors.white,
        child: Text(
          '打卡',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20)),
      );
    } else {
      return (Icon(
        Icons.watch_later,
        size: 50,
        color: Colors.redAccent,
      ));
    }
  }

  buildGreetingsText(context) {
    String greetings;

    String time = DateFormat('HH').format(DateTime.now());
    int intTime = int.parse(time);

    if (intTime > 19) {
      greetings = '晚上好';
    } else if (intTime > 14) {
      greetings = '下午好';
    } else if (intTime > 12) {
      greetings = '中午好';
    } else {
      greetings = '早上好';
    }

    return RichText(
      text: TextSpan(
        text: '$greetings ',
        style: TextStyle(fontSize: 16, color: Colors.black38, height: 1.6),
        children: <TextSpan>[
          TextSpan(text: '', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
