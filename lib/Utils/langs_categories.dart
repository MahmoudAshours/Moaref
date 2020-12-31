import 'package:animate_do/animate_do.dart';
import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:ffmpegtest/Themes/theme.dart';
import 'package:ffmpegtest/Utils/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LangsCats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (c, provider, d) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        textDirection: TextDirection.rtl,
        children: [
          _languagePicker(provider),
          Expanded(child: _categoryPicker(provider)),
          Search()
        ],
      ),
    );
  }

  _languagePicker(DataProvider provider) {
    return FutureBuilder<List<String>>(
      future: provider.fetchLanguage(),
      builder: (_, AsyncSnapshot<List<String>> snapshot) => Container(
        width: 150,
        height: 50,
        //Changes when adding API
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: DropdownButton<String>(
            items: snapshot.data
                .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem<String>(
                    child: Center(
                      child: SlideInUp(
                        child: Text(
                          value,
                          style: TextStyle(
                            color: kFontColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    value: value,
                  ),
                )
                .toList(),
            onChanged: (String value) {
              provider.changeLanguage(value);
            },
            value: provider.lang,
          ),
        ),
      ),
    );
  }

  _categoryPicker(DataProvider provider) {
    return FutureBuilder<List<String>>(
      future: provider.fetchCategory(),
      builder: (_, AsyncSnapshot<List<String>> snapshot) => Container(
        width: 150,
        height: 60,
        //Changes when adding API
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: DropdownButton<String>(
            items: snapshot.data
                .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem<String>(
                    child: Center(
                      child: Container(
                        width: 130,
                        child: SlideInUp(
                          child: Text(
                            value,
                            style: TextStyle(
                              color: kFontColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    value: value,
                  ),
                )
                .toList(),
            onChanged: (String value) {
              provider.changeCategory(value);
            },
            value: provider.category,
          ),
        ),
      ),
    );
  }
}
