import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:konmoaref/Helpers/link_manipulation.dart';
import 'package:konmoaref/Models/sound_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;

class DataProvider extends ChangeNotifier {
  String? lang = 'عربي';
  String? category = 'دروس من السيرة';
  String? apiUrl;
  Sound _sound = Sound.IsNotPlaying;
  String? cloudAudioPicked;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId('0');
  List<bool> boolList = [];
  List<String> categoryItems = [];
  // Streams controlling links of languages , categories & Audio files.
  StreamController<List<String>> languageLinks = StreamController.broadcast();
  StreamController<List<String>> categoryLinks = StreamController.broadcast();
  StreamController<List<String>> soundLinks = StreamController.broadcast();

  Sound get sound => _sound;

  set setSound(Sound sound) {
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

  Future<void> changeCategory(String? newCategory) async {
    category = newCategory;
    boolList = [];
    await fetchSounds();
    notifyListeners();
  }

  void changeLanguage(String? newLanguage) {
    lang = newLanguage;
    notifyListeners();
    try {
      fetchCategory().then((List<String>? value) {
        category = value![0];
        boolList = [];
      });
    } catch (e) {}
    notifyListeners();
  }

  void setAudioFile(String? mp3) {
    cloudAudioPicked = mp3;
    notifyListeners();
  }

  Future<List<String>?> fetchCategory() async {
    try {
      final language = Uri.encodeComponent(lang!);
      apiUrl = "https://nekhtem.com/kariem/ayat/konMoarfaan/$language";
      final Response response = await Dio().get(apiUrl!);
      final Document document = parser.parse(response.data);
      final List<String> links = linkDecoder(document);
      categoryItems = links;
      categoryLinks.sink.add(links);
      notifyListeners();
      return links;
    } on Exception catch (e) {
      print(e);
    }
  }

  FutureOr<dynamic> fetchLanguage() async {
    try {
      apiUrl = "https://nekhtem.com/kariem/ayat/konMoarfaan/";
      final Response response = await Dio().get(apiUrl!);
      final Document document = parser.parse(response.data);
      final List<String> languages = languageDecoder(document);
      languageLinks.sink.add(languages);
    } catch (e) {
      print(e);
    }
  }

  fetchSoundData(AsyncSnapshot<List> snapshot, int index) {
    if (boolList.isNotEmpty && boolList[index] == true) {
      boolList[index] = false;
    } else {
      boolList = [];
      boolList = List.generate(snapshot.data!.length, (index) => false);
      boolList[index] = true;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> fetchSounds() async {
    try {
      if (lang!.contains(RegExp("^[a-zA-Z0-9]*\$"))) {
        final cat = Uri.encodeComponent(category!.toString());
        apiUrl = "https://nekhtem.com/kariem/ayat/konMoarfaan/$lang/$cat";
      } else {
        final language = Uri.encodeComponent(lang!);
        final cat = Uri.encodeFull(category!.toString());
        apiUrl = "https://nekhtem.com/kariem/ayat/konMoarfaan/$language/$cat";
      }
      final response = await Dio().get(apiUrl!);
      final document = parser.parse(response.data);
      final links = linkDecoder(document);
      soundLinks.sink.add(links);
    } on Exception catch (e) {
      print(e);
    }
  }

  void nullifymp3() {
    cloudAudioPicked = null;
    boolList = [];
    notifyListeners();
  }

  FutureOr playSoundData(
      AsyncSnapshot<List<String?>> snapshot, int index) async {
    _sound = Sound.Loading;
    notifyListeners();
    try {
      if (lang!.contains(RegExp("^[a-zA-Z0-9]*\$"))) {
        final soundData = Uri.encodeComponent(snapshot.data![index]!);
        final cat = Uri.encodeFull(category!);
        apiUrl =
            "https://nekhtem.com/kariem/ayat/konMoarfaan/$lang/$cat/$soundData";
        notifyListeners();
      } else {
        final language = Uri.encodeComponent(lang!);
        final cat = Uri.encodeComponent(category!);
        final soundData = Uri.encodeComponent(snapshot.data![index]!);
        apiUrl =
            "https://nekhtem.com/kariem/ayat/konMoarfaan/$language/$cat/$soundData";
        notifyListeners();
      }
      await assetsAudioPlayer.open(
        Audio.network(apiUrl!),
        playInBackground: PlayInBackground.enabled,
        audioFocusStrategy:
            AudioFocusStrategy.request(resumeAfterInterruption: true),
        respectSilentMode: false,
      );
      cloudAudioPicked = apiUrl;
      _sound = Sound.IsPlaying;
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }
}
