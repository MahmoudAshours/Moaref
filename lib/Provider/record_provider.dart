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
  String? recordPath = "";
  List<String?>? recordedFilePaths = [];
  List<bool> playingBoolList = [];
  Sound _sound = Sound.IsNotPlaying;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId('0');
  Sound get sound => _sound;
  var recording = false;
  Record _record = Record();

  isRecordingListener() {
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
      Directory directory = await getApplicationDocumentsDirectory();
      final path = join(directory.path, '${getRandString(4)}');
      await _record.start(
        path: '$path.m4a', // required
        encoder: AudioEncoder.AAC, // by default
      );
    } catch (e) {
      print(e);
    }
  }

  void fetchSoundData(int index) {
    if (playingBoolList.isNotEmpty && playingBoolList[index] == true) {
      playingBoolList[index] = false;
    } else {
      playingBoolList = [];
      playingBoolList =
          List.generate(recordedFilePaths!.length, (index) => false);
      playingBoolList[index] = true;
      notifyListeners();
    }
  }

  FutureOr playSoundData(int index) async {
    _sound = Sound.Loading;
    notifyListeners();

    await assetsAudioPlayer.open(
      Audio.file(recordedFilePaths![index]!),
      showNotification: true,
    );
    print('object');
    _sound = Sound.IsPlaying;
    notifyListeners();
  }

  void endRecord() {
    _record.stop().then((String? audioPath) {
      recordedFilePaths!.add(audioPath);
      print(audioPath);
      recordPath = audioPath;
      playingBoolList.add(false);
      notifyListeners();
    });
    print(recordedFilePaths);
  }
}
