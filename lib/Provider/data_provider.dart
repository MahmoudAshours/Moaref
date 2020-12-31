import 'package:ffmpegtest/Helpers/link_manipulation.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as parser;
import 'package:dio/dio.dart';

class DataProvider extends ChangeNotifier {
  var lang = 'عربي';
  var category = 'دروس من السيرة';
  var url;

  Future<List<String>> fetchCategory() async {
    var language = Uri.encodeComponent(lang);
    url = "https://nekhtem.com/kariem/ayat/konMoarfaan/$language";
    var response = await Dio().get(url);
    var document = parser.parse(response.data);
    var links = linkManipulator(document);
    return links;
  }

  Future<List<String>> fetchLanguage() async {
    url = "https://nekhtem.com/kariem/ayat/konMoarfaan/";
    var response = await Dio().get(url);
    var document = parser.parse(response.data);
    var links = languageManipulator(document);
    return links;
  }

  void changeLanguage(String newLanguage) {
    lang = newLanguage;
    fetchCategory().then((value) {
      category = value[0];
      notifyListeners();
    });
    notifyListeners();
  }

  void changeCategory(String newCategory) {
    category = newCategory;
    notifyListeners();
  }
}
