import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/media_information.dart';
import 'package:flutter_ffmpeg/statistics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FfmpegProvider extends ChangeNotifier {
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  final FlutterFFmpegConfig _config = FlutterFFmpegConfig();
  final FlutterFFprobe _flutterFFprobe = FlutterFFprobe();
  num? _videoDuration;

  Future startRendering(
      String? text, String? audioPath, String? videoPath) async {
    try {
      MediaInformation mediaInformation =
          await _flutterFFprobe.getMediaInformation(audioPath!);
      Map? _mediaProperties = mediaInformation.getMediaProperties();
      _videoDuration = double.parse(_mediaProperties!["duration"].toString());

      Directory? directory = await getApplicationDocumentsDirectory();
      final sound = await getSoundPath(directory);
      String fontPath = await _getFontPath(directory);
      _config.setFontDirectory(fontPath, null);
      _config.enableStatisticsCallback(this.statisticsCallback);

      final outputPath = join(directory.path, "output.mp4");
      final _ffmpegCommand =
          '-stream_loop -1 -i $videoPath -i $sound -shortest -map 0:v:0 -map 1:a:0 -y -vf "drawtext=fontfile=${fontPath}:text="hello":x=w/2:y=h/2:fontcolor=white:fontsize=24" $outputPath';

      // String _addText =
      //     '-i $outputPath -vf "drawtext=fontfile=${fontPath}:text=$text:fontcolor=white:fontsize=24:x=(w-text_w)/2:y=(h-text_h)/2, "drawtext=fontfile=${fontPath}:text=$text:fontcolor=white:fontsize=24:x=(w-text_w+30)/2:y=(h-text_h)/2"" -codec:a copy $outpu1';

      _flutterFFmpeg.executeAsync(
        _ffmpegCommand,
        (completed) => GallerySaver.saveVideo(outputPath).then(
          (bool? success) {
            Fluttertoast.showToast(
                msg: "تم الانتهاء من المقطع",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 24.0);
            notifyListeners();
          },
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  cancelOperation() => _flutterFFmpeg.cancel();

  void statisticsCallback(Statistics statistics) {
    int percentage = (statistics.time * 100) ~/ _videoDuration!;
    Fluttertoast.showToast(
        msg: "${percentage.toStringAsFixed(0)}\n% جاري العمل على المقطع",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<String> getSoundPath(Directory directory) async {
    var soundPath = join(directory.path, "input.mp3");
    ByteData soundData = await rootBundle.load("assets/input.mp3");
    List<int> soundBytes = soundData.buffer
        .asUint8List(soundData.offsetInBytes, soundData.lengthInBytes);
    await File(soundPath).writeAsBytes(soundBytes);
    return soundPath;
  }

  Future<String> _getFontPath(Directory directory) async {
    final fontPath = join(directory.path, "arabic.ttf");
    ByteData fontData = await rootBundle.load("assets/Fonts/NeoSansArabic.ttf");
    List<int> fontBytes = fontData.buffer
        .asUint8List(fontData.offsetInBytes, fontData.lengthInBytes);
    await File(fontPath).writeAsBytes(fontBytes);
    return fontPath;
  }
}
