import 'dart:convert' show json;

class MyRecord {

  List<Record> list;

  MyRecord.fromParams({this.list});

  factory MyRecord(jsonStr) => jsonStr == null ? null : jsonStr is String ? new MyRecord.fromJson(json.decode(jsonStr)) : new MyRecord.fromJson(jsonStr);
  
  MyRecord.fromJson(jsonRes) {
    list = jsonRes == null ? null : [];

    for (var listItem in list == null ? [] : jsonRes){
            list.add(listItem == null ? null : new Record.fromJson(listItem));
    }
  }

  @override
  String toString() {
    return '{"json_list": $list}';
  }
}

class Record {

  String avatar;
  double code;
  String name;
  String time;

  Record.fromParams({this.avatar, this.code, this.name, this.time});
  
  Record.fromJson(jsonRes) {
    avatar = jsonRes['avatar'];
    code = jsonRes['code'];
    name = jsonRes['name'];
    time = jsonRes['time'];
  }

  @override
  String toString() {
    return '{"avatar": ${avatar != null?'${json.encode(avatar)}':'null'},"code": $code,"name": ${name != null?'${json.encode(name)}':'null'},"time": ${time != null?'${json.encode(time)}':'null'}}';
  }
}

