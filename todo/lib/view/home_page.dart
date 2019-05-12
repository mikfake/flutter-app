import 'package:flutter/material.dart';
import 'package:/route.dart';
import 'package:/view/task_page.dart';
import 'package:/view/my_page.dart';
import '../service/store.dart';
import '../utils/toast.dart';
import './login_page.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  List<Widget> _pages = [Tasks(), My()];
  List _header = ['首页', '我的'];
  String _userId;

  getDta() async {
    String userId = await Manager.instance.readShared('userId');
    setState(() {
      _userId = userId;
    });
  }

  @override
  void initState() {
    super.initState();
    getDta();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_header[_selectedIndex]),
        actions: <Widget>[
          //导航栏右侧菜单
        ],
      ),
      drawer: PersonDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.alarm), title: Text('目标营')),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('我的')),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        fixedColor: Color(0xFFf7418c),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: () => _onPublic(context)),
      body: buildBody(),
    );
  }

  Widget buildBody() {
      return _pages[_selectedIndex];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onPublic(BuildContext context) {
    if (_userId != null && _userId != ' ') {
      Routers.go(context, "public");
    } else {
      MyToast.info("您还没有登陆，请先登陆");
      Routers.go(context, "login");
    }
  }
}

class PersonDrawer extends StatefulWidget {
  @override
  _PersonState createState() => _PersonState();
}

class _PersonState extends State<PersonDrawer> {
  String _userId;
  String _nickName;
  String _mydesp;
  String _avatar;
  String _email;

  getDta() async {
    String nickName = await Manager.instance.readShared('nickName');
    String mydesp = await Manager.instance.readShared('mydesp');
    String avatar = await Manager.instance.readShared('avatar');
    String loginName = await Manager.instance.readShared('loginName');
    String userId = await Manager.instance.readShared('userId');
    setState(() {
      _nickName = nickName;
      _mydesp = mydesp;
      _avatar = avatar;
      _email = loginName;
      _userId = userId;
    });
  }

  void logOut(BuildContext context) {
    if (_userId!=null && _userId!=" ") {
       Manager.instance.removeShared("nickName");
    Manager.instance.removeShared("userId");
    Manager.instance.removeShared("avatar");
    Manager.instance.removeShared("code");
    Manager.instance.removeShared("money");
    Manager.instance.removeShared("mydesp");
    Manager.instance.removeShared("token");
    Manager.instance.removeShared("loginName");
     Routers.go(context, "/");
    } else {
      Routers.go(context, "/login");
    }
    
  }

  @override
  void initState() {
    super.initState();
    getDta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFf7418c),
      child: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(_nickName != null && _nickName!=" "? _nickName : "请登陆",
                style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(_mydesp != null && _mydesp!=" "? _mydesp : " "),
            currentAccountPicture: InkWell(
              child: CircleAvatar(
                backgroundImage: _avatar != null && _avatar!=" " ?
                 NetworkImage(_avatar) : AssetImage('assets/img/avatar.png')
            ),
            onTap: (){
              if (_userId!=null && _userId!=" ") {
                 Routers.go(context, '/person');
              }
            },
            ),
         
          ),
          ListTile(
            title: Text('消息通知',
                style: TextStyle(
                    fontFamily: 'WorkSansBold',
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
            leading: Icon(Icons.message, color: Color(0xFFf7418c), size: 18),
          ),
          ListTile(
            title: Text('反馈',
                style: TextStyle(
                    fontFamily: 'WorkSansBold',
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
            leading:
                Icon(Icons.question_answer, color: Color(0xFFf7418c), size: 18),
          ),
          ListTile(
            title: Text('关于',
                style: TextStyle(
                    fontFamily: 'WorkSansBold',
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
            leading: Icon(Icons.info, color: Color(0xFFf7418c), size: 18),
          ),
          InkWell(
            child: ListTile(
              title: Text(_userId!=null && _userId!=" " ? '退出登陆' : '登陆',
                  style: TextStyle(
                      fontFamily: 'WorkSansBold',
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
              leading:
                  Icon(_userId!=null && _userId!=" " ? Icons.exit_to_app : Icons.apps, color: Color(0xFFf7418c), size: 18),
            ),
            onTap: () {
              logOut(context);
            },
          ),
        ],
      )),
    );
  }
}
