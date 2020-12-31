linkManipulator(document) {
  List manipulation = [];
  for (var i = 5; i < document.getElementsByTagName('a').length; i++) {
    String x = document.getElementsByTagName('a')[i].attributes['href'];
    x = x.replaceAll('%20', ' ');
    x = x.replaceAll('%e2%80%99', "'");
    x = x.replaceAll('/', '');
    manipulation.add(x);
  }
  return manipulation;
}
