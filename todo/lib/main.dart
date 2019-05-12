import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:/route.dart';

void main(){
  final router = new Router();
  Routers.configRouters(router);
  runApp(());
}

class  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        brightness:Brightness.light,
        primarySwatch: Colors.red,
        primaryColor:Color(0xFFf7418c),
        iconTheme:IconThemeData(
          color: Color(0xFFf7418c)
        )
      ),
      onGenerateRoute: Routers.router.generator,
    );
  }
}