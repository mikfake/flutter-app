import 'dart:convert' show json;

class AuthData {

  String tooken;
  User user;

  AuthData.fromParams({this.tooken, this.user});

  factory AuthData(jsonStr) => jsonStr == null ? null : jsonStr is String ? new AuthData.fromJson(json.decode(jsonStr)) : new AuthData.fromJson(jsonStr);
  
  AuthData.fromJson(jsonRes) {
    tooken = jsonRes['tooken'];
    user = jsonRes['user'] == null ? null : new User.fromJson(jsonRes['user']);
  }

  @override
  String toString() {
    return '{"tooken": ${tooken != null?'${json.encode(tooken)}':'null'},"user": $user}';
  }
}

class User {

  String img;
  String wechat;
  double code;
  double money;
  String desp;
  String id;
  String loginName;
  String nickName;
  String password;

  User.fromParams({this.img, this.wechat, this.code, this.money, this.desp, this.id, this.loginName, this.nickName, this.password});
  
  User.fromJson(jsonRes) {
    img = jsonRes['img'];
    wechat = jsonRes['wechat'];
    code = jsonRes['code'];
    money = jsonRes['money'];
    desp = jsonRes['desp'];
    id = jsonRes['id'];
    loginName = jsonRes['loginName'];
    nickName = jsonRes['nickName'];
    password = jsonRes['password'];
  }

  @override
  String toString() {
    return '{"img": ${img != null?'${json.encode(img)}':'null'},"wechat": ${wechat != null?'${json.encode(wechat)}':'null'},"code": $code,"money": $money,"desp": ${desp != null?'${json.encode(desp)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"loginName": ${loginName != null?'${json.encode(loginName)}':'null'},"nickName": ${nickName != null?'${json.encode(nickName)}':'null'},"password": ${password != null?'${json.encode(password)}':'null'}}';
  }
}

