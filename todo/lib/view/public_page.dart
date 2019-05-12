import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../service/public_service.dart';

class Public extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Public> {
  File _image;
  TextEditingController _titleCtrl = TextEditingController();
  TextEditingController _desCtrl = TextEditingController();
  String _radio='1';
  String _hour1='06';
  String _hour2='08';
  String _minut1='00';
  String _minut2='00';
  String _timeRange='全天'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.fromLTRB(12, 40, 12, 10),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    maxLength: 30,
                    controller: _titleCtrl,
                    decoration: InputDecoration(
                      hintText: '请输入目标标题',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white30,
                    ),
                  ),
                  TextField(
                    maxLines: 10,
                    maxLength: 300,
                    controller: _desCtrl,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10.0),
                      hintText: '请输入目标简单描述',
                      // contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white30,
                    ),
                  ),
                  buildTime(context),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.photo_album,
                        color: Colors.greenAccent,
                        size: 30,
                      ),
                      Text(
                        "添加封面图片",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                  buildImgUp(context),
                  FlatButton(
                    color: Colors.blue,
                    highlightColor: Colors.blue[700],
                    colorBrightness: Brightness.dark,
                    splashColor: Colors.grey,
                    child: Text("发布"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    onPressed: () => PublicService()
                        .onSubmit(context, _titleCtrl, _desCtrl, _image,_timeRange),
                  )
                ],
              ),
            )));
  }

  Widget buildImgUp(BuildContext context) {
    if (_image==null) {
      return InkWell(
        onTap: getImage,
        child: Icon(
          Icons.add_a_photo,
          size: 100,
        ),
      );
    } else {
      return SizedBox(
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            onTap: getImage,
            child: Image.file(
              _image,
              fit: BoxFit.cover,
            ),
          ));
    }
  }

  Widget buildTime(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.timer, size: 30),
            Text(
              "打卡时间：",
              style: TextStyle(fontSize: 15),
            ),
            Radio(
              groupValue: this._radio,
              activeColor: Colors.blue,
              value: '1',
              onChanged: (String val) {
                this.setState(() {
                  this._timeRange='全天';
                  this._radio = val; // aaa
                });
              },
            ),
            Text(
              "全天",
              style: TextStyle(fontSize: 15),
            ),
            Radio(
              groupValue: this._radio,
              activeColor: Colors.blue,
              value: '2',
              onChanged: (String val) {
                this.setState(() {
                  this._timeRange= this._hour1+':'+this._minut1+'-'+this._hour2+':'+this._minut2;
                  this._radio = val; // aaa
                });
              },
            ),
            Text(
              "时间段",
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        this._radio=='2' ? buildSelect() : Padding(padding: EdgeInsets.all(2),)
      ],
    );
  }
  
  Widget buildSelect(){
     return Column(
       children: <Widget>[
         Row(
       children: <Widget>[
         Text("从     ",style: TextStyle(fontSize:15 ),),
         DropdownButton(
           items: getHourData(),
           hint:new Text('选择小时'),
           value: this._hour1,
           onChanged:(t){
              setState(() {
                this._hour1 = t;
                this._timeRange= this._hour1+':'+this._minut1+'-'+this._hour2+':'+this._minut2;
              });
           } ,
         ),
         DropdownButton(
           items: getMinuData(),
           hint:new Text('选择分钟'),
           value: this._minut1,
           onChanged:(t){
              setState(() {
                this._minut1 = t;
                this._timeRange= this._hour1+':'+this._minut1+'-'+this._hour2+':'+this._minut2;
              });
           } ,
         )
       ],
     ),
     Row(
       children: <Widget>[
         Text("到     ",style: TextStyle(fontSize:15 ),),
         DropdownButton(
           items: getHourData(),
           hint:new Text('选择小时'),
           value: this._hour2,
           onChanged:(t){
              setState(() {
                this._hour2 = t;
                this._timeRange= this._hour1+':'+this._minut1+'-'+this._hour2+':'+this._minut2;
              });
           } ,
         ),
         DropdownButton(
           items: getMinuData(),
           hint:new Text('选择分钟'),
           value: this._minut2,
           onChanged:(t){
              setState(() {
                this._minut2 = t;
                this._timeRange= this._hour1+':'+this._minut1+'-'+this._hour2+':'+this._minut2;
              });
           } ,
         ),
       ],
     )
       ],
     );
  }
  
  List<DropdownMenuItem> getHourData() {
    List<DropdownMenuItem> items = new List();
    for (var i = 0; i < 24; i++) {
      var v='';
      if(i<10) {
        v='0'+i.toString();
      }else {
        v = i.toString();
      }
      DropdownMenuItem dropdownMenuItem = new DropdownMenuItem(
        child: new Text(v),
        value: v,
      );
      items.add(dropdownMenuItem);
    }
    return items;
  }

List<DropdownMenuItem> getMinuData() {
    List<DropdownMenuItem> items = new List();
    for (var i = 0; i < 60; i++) {
      var v='';
      if(i<10) {
        v='0'+i.toString();
      }else {
        v = i.toString();
      }
      DropdownMenuItem dropdownMenuItem = new DropdownMenuItem(
        child: new Text(v),
        value: v,
      );
      items.add(dropdownMenuItem);
    }
    return items;
  }


  Future getImage() async {
    var image;
    try {
       image = await ImagePicker.pickImage(source: ImageSource.gallery);
    } on Exception catch (e) {
      print(e);
      image = null;
    }
    setState(() {
      _image = image;
    });
  }
}
