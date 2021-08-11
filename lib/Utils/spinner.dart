import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Spinner extends StatelessWidget {
  final Color firstColor;
  final Color secondColor;
  Spinner({this.firstColor = Colors.red, this.secondColor = Colors.green});
  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? firstColor : secondColor,
          ),
        );
      },
    );
  }
}
