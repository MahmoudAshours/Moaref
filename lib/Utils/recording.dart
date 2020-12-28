import 'package:animate_do/animate_do.dart';
import 'package:ffmpegtest/Themes/theme.dart';
import 'package:ffmpegtest/Utils/seach.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Recording extends StatelessWidget {
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
        BounceInUp(
          duration: Duration(seconds: 1),
          child: Center(
            child: CircleAvatar(
              backgroundColor: kSecondaryColor,
              child: FaIcon(
                FontAwesomeIcons.microphoneAlt,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Center(child: Text('هذه الخاصية تمكنك من تسجيل مقطع صوتي دعوي'))
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
