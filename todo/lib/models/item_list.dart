import 'dart:convert' show json;

class ItemList {

  List<Item> list;

  ItemList.fromParams({this.list});

  factory ItemList(jsonStr) => jsonStr == null ? null : jsonStr is String ? new ItemList.fromJson(json.decode(jsonStr)) : new ItemList.fromJson(jsonStr);
  
  ItemList.fromJson(jsonRes) {
    list = jsonRes == null ? null : [];

    for (var listItem in list == null ? [] : jsonRes){
            list.add(listItem == null ? null : new Item.fromJson(listItem));
    }
  }

  @override
  String toString() {
    return '{"json_list": $list}';
  }
}

class Item {

  String avatar;
  String author;
  String authorId;
  String createTime;
  String desp;
  String img;
  String joins;
  String punch;
  String taskId;
  String timeRange;
  String title;

  Item.fromParams({this.avatar, this.author, this.authorId, this.createTime, this.desp, this.img, this.joins, this.punch, this.taskId, this.timeRange, this.title});
  
  Item.fromJson(jsonRes) {
    avatar = jsonRes['avatar'];
    author = jsonRes['author'];
    authorId = jsonRes['authorId'];
    createTime = jsonRes['createTime'];
    desp = jsonRes['desp'];
    img = jsonRes['img'];
    joins = jsonRes['joins'];
    punch = jsonRes['punch'];
    taskId = jsonRes['taskId'];
    timeRange = jsonRes['timeRange'];
    title = jsonRes['title'];
  }

  @override
  String toString() {
    return '{"avatar": ${avatar != null?'${json.encode(avatar)}':'null'},"author": ${author != null?'${json.encode(author)}':'null'},"authorId": ${authorId != null?'${json.encode(authorId)}':'null'},"createTime": ${createTime != null?'${json.encode(createTime)}':'null'},"desp": ${desp != null?'${json.encode(desp)}':'null'},"img": ${img != null?'${json.encode(img)}':'null'},"joins": ${joins != null?'${json.encode(joins)}':'null'},"punch": ${punch != null?'${json.encode(punch)}':'null'},"taskId": ${taskId != null?'${json.encode(taskId)}':'null'},"timeRange": ${timeRange != null?'${json.encode(timeRange)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'}}';
  }
}

