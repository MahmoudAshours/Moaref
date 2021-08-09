import 'package:flutter/material.dart';

showDownloadDialog(BuildContext context, GlobalKey _key) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SimpleDialog(
        key: _key,
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
