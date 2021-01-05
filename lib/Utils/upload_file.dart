import 'package:ffmpegtest/Utils/Commons/langs_categories.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:ffmpegtest/Themes/theme.dart';

class UploadFile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LangsCats(),
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
}
