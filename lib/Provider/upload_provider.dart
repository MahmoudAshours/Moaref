import 'dart:async';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:konmoaref/Models/sound_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class UploadProvider extends ChangeNotifier {
  String? uploadedAudioPath = "";
  List<String?>? sounds = [];
  List<bool> uploadedAudioIsPlaying = [];
  Sound _sound = Sound.IsNotPlaying;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId('0');
  Sound get sound => _sound;
  bool recording = false;

  set setSound(Sound sound) {
    _sound = sound;
    notifyListeners();
  }

  Future<void> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      File file = File(result.files.single.path);
      print(file.path);
      sounds!.add(file.path);
      uploadedAudioIsPlaying.add(false);
      notifyListeners();
    } else {
      print('object');
    }
  }

  Future<void>? fetchSoundData(int index) {
    if (uploadedAudioIsPlaying.isNotEmpty &&
        uploadedAudioIsPlaying[index] == true) {
      uploadedAudioIsPlaying[index] = false;
    } else {
      uploadedAudioIsPlaying = [];
      uploadedAudioIsPlaying = List.generate(sounds!.length, (index) => false);
      uploadedAudioIsPlaying[index] = true;
      notifyListeners();
    }
  }

  FutureOr playSoundData(int index) async {
    _sound = Sound.Loading;
    notifyListeners();

    await assetsAudioPlayer
        .open(
      Audio.file(sounds![index]!),
      respectSilentMode: false,
    )
        .whenComplete(() {
      _sound = Sound.IsPlaying;
      notifyListeners();
    });
  }
}
