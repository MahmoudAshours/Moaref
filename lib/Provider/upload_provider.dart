import 'dart:async';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:konmoaref/Models/sound_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadProvider extends ChangeNotifier {
  var path;
  var sounds = [];
  List uploadedAudioIsPlaying = [];
  Sound _sound = Sound.IsNotPlaying;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId('0');
  Sound get sound => _sound;
  var recording = false;

  set setSound(sound) {
    _sound = sound;
    notifyListeners();
  }

  Future<Null> uploadFile(context) async {
    FilePickerResult? result;
    try {
      result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['mp4']);
    } catch (e) {
      print(e);
    }
    print('object');
    if (result != null) {
      File file = File(result.files.single.path!);
      sounds.add(file.path);
      uploadedAudioIsPlaying.add(false);
      notifyListeners();
    } else {}
  }

  Future<Null>? fetchSoundData(index) {
    if (uploadedAudioIsPlaying.isNotEmpty &&
        uploadedAudioIsPlaying[index] == true) {
      uploadedAudioIsPlaying[index] = false;
    } else {
      uploadedAudioIsPlaying = [];
      uploadedAudioIsPlaying = List.generate(sounds.length, (index) => false);
      uploadedAudioIsPlaying[index] = true;
      notifyListeners();
    }
    return null;
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
