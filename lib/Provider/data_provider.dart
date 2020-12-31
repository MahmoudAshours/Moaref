import 'dart:convert';

import 'package:ffmpegtest/Helpers/link_manipulation.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as parser;
import 'package:dio/dio.dart';

class DataProvider extends ChangeNotifier {
  var lang = 'عربي';
  var category = 'أخلاقنا على نهج رسول الله';
  var url;

  fetchData() async {
    url = "https://nekhtem.com/kariem/ayat/konMoarfaan/";
    var response = await Dio().get(url);
    var document = parser.parse(response.data);
    var links = linkManipulator(document);

    ascii.decode(links[0].codeUnits);

    return links[0];
  }
}
