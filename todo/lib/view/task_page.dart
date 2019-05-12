import 'package:flutter/material.dart';
import 'package:/route.dart';
import '../service/task_service.dart';
import '../models/task_list.dart';
import '../blocs/load.dart';

class Tasks extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Tasks> {
  String _sort = 'createTime+';
  int _page = 1;
  List<Task> _list;
  ScrollController _scrollController = ScrollController(); //listview的控制器
  bool _loding = false;
  bool _more = true;

  @override
  void initState() {
    _getData();
    super.initState();
    _scrollController.addListener(() {

      if (
        _scrollController.position.maxScrollExtent==_scrollController.position.pixels) {
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

  Future<Null> _getMore() async {
    //加载新的一页数据
    if (_more) {
      setState(() {
      _loding = true;
      });
      TaskList s = await TaskService().getTaskList(_sort, _page + 1);
      await Future.delayed(Duration(seconds: 2));
      if (s == null || s.list == null || s.list.length == 0) {
        setState(() {
           _more = false;
          _loding = false;
        });
      } else {
        setState(() {
          _more = true;
          _page = _page + 1;
          _list.addAll(s.list);
          _loding = false;
        });
      }
      print("--------");
      print(_page);
    }
  }

  Future<Null> _getData() async {
    //获取最新数据
    TaskList s = await TaskService().getTaskList(_sort, 1);
    setState(() {
      _more = true;
      _page = 1;
      _list = s.list;
    });
  }

  List<Widget> listTask(BuildContext context) {
    List<Widget> list = List();
    if (_list != null && _list.length > 0) {
      _list.forEach((v) {
        list.add(SizedBox(
            height: 250,
            child: Card(
              color: Colors.white,
              margin: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: InkWell(
                      onTap: () {
                        Routers.go(context, 'detail?taskId=${v.taskId}');
                      },
                      child: Text(v.title,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 18.0,
                              color: Colors.black)),
                    ),
                    leading: CircleAvatar(
                        backgroundImage: v.avatar != null && v.avatar != " " ? 
                        NetworkImage(v.avatar) : AssetImage('assets/img/avatar.png')
                        ),
                  ),
                  SizedBox(
                    height: 130,
                    child: ListTile(
                      title: InkWell(
                        onTap: () {
                          Routers.go(context, 'detail?taskId=${v.taskId}');
                        },
                        child: Image.network(
                            v.img != null ? v.img : 'assets/img/bt.png',
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10, left: 15),
                      child: Text('参与数: ${v.joins} | 打卡数：${v.punch}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 14.0,
                              height: 1.1,
                              color: Colors.black26))),
                ],
              ),
            )));
      });
    } else {
      //没有数据
      list.add(Padding(
        padding: EdgeInsets.all(1),
      ));
    }

    if (_loding) {
      list.add(Loading().getMoreWidget());
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _getData,
        child: ListView(
          children: listTask(context),
          controller: _scrollController,
        ));

    // return ListView(
    //   children: listTask(context)
    // );
  }
}
