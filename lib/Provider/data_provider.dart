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
  String? _apiUrl;
  Sound _sound = Sound.IsNotPlaying;
  String? cloudAudioPicked;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId('0');
  List<bool> cloudAudioPlayingBool = [];
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
    cloudAudioPlayingBool = [];
    notifyListeners();
    soundLinks.close();
    super.dispose();
  }

  Future<void> changeCategory(String? newCategory) async {
    category = newCategory;
    cloudAudioPlayingBool = [];
    await fetchSounds();
    notifyListeners();
  }

  void changeLanguage(String? newLanguage) {
    lang = newLanguage;
    notifyListeners();
    try {
      fetchCategory().then((List<String>? value) {
        category = value![0];
        cloudAudioPlayingBool = [];
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
      _apiUrl = "https://nekhtem.com/kariem/ayat/konMoarfaan/$language";
      final Response response = await Dio().get(_apiUrl!);
      final Document document =
          await compute(dataParser, response.data.toString());
      final List<String> links = ApiDecoder.linkDecoder(document);
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
      _apiUrl = "https://nekhtem.com/kariem/ayat/konMoarfaan/";
      final Response response = await Dio().get(_apiUrl!);
      final Document document =
          await compute(dataParser, response.data.toString());
      final List<String> languages = ApiDecoder.languageDecoder(document);
      languageLinks.sink.add(languages);
    } catch (e) {
      print(e);
    }
  }

  fetchSoundData(AsyncSnapshot<List> snapshot, int index) {
    if (cloudAudioPlayingBool.isNotEmpty &&
        cloudAudioPlayingBool[index] == true) {
      cloudAudioPlayingBool[index] = false;
    } else {
      cloudAudioPlayingBool = [];
      cloudAudioPlayingBool =
          List.generate(snapshot.data!.length, (index) => false);
      cloudAudioPlayingBool[index] = true;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> fetchSounds() async {
    try {
      if (lang!.contains(RegExp("^[a-zA-Z0-9]*\$"))) {
        final cat = Uri.encodeComponent(category!.toString());
        _apiUrl = "https://nekhtem.com/kariem/ayat/konMoarfaan/$lang/$cat";
      } else {
        final language = Uri.encodeComponent(lang!);
        final cat = Uri.encodeFull(category!.toString());
        _apiUrl = "https://nekhtem.com/kariem/ayat/konMoarfaan/$language/$cat";
      }
      final response = await Dio().get(_apiUrl!);
      final document = parser.parse(response.data);
      final links = ApiDecoder.linkDecoder(document);
      soundLinks.sink.add(links);
    } on Exception catch (e) {
      print(e);
    }
  }

  void nullifymp3() {
    cloudAudioPicked = null;
    cloudAudioPlayingBool = [];
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
        _apiUrl =
            "https://nekhtem.com/kariem/ayat/konMoarfaan/$lang/$cat/$soundData";
        notifyListeners();
      } else {
        final language = Uri.encodeComponent(lang!);
        final cat = Uri.encodeComponent(category!);
        final soundData = Uri.encodeComponent(snapshot.data![index]!);
        _apiUrl =
            "https://nekhtem.com/kariem/ayat/konMoarfaan/$language/$cat/$soundData";
        notifyListeners();
      }
      await assetsAudioPlayer.open(
        Audio.network(_apiUrl!),
        playInBackground: PlayInBackground.enabled,
        audioFocusStrategy:
            AudioFocusStrategy.request(resumeAfterInterruption: true),
        respectSilentMode: false,
      );
      cloudAudioPicked = _apiUrl;
      _sound = Sound.IsPlaying;
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  static FutureOr<Document> dataParser(String responseData) async {
    return await parser.parse(responseData);
  }
}
