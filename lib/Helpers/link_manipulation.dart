import 'package:html/dom.dart';

List<String> linkDecoder(Document document) {
  List<String> _decodedLinks = [];
  for (int _documentLinkIterator = 5;
      _documentLinkIterator < document.getElementsByTagName('a').length;
      _documentLinkIterator++) {
    String? _link = document
        .getElementsByTagName('a')[_documentLinkIterator]
        .attributes['href'];
    _link = Uri.decodeFull(_link!).replaceAll('/', '');
    _decodedLinks.add(_link);
  }
  return _decodedLinks;
}

List<String> languageDecoder(Document document) {
  List<String> _decodedLangs = [];
  for (var i = 5; i < document.getElementsByTagName('a').length - 1; i++) {
    String? _language =
        document.getElementsByTagName('a')[i].attributes['href'];
    _language = Uri.decodeFull(_language!).replaceAll('/', '');
    _decodedLangs.add(_language);
  }
  return _decodedLangs;
}
