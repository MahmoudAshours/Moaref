import 'package:dio/dio.dart';
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
import 'package:konmoaref/Screens/FFmpegOps/rendered_preview.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:konmoaref/Helpers/salah_remover.dart';

class FfmpegProvider extends ChangeNotifier {
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  final FlutterFFmpegConfig _config = FlutterFFmpegConfig();
  final FlutterFFprobe _flutterFFprobe = FlutterFFprobe();
  double? _videoDuration;
  String? fontPath;
  double percentage = 0;
  _drawText(String text,
      {String height = "(h-text_h)/2",
      String width = "(w-text_w)/2",
      String fontColor = "black",
      String fontSize = "24"}) {
    return "drawtext=${fontPath == null ? null : 'fontfile=$fontPath'}:text=$text:x=$width:y=$height:fontcolor=$fontColor:fontsize=$fontSize";
  }

  Future<String> startRendering(
      List<String?> text,
      String? audioPath,
      String? videoPath,
      BuildContext context,
      String? language,
      String orientation) async {
    String _centeredText;
    String _topText;
    String _sheikhName;
    if (text.length == 3) {
      _centeredText = text[0]!;
      _topText = text[1]!;
      _sheikhName = text[2]!;
    } else {
      _centeredText = text[0]!
          .replaceAll('.mp3', '')
          .replaceAll(RegExp(r'\(\d+\)'), '')
          .remover()
          .replaceAll(',', '')
          .replaceAll('"', '')
          .split('-')[0]
          .trim();

      _topText = text[1]!.remover().trim();

      _sheikhName = text[0]!.contains('-')
          ? text[0]!
              .split('-')[1]
              .replaceAll('.mp3', '')
              .replaceAll(RegExp(r'\(\d+\)'), '')
              .trim()
          : "";
    }

    try {
      MediaInformation mediaInformation =
          await _flutterFFprobe.getMediaInformation(audioPath!);
      Map? _mediaProperties = mediaInformation.getMediaProperties();
      _videoDuration = double.parse(_mediaProperties!["duration"].toString());

      Directory? directory = await getApplicationDocumentsDirectory();
      String sound;
      if (!Uri.tryParse(audioPath)!.hasAbsolutePath)
        sound = await getSoundPath(directory, audioPath);
      sound = audioPath;
      fontPath = await _getFontPath(directory, language!);
      _config.setFontDirectory(fontPath!, null);
      percentage = 0;
      notifyListeners();
      _config.enableStatisticsCallback(this.statisticsCallback);

      final _outputPath = join(directory.path, "output.mp4");

      final _titleSection = _drawText(
        '$_centeredText',
        width: "((w-text_w)/2)",
        height: "((h-text_h)/2)",
        fontSize: orientation == "mobile"
            ? '(w/25)-${_centeredText.length}/10'
            : '(w/30)-${_centeredText.length}/10',
      );

      final _sheikhSection = _drawText(
        '$_sheikhName',
        width:
            orientation == "mobile" ? "((w-text_w)/2)-60" : "((w-text_w)/2)-80",
        height:
            orientation == "mobile" ? "((h-text_h)/2)+60" : "((h-text_h)/2)+90",
        fontSize: orientation == "mobile"
            ? '(w/25)-${_sheikhName.length}/10'
            : '(w/35)-${_sheikhName.length}/8',
        fontColor: '#FFFFFF',
      );

      final _categorySection = _drawText(
        '$_topText',
        width:
            orientation == "mobile" ? "((w-text_w)/2)+60" : "((w-text_w)/2)+70",
        height:
            orientation == "mobile" ? "((h-text_h)/2)-60" : "((h-text_h)/2)-90",
        fontSize: '(w/40)-${_topText.length}/10',
        fontColor: '#FFFFFF',
      );
      if (orientation == 'tablet') {
        var base = basename(videoPath!);
        videoPath = videoPath.replaceFirst(
            base, base.replaceFirst('mobile', 'youtube'));
      }
      final _ffmpegCommand =
          '-stream_loop -1 -i $videoPath -i "$sound" -shortest -map 0:v:0 -map 1:a:0 -y -vf "$_sheikhSection","$_titleSection","$_categorySection" $_outputPath';

      _flutterFFmpeg.executeAsync(_ffmpegCommand, (completed) {
        if (completed.returnCode == 0)
          GallerySaver.saveVideo(_outputPath).then(
            (bool? success) {
              if (success!) {
                percentage = 0;
                notifyListeners();
                Fluttertoast.showToast(
                    msg: "تم الانتهاء من المقطع",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 24.0);
                Navigator.of(context).pop();
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        RenderedVideoPreview(videoPath: _outputPath),
                  ),
                );
                notifyListeners();
              }
            },
          );
      });
      return _outputPath;
    } catch (e) {
      print(e);
    }
    return '';
  }

  Future<void> cancelOperation() async {
    percentage = 0;
    notifyListeners();
    await _flutterFFmpeg.cancel();
  }

  void statisticsCallback(Statistics statistics) {
    double _percentage = ((statistics.time / 1000) / _videoDuration!) * 100;
    percentage = _percentage;
    notifyListeners();
  }

  Future<String> getSoundPath(Directory directory, String cloudAudio) async {
    final soundPath = join(directory.path, "input.mp3");
    await Dio().download(cloudAudio, soundPath);
    return soundPath;
  }

  Future<String> _getFontPath(Directory directory, String category) async {
    String? fontPath;
    ByteData fontData;

    if (category == "عربي") {
      fontPath = join(directory.path, "arabic.ttf");
      fontData = await rootBundle.load("assets/Fonts/NeoSansArabic.ttf");
    } else {
      fontPath = join(directory.path, "arial.ttf");
      fontData = await rootBundle.load("assets/Fonts/arial.ttf");
    }
    List<int> fontBytes = fontData.buffer
        .asUint8List(fontData.offsetInBytes, fontData.lengthInBytes);
    await File(fontPath).writeAsBytes(fontBytes);
    return fontPath;
  }
}
