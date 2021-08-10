import 'package:html/dom.dart';

List<String> linkManipulator(Document document) {
  List<String> manipulation = [];
  for (int i = 5; i < document.getElementsByTagName('a').length; i++) {
    String? x = document.getElementsByTagName('a')[i].attributes['href'];
    x = x!.replaceAll('%20', ' ');
    x = x.replaceAll('%e2%80%99', "'");
    x = x.replaceAll('/', '');
    x = Uri.decodeComponent(x);
    manipulation.add(x);
  }
  return manipulation;
}

List<String> languageManipulator(Document document) {
  List<String> manipulation = [];
  for (var i = 5; i < document.getElementsByTagName('a').length - 1; i++) {
    String? x = document.getElementsByTagName('a')[i].attributes['href'];
    x = x!.replaceAll('%20', ' ');
    x = x.replaceAll('%e2%80%99', "'");
    x = x.replaceAll('/', '');
    x = Uri.decodeComponent(x);
    manipulation.add(x);
  }
  return manipulation;
}
