import 'package:flutter/material.dart';
import '../service/store.dart';
import '../service/person_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Person extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Person> {
  TextEditingController _titleCtrl = TextEditingController();
  TextEditingController _desCtrl = TextEditingController();
  String _avatar;
  File _image;

 @override
  void initState() {
    getData();
    super.initState();
  }
  
  void getData() async{
   String nick = await Manager.instance.readShared("nickName");
   String des = await Manager.instance.readShared("mydesp");
   String avatar = await Manager.instance.readShared("avatar");
   _titleCtrl.text = nick;
   _desCtrl.text = des;
   setState(() {
     _avatar = avatar;
   });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.fromLTRB(12, 40, 12, 10),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(padding:EdgeInsets.only(top:30) ,),
                  Row(children: <Widget>[Text(
                    "昵称：",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),],),
                  TextField(
                    maxLength: 10,
                    controller: _titleCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white30,
                    ),
                  ),
                  Row(children: <Widget>[Text(
                    "个人介绍：",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),],),
                  TextField(
                    maxLength: 30,
                    controller: _desCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white30,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.photo_album,
                        color: Colors.greenAccent,
                        size: 30,
                      ),
                      Text(
                        "修改头像",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                  buildImgUp() ,
                  FlatButton(
                    color: Colors.blue,
                    highlightColor: Colors.blue[700],
                    colorBrightness: Brightness.dark,
                    splashColor: Colors.grey,
                    child: Text("修改"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    onPressed: () {
                      PersonService().update(context, _titleCtrl.text, _desCtrl.text, _image);
                    },
                  ),
                ],
              ),
            )));
  }

   Widget buildImgUp() {
    if (_avatar==null || _avatar==" ") {
      return InkWell(
        onTap: getImage,
        child: Icon(
          Icons.add_a_photo,
          size: 100,
        ),
      );
    } else {
      return InkWell(
        child: CircleAvatar(
       backgroundImage: _image!=null ? FileImage(_image) : NetworkImage(_avatar),
     ),
      onTap: getImage,
     );
    }
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
