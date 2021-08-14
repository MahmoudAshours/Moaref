import 'package:flutter/material.dart';
import 'package:konmoaref/Utils/spinner.dart';

showDownloadDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => await false,
        child: SimpleDialog(
          children: <Widget>[
            Center(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Spinner(
                        firstColor: Colors.green, secondColor: Colors.yellow),
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
        ),
      );
    },
  );
}
