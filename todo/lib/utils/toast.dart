import 'package:fluttertoast/fluttertoast.dart';

class MyToast {
  static void info(String msg) {
    if (msg!=null && msg!="token error") {
      Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2);
    }
  }
}
