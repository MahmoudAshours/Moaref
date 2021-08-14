import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConnectivityIssues {
  static noInternet() {
    Fluttertoast.showToast(
        msg: "تأكد من الانترنت الخاص بك",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 6,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 24.0);
  }
}
