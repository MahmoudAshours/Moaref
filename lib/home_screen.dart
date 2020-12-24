import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double height = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onVerticalDragStart: (s) => setState(() {
          height = 200;
        }),
        child: AnimatedContainer(
          height: height,
          duration: Duration(seconds: 2),
          color: Colors.black,
        ),
      ),
    );
  }
}
