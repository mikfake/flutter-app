import '../models/auth_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Manager {
  // 工厂模式
  factory Manager() =>_getInstance();
  static Manager get instance => _getInstance();
  static Manager _instance;
  AuthData _authData;
  
  Map<String,dynamic> _store = new Map();


  Manager._internal() {
    // 初始化
  }
  static Manager _getInstance() {
    if (_instance == null) {
      _instance = new Manager._internal();
    }
    return _instance;
  }

  void add(String key,dynamic value){
        _store.addAll({key:value});
  }

  dynamic getV(String key){
       return _store[key];
  }
  
  AuthData getAuth(){
    return _authData;
  }
  
  void setAuth( AuthData auth){
      _authData =auth;
  }

 readShared(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var v = await preferences.get(key);
    return v!=null ? v:' ';
  }



   addShared(String key,dynamic value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(value is String){
        preferences.setString(key, value);
    }else if (value is double){
        preferences.setDouble(key, value);
    }else if (value is bool){
        preferences.setBool(key, value);
    }else if (value is int){
        preferences.setInt(key, value);
    }
   
  }

  removeShared(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(key);
  }

}