import 'dart:convert' show json;

class TodayPunch {

  List<Punch> list;

  TodayPunch.fromParams({this.list});

  factory TodayPunch(jsonStr) => jsonStr == null ? null : jsonStr is String ? new TodayPunch.fromJson(json.decode(jsonStr)) : new TodayPunch.fromJson(jsonStr);
  
  TodayPunch.fromJson(jsonRes) {
    list = jsonRes == null ? null : [];

    for (var listItem in list == null ? [] : jsonRes){
            list.add(listItem == null ? null : new Punch.fromJson(listItem));
    }
  }

  @override
  String toString() {
    return '{"json_list": $list}';
  }
}

class Punch {

  String avatar;
  String missDays;
  String puchDays;
  String rate;
  String time;
  String total;
  String userId;
  String userName;

  Punch.fromParams({this.avatar, this.missDays, this.puchDays, this.rate, this.time, this.total, this.userId, this.userName});
  
  Punch.fromJson(jsonRes) {
    avatar = jsonRes['avatar'];
    missDays = jsonRes['missDays'];
    puchDays = jsonRes['puchDays'];
    rate = jsonRes['rate'];
    time = jsonRes['time'];
    total = jsonRes['total'];
    userId = jsonRes['userId'];
    userName = jsonRes['userName'];
  }

  @override
  String toString() {
    return '{"avatar": ${avatar != null?'${json.encode(avatar)}':'null'},"missDays": ${missDays != null?'${json.encode(missDays)}':'null'},"puchDays": ${puchDays != null?'${json.encode(puchDays)}':'null'},"rate": ${rate != null?'${json.encode(rate)}':'null'},"time": ${time != null?'${json.encode(time)}':'null'},"total": ${total != null?'${json.encode(total)}':'null'},"userId": ${userId != null?'${json.encode(userId)}':'null'},"userName": ${userName != null?'${json.encode(userName)}':'null'}}';
  }
}
