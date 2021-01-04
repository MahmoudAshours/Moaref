import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:ffmpegtest/Helpers/link_manipulation.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as parser;

class DataProvider extends ChangeNotifier {
  var lang = 'عربي';
  var category = 'دروس من السيرة';
  String url;
  Sound _sound = Sound.IsNotPlaying;
  String mp3Picked;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId('0');
  List boolList = [];
  List categoryItems = [];
  StreamController<List<String>> languageLinks = StreamController.broadcast();
  StreamController<List<String>> categoryLinks = StreamController.broadcast();

  StreamController<List<String>> soundLinks = StreamController.broadcast();

  Sound get sound => _sound;

  set setSound(sound) {
    _sound = sound;
    notifyListeners();
  }

  // ignore: must_call_super
  void dispose() {
    assetsAudioPlayer.dispose();
    languageLinks.close();
    categoryLinks.close();
    soundLinks.close();
  }

  void changeCategory(String newCategory) {
    category = newCategory;
    boolList = [];
    fetchSounds();
    notifyListeners();
  }

  void changeLanguage(String newLanguage) {
    lang = newLanguage;

    fetchCategory().then((value) {
      category = value[0];
      fetchSounds();
          boolList = [];

    });

    notifyListeners();
  }

  Future<List<String>> fetchCategory() async {
    var language = Uri.encodeComponent(lang);
    url = "https://nekhtem.com/kariem/ayat/konMoarfaan/$language";
    var response = await Dio().get(url);
    var document = parser.parse(response.data);
    List<String> links = linkManipulator(document);
    categoryItems = links;
    links != null ? categoryLinks.sink.add(links) : '';
    notifyListeners();
    return links;
  }

  Future<void> fetchLanguage() async {
    url = "https://nekhtem.com/kariem/ayat/konMoarfaan/";
    var response = await Dio().get(url);
    var document = parser.parse(response.data);
    var links = languageManipulator(document);
    links != null ? languageLinks.sink.add(links) : '';
  }

  fetchSoundData(snapshot, index) {
    if (boolList.isNotEmpty && boolList[index] == true) {
      boolList[index] = false;
    } else {
      boolList = [];
      boolList = List.generate(snapshot.data.length, (index) => false);
      boolList[index] = true;
      notifyListeners();
    }
  }

  Future<void> fetchSounds() async {
    var url;
    if (lang.contains(RegExp("^[a-zA-Z0-9]*\$"))) {
      url = "https://nekhtem.com/kariem/ayat/konMoarfaan/$lang/$category";
    } else {
      var language = Uri.encodeComponent(lang);
      var cat = Uri.encodeComponent(category);
      url = "https://nekhtem.com/kariem/ayat/konMoarfaan/$language/$cat";
    }
    var response = await Dio().get(url);
    var document = parser.parse(response.data);
    var links = linkManipulator(document);
    links != null ? soundLinks.sink.add(links) : '';
  }

  nullifymp3() {
    mp3Picked = null;
    notifyListeners();
  }

  playSoundData(snapshot, index) {
    _sound = Sound.Loading;
    notifyListeners();

    var language = Uri.encodeComponent(lang);
    var cat = Uri.encodeComponent(category);
    var url =
        "https://nekhtem.com/kariem/ayat/konMoarfaan/$language/$cat/${snapshot.data[index]}";
    assetsAudioPlayer
        .open(
      Audio.network(url),
      showNotification: true,
    )
        .whenComplete(() {
      mp3Picked = url;
      _sound = Sound.IsPlaying;
      notifyListeners();
    });
  }
}

enum Sound { IsPlaying, IsNotPlaying, Loading }
