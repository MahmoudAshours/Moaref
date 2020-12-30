import 'package:ffmpegtest/Themes/theme.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  //Yellowish color
  final Color _primaryColor = kSecondaryColor;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.decelerate,
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: _primaryColor,
        ),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Icon(
        Icons.search,
        color: kSecondaryColor,
      ),
    ));
  }
}
