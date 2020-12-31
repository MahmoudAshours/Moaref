import 'package:ffmpegtest/Helpers/link_manipulation.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as parser;
import 'package:dio/dio.dart';

class DataProvider extends ChangeNotifier {
  var lang = Uri.encodeComponent('عربي');
  var category = Uri.encodeComponent('أخلاقنا على نهج رسول الله');
  var url;

  fetchCategory() async {
    url = "https://nekhtem.com/kariem/ayat/konMoarfaan/";
    var response = await Dio().get(url);
    var document = parser.parse(response.data);
    var links = linkManipulator(document);
    var x = Uri.decodeComponent(links[0]);
    return x;
  }
}
