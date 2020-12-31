import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:ffmpegtest/Themes/theme.dart';
import 'package:ffmpegtest/Utils/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LangsCats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (c, provider, d) => FutureBuilder(
        future: provider.fetchCategory(),
        builder: (_, snap) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          textDirection: TextDirection.rtl,
          children: [_languagePicker(snap), _categoryPicker(), Search()],
        ),
      ),
    );
  }

  _languagePicker(AsyncSnapshot snapshot) {
    return Container(
      width: 100,
      height: 50,
      //Changes when adding API
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          snapshot.data,
          style: TextStyle(
            color: kFontColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  _categoryPicker() {
    return Container(
      width: 200,
      height: 50,
      //Changes when adding API
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          'التصنيف / مقاطع دعوية',
          style: TextStyle(
            color: kFontColor,
            fontWeight: FontWeight.w700,
            fontSize: 19,
          ),
        ),
      ),
    );
  }
}
