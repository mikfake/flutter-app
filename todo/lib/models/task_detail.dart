import 'dart:convert' show json;

class Detail {

  String createTime;
  String desp;
  String id;
  String img;
  String joins;
  String punch;
  String timeRange;
  String title;
  User user;

  Detail.fromParams({this.createTime, this.desp, this.id, this.img, this.joins, this.punch, this.timeRange, this.title, this.user});

  factory Detail(jsonStr) => jsonStr == null ? null : jsonStr is String ? new Detail.fromJson(json.decode(jsonStr)) : new Detail.fromJson(jsonStr);
  
  Detail.fromJson(jsonRes) {
    createTime = jsonRes['createTime'];
    desp = jsonRes['desp'];
    id = jsonRes['id'];
    img = jsonRes['img'];
    joins = jsonRes['joins'];
    punch = jsonRes['punch'];
    timeRange = jsonRes['timeRange'];
    title = jsonRes['title'];
    user = jsonRes['user'] == null ? null : new User.fromJson(jsonRes['user']);
  }

  @override
  String toString() {
    return '{"createTime": ${createTime != null?'${json.encode(createTime)}':'null'},"desp": ${desp != null?'${json.encode(desp)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"img": ${img != null?'${json.encode(img)}':'null'},"joins": ${joins != null?'${json.encode(joins)}':'null'},"punch": ${punch != null?'${json.encode(punch)}':'null'},"timeRange": ${timeRange != null?'${json.encode(timeRange)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'},"user": $user}';
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

