import 'package:ffmpegtest/home.dart';
import 'package:flutter/material.dart';

class Changer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Home(_controller.text)));
        },
      ),
      body: Container(
        width: 200,
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: 'Type here. . .'),
        ),
      ),
    );
  }
}
