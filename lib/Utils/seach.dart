import 'package:ffmpegtest/Themes/theme.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool show = true;
  //Yellowish color
  final Color _primaryColor = kSecondaryColor;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        width: show ? 50 : 300,
        height: 50,
        child: GestureDetector(
          onTap: () {
            setState(() => show = false);
          },
          child: show
              ? Icon(
                  Icons.search,
                  color: kSecondaryColor,
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextField(
                    cursorColor: _primaryColor,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 8.0),
                        border: InputBorder.none),
                    style: TextStyle(color: _primaryColor),
                    onSubmitted: (onSubmit) {
                      setState(() => show = true);
                    },
                  ),
                ),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: _primaryColor,
          ),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
