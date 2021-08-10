import 'dart:async';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:konmoaref/Helpers/random_string.dart';
import 'package:konmoaref/Models/sound_state.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordProvider extends ChangeNotifier {
  var path;
  List<String?>? sounds = [];
  List<bool> boolList = [];
  Sound _sound = Sound.IsNotPlaying;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId('0');
  Sound get sound => _sound;
  var recording = false;
  Record _record = Record();
  isRecording() {
    _record.isRecording().asStream().listen((event) {
      recording = event;
      notifyListeners();
    });
  }

  set setSound(Sound sound) {
    _sound = sound;
    notifyListeners();
  }

  Future<void> recordSound() async {
    await _record.hasPermission();
    try {
      Directory directory = await getApplicationSupportDirectory();
      path = join(directory.path, '${getRandString(4)}');

      await _record.start(
        path: '$path', // required
        encoder: AudioEncoder.AAC, // by default
      );
    } catch (e) {}
  }

  fetchSoundData(int index) {
    if (boolList.isNotEmpty && boolList[index] == true) {
      boolList[index] = false;
    } else {
      boolList = [];
      boolList = List.generate(sounds!.length, (index) => false);
      boolList[index] = true;
      notifyListeners();
    }
  }

  FutureOr playSoundData(int index) async {
    _sound = Sound.Loading;
    notifyListeners();

    await assetsAudioPlayer
        .open(Audio.file(
            Platform.isIOS ? "file:/" + sounds![index]! : sounds![index]!))
        .whenComplete(() {
      _sound = Sound.IsPlaying;
      notifyListeners();
    });
  }

  void endRecord() {
    _record.stop().then((audioPath) {
      sounds!.add(audioPath);
      print(audioPath);
      boolList.add(false);
      notifyListeners();
    });
    print(sounds);
  }
}
