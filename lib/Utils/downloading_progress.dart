import 'package:flutter/material.dart';

showDownloadDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SimpleDialog(
        children: <Widget>[
          Center(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  Text("جاري التحميل"),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}
