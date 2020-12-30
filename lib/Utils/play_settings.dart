import 'package:flutter/material.dart';

class PlaySettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Image.asset('assets/Images/render.png'),
          ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Image.asset('assets/Images/landscape.png'),
          ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Image.asset('assets/Images/portrait.png'),
          )
        ],
      ),
    );
  }
}
