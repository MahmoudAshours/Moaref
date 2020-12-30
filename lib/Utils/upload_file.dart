import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:ffmpegtest/Themes/theme.dart';
import 'package:ffmpegtest/Utils/search.dart';

class UploadFile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          textDirection: TextDirection.rtl,
          //TODO Fix search!!
          children: [_languagePicker(), _categoryPicker(), Search()],
        ),
        SizedBox(height: 20),
        FadeInUp(
          duration: Duration(milliseconds: 500),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: RaisedButton(
                onPressed: () {},
                color: kSecondaryColor,
                child: Text('إضافة ملف صوتي',
                    style: TextStyle(color: Colors.white)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.0),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 7),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'هذه الخاصية تمكنك من إضافة مقطع صوتي لاستخرجه كمقطع دعوي',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  _languagePicker() {
    return Container(
      width: 100,
      height: 50,
      //Changes when adding API
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          'عربي',
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
