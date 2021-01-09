import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/statistics.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FfmpegProvider extends ChangeNotifier {
  var audio;
  var video;
  Future createFile(String text) async {
    try {
      final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
      final FlutterFFmpegConfig _config = FlutterFFmpegConfig();

      Directory directory = await getApplicationDocumentsDirectory();

      String dbPath = await getVideoPath(directory);
      String soundPath = await getSoundPath(directory);
      String fontPath = await getFontPath(directory);

      var outputPath = join(directory.path, "output.mp4");
      var outpu1 = join(directory.path, "output1.mp4");

      String _loopVideo =
          '-stream_loop -1 -i $dbPath -i $soundPath -shortest -map 0:v:0 -map 1:a:0 -y $outputPath';

      String _addText =
          '-i $outputPath -vf "drawtext=fontfile=${fontPath}:text=$text:fontcolor=white:fontsize=24:x=(w-text_w)/2:y=(h-text_h)/2, "drawtext=fontfile=${fontPath}:text=$text:fontcolor=white:fontsize=24:x=(w-text_w+30)/2:y=(h-text_h)/2"" -codec:a copy $outpu1';

      _config.setFontDirectory(fontPath, null);

      _flutterFFmpeg.executeAsync(_loopVideo, (d, s) {
        print(d);
        print(s);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> getVideoPath(directory) async {
    var dbPath = join(directory.path, "input.mp4");
    ByteData data = await rootBundle.load("assets/input.mp4");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);

    return dbPath;
  }

  Future<String> getSoundPath(directory) async {
    var soundPath = join(directory.path, "input.mp3");
    ByteData soundData = await rootBundle.load("assets/input.mp3");
    List<int> soundBytes = soundData.buffer
        .asUint8List(soundData.offsetInBytes, soundData.lengthInBytes);
    await File(soundPath).writeAsBytes(soundBytes);
    return soundPath;
  }

  Future<String> getFontPath(directory) async {
    var fontPath = join(directory.path, "arabic.ttf");
    ByteData fontData = await rootBundle.load("assets/Fonts/NeoSansArabic.ttf");
    List<int> fontBytes = fontData.buffer
        .asUint8List(fontData.offsetInBytes, fontData.lengthInBytes);
    await File(fontPath).writeAsBytes(fontBytes);
    return fontPath;
  }
}
