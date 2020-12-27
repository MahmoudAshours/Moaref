import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [Text('hello')],
          )
        ],
      ),
    );
  }

  _languagePicker() {
    return Container(
      //Changes when adding API
      child: Text('عربي'),
    );
  }
  _categoryPicker() {}
  _search() {}
}
