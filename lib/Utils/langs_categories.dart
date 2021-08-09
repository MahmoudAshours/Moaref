import 'package:animate_do/animate_do.dart';
import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:ffmpegtest/Themes/theme.dart';
import 'package:ffmpegtest/Utils/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguagesDropDownList extends StatefulWidget {
  @override
  _LanguagesDropDownListState createState() => _LanguagesDropDownListState();
}

class _LanguagesDropDownListState extends State<LanguagesDropDownList> {
  late DataProvider _dataProvider;

  @override
  void didChangeDependencies() {
    _dataProvider = Provider.of<DataProvider>(context, listen: false);
    _dataProvider.fetchLanguage();
    _dataProvider.fetchCategory();
    _dataProvider.fetchSounds();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      textDirection: TextDirection.rtl,
      children: [_languagePicker(_dataProvider), Search()],
    );
  }

  StreamBuilder<List<String>> _languagePicker(DataProvider provider) {
    return StreamBuilder<List<String>>(
      stream: provider.languageLinks.stream,
      builder: (_, AsyncSnapshot<List<String>> snapshot) => Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(10)),
        child: !snapshot.hasData
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: DropdownButton<String>(
                  items: snapshot.data!
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          child: Center(
                            child: Container(
                              width: 100,
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
                          ),
                          value: value,
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    provider.changeLanguage(value);
                    setState(() {});
                  },
                  value: provider.lang,
                ),
              ),
      ),
    );
  }
}
