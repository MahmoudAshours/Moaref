import 'dart:async';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ffmpegtest/Models/sound_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

class UploadProvider extends ChangeNotifier {
  var path;
  var sounds = [];
  List boolList = [];
  Sound _sound = Sound.IsNotPlaying;

  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId('0');
  Sound get sound => _sound;
  var recording = false;

  isRecording() {
    Record.isRecording().asStream().listen((event) {
      recording = event;
      notifyListeners();
    });
  }

  set setSound(sound) {
    _sound = sound;
    notifyListeners();
  }

  uploadFile(context) async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      File file = File(result.files.single.path);
      sounds.add(file.path);
      boolList.add(false);
      Navigator.of(context).pop();

      notifyListeners();
    } else {
      Navigator.of(context).pop();
    }
  }

  fetchSoundData(index) {
    if (boolList.isNotEmpty && boolList[index] == true) {
      boolList[index] = false;
    } else {
      boolList = [];
      boolList = List.generate(sounds.length, (index) => false);
      boolList[index] = true;
      notifyListeners();
    }
  }

  FutureOr playSoundData(index) async {
    _sound = Sound.Loading;
    notifyListeners();

    await assetsAudioPlayer
        .open(
      Audio.file(sounds[index]),
      respectSilentMode: false,
    )
        .whenComplete(() {
      _sound = Sound.IsPlaying;
      notifyListeners();
    });
  }
}
