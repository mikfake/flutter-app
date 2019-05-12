import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:/route.dart';
import '../service/task_service.dart';
import '../models/item_list.dart';


class My extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<My> with SingleTickerProviderStateMixin {
  List<Tab> _myTabs = <Tab>[
    Tab(
      text: '我参加的',
      icon: Icon(
        FontAwesomeIcons.calendarTimes,
        size: 15,
      ),
    ),
    Tab(
      text: '我创建的',
      icon: Icon(FontAwesomeIcons.calendarPlus, size: 15),
    ),
  ];
  ScrollController _scrollController = ScrollController(); //listview的控制器
  List<Item> _myInto;
  List<Item> _myCreate;
  TabController _mController;
  


  List<Widget> listTask(BuildContext context, String task) {
    List<Widget> list = List();
    if (task == '我创建的') {
      if(_myCreate!=null&&_myCreate.length>0){
         _myCreate.forEach((create){
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
                      Routers.go(context, 'detail?taskId=${create.taskId}');
                    },
                    child: Text(create.title,
                        style: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 18.0,
                            color: Colors.black)),
                  ),
                  leading: CircleAvatar(
                      backgroundImage:  create.avatar != null && create.avatar != " " ? 
                        NetworkImage(create.avatar) : AssetImage('assets/img/avatar.png')
                          ),
                ),
                SizedBox(
                  height: 130,
                  child: ListTile(
                    title: InkWell(
                      onTap: () {
                        Routers.go(context, 'detail?taskId=${create.taskId}');
                      },
                      child:
                          Image.network(create.img!=null ? create.img : 'assets/img/bt.png', fit: BoxFit.cover),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 15),
                    child: Text('参与数: ${create.joins} | 打卡数：${create.punch}',
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
      }
    } else {
      if(_myInto!=null&&_myInto.length>0){
         _myInto.forEach((into){
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
                      Routers.go(context, 'detail?taskId=${into.taskId}');
                    },
                    child: Text(into.title,
                        style: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 18.0,
                            color: Colors.black)),
                  ),
                  leading: CircleAvatar(
                     backgroundImage: into.avatar != null && into.avatar != " " ? 
                        NetworkImage(into.avatar) : AssetImage('assets/img/avatar.png')
                        ),
                ),
                SizedBox(
                  height: 130,
                  child: ListTile(
                    title: InkWell(
                      onTap: () {
                        Routers.go(context, 'detail?taskId=${into.taskId}');
                      },
                      child:
                          Image.network(into.img!=null ? into.img : 'assets/img/bt.png', fit: BoxFit.cover),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 15),
                    child: Text('参与数: ${into.joins} | 打卡数：${into.punch}',
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
      }
    }
    return list;
  }
  
  //获取数据
  setData() async{
    
   ItemList list1 = await TaskService().getMyInto(1);
   ItemList list2 = await TaskService().getMyCreate(1);
   setState(() {
      _myInto = list1.list;
      _myCreate = list2.list;
   });

  }
  

  @override
  void initState() {
    super.initState();
    setData();
    _mController = TabController(
      length: _myTabs.length,
      vsync: this,
    );
      _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
         print('滑动到了最底部');
         //加载下一页数据
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _mController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          height: 60.0,
          child: TabBar(
            controller: _mController,
            labelColor: Color(0xFFf7418c),
            indicatorColor: Color(0xFFf7418c),
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
                fontSize: 12.0,
                fontFamily: 'WorkSansBold',
                fontWeight: FontWeight.bold),
            tabs: _myTabs.map((item) {
              return item;
            }).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _mController,
            children: _myTabs.map((item) {
              return ListView(
                controller: _scrollController,
                children: listTask(context, item.text),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
