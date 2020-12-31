import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ffmpegtest/Helpers/link_manipulation.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as parser;
import 'package:dio/dio.dart';

class DataProvider extends ChangeNotifier {
  var lang = 'عربي';
  var category = 'دروس من السيرة';
  var url;
  var sound = Sound.IsNotPlaying;
  var _assetsAudioPlayer = AssetsAudioPlayer();

  Future<List<String>> fetchCategory() async {
    var language = Uri.encodeComponent(lang);
    url = "https://nekhtem.com/kariem/ayat/konMoarfaan/$language";
    var response = await Dio().get(url);
    var document = parser.parse(response.data);
    List<String> links = linkManipulator(document);

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
    });
    notifyListeners();
  }

  Future<List<String>> fetchSounds() async {
    var language = Uri.encodeComponent(lang);
    var cat = Uri.encodeComponent(category);
    var url = "https://nekhtem.com/kariem/ayat/konMoarfaan/$language/$cat";
    var response = await Dio().get(url);
    var document = parser.parse(response.data);
    var links = linkManipulator(document);
    return links;
  }

  fetchSoundData(snapshot, index) async {
    var language = Uri.encodeComponent(lang);
    var cat = Uri.encodeComponent(category);
    if (sound == Sound.IsNotPlaying) {
      await _assetsAudioPlayer.open(
        Audio.network(
            "https://nekhtem.com/kariem/ayat/konMoarfaan/$language/$cat/${snapshot.data[index]}"),
        showNotification: true,
      );
      sound = Sound.IsPlaying;
      notifyListeners();
    } else {
      await _assetsAudioPlayer.stop();
      sound = Sound.IsNotPlaying;
      notifyListeners();
    }
  }

  void changeCategory(String newCategory) {
    category = newCategory;
    notifyListeners();
  }
}

enum Sound { IsPlaying, IsNotPlaying }
