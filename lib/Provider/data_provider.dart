import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:dio/dio.dart';
import 'package:ffmpegtest/Helpers/link_manipulation.dart';
import 'package:ffmpegtest/Models/sound_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;

class DataProvider extends ChangeNotifier {
  String? lang = 'عربي';
  String? category = 'دروس من السيرة';
  String? url;
  Sound _sound = Sound.IsNotPlaying;
  String? mp3Picked;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId('0');
  List boolList = [];
  List categoryItems = [];
  // Streams controlling links of languages , categories & Audio files.
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
    boolList = [];
    notifyListeners();
    soundLinks.close();
    super.dispose();
  }

  void changeCategory(String? newCategory) {
    category = newCategory;
    boolList = [];
    fetchSounds();
    notifyListeners();
  }

  void changeLanguage(String? newLanguage) {
    lang = newLanguage;
    notifyListeners();
    try {
      fetchCategory().then((List<String>? value) {
        category = value![0];
        fetchSounds();
        boolList = [];
      });
    } catch (e) {}
    notifyListeners();
  }

  setMp3(mp3) {
    mp3Picked = mp3;
    notifyListeners();
  }

  Future<List<String>?> fetchCategory() async {
    try {
      var language = Uri.encodeComponent(lang!);
      url = "https://nekhtem.com/kariem/ayat/konMoarfaan/$language";
      var response = await Dio().get(url!);
      var document = parser.parse(response.data);
      List<String> links = linkManipulator(document);
      categoryItems = links;
      categoryLinks.sink.add(links);
      notifyListeners();
      return links;
    } on Exception catch (e) {
      print(e);
    }
  }

  fetchLanguage() async {
    try {
      url = "https://nekhtem.com/kariem/ayat/konMoarfaan/";
      var response = await Dio().get(url!);
      var document = parser.parse(response.data);
      var links = languageManipulator(document);
      languageLinks.sink.add(links);
    } catch (e) {
      print(e);
    }
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
    try {
      if (lang!.contains(RegExp("^[a-zA-Z0-9]*\$"))) {
        print('object');
        var cat = Uri.encodeComponent(category!);
        url = "https://nekhtem.com/kariem/ayat/konMoarfaan/$lang/$cat";
      } else {
        var language = Uri.encodeComponent(lang!);
        var cat = Uri.encodeComponent(category!);
        url = "https://nekhtem.com/kariem/ayat/konMoarfaan/$language/$cat";
      }
      var response = await Dio().get(url!);
      var document = parser.parse(response.data);
      var links = linkManipulator(document);
      soundLinks.sink.add(links);
    } on Exception catch (e) {
      print(e);
    }
  }

  nullifymp3() {
    mp3Picked = null;
    boolList = [];
    notifyListeners();
  }

  FutureOr playSoundData(snapshot, index) async {
    _sound = Sound.Loading;
    notifyListeners();

    try {
      if (lang!.contains(RegExp("^[a-zA-Z0-9]*\$"))) {
        url =
            "https://nekhtem.com/kariem/ayat/konMoarfaan/$lang/$category/${snapshot.data[index]}";
      } else {
        var language = Uri.encodeComponent(lang!);
        var cat = Uri.encodeComponent(category!);
        var soundData = Uri.encodeComponent(snapshot.data[index]);
        url =
            "https://nekhtem.com/kariem/ayat/konMoarfaan/$language/$cat/$soundData";
      }
      await assetsAudioPlayer
          .open(
        Audio.network(url!),
        playInBackground: PlayInBackground.enabled,
        audioFocusStrategy:
            AudioFocusStrategy.request(resumeAfterInterruption: true),
        respectSilentMode: false,
      )
          .whenComplete(() {
        mp3Picked = url;
        _sound = Sound.IsPlaying;
        notifyListeners();
      });
    } on Exception catch (e) {
      print(e);
    }
  }
}
