import 'package:animate_do/animate_do.dart';
import 'package:ffmpegtest/Themes/theme.dart';
import 'package:ffmpegtest/Utils/search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          textDirection: TextDirection.rtl,
          children: [_languagePicker(), _categoryPicker(), Search()],
        ),
        SizedBox(height: 10),
        Container(
          height: MediaQuery.of(context).size.height / 4.4,
          child: ListView.separated(
            separatorBuilder: (c, i) {
              return FadeInUpBig(
                delay: Duration(milliseconds: 100 * i),
                child: Divider(
                  thickness: 2,
                  color: Colors.black12,
                ),
              );
            },
            itemCount: 12,
            itemBuilder: (BuildContext context, int i) {
              print(i);
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FadeInUp(
                    delay: Duration(milliseconds: 100 * i),
                    child: ListTile(
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kSecondaryColor,
                        ),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.play,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: Text(
                        'رحمة النبي',
                        style: TextStyle(color: kSecondaryFontColor),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ),
              );
            },
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
            fontSize: 19,
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
