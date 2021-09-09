import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konmoaref/Helpers/salah_remover.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FFmpegMacProvider extends ChangeNotifier {
  String? fontPath;
  _drawText(String text,
      {String height = "(h-text_h)/2",
      String width = "(w-text_w)/2",
      String fontColor = "black",
      String fontSize = "24"}) {
    return "drawtext=fontfile=$fontPath:text=$text:x=$width:y=$height:fontcolor=$fontColor:fontsize=$fontSize";
  }

  Future<String> getSoundPath(Directory directory, String cloudAudio) async {
    final soundPath = join(directory.path, "input.mp3");
    await Dio().download(cloudAudio, soundPath);
    return soundPath;
  }

  Future<String> _getFontPath(Directory directory, String category) async {
    String? fontPath;
    ByteData fontData;

    fontPath = join(directory.path, "arial.ttf");
    fontData = await rootBundle.load("assets/Fonts/arial.ttf");

    List<int> fontBytes = fontData.buffer
        .asUint8List(fontData.offsetInBytes, fontData.lengthInBytes);
    await File(fontPath).writeAsBytes(fontBytes);
    return fontPath;
  }

  void startRendering(List<String?> text, String? audioPath, String? videoPath,
      BuildContext context, String? language, String orientation) async {
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
      Directory? directory = await getApplicationDocumentsDirectory();
      Directory? saveDir = await getDownloadsDirectory();

      String sound;
      print(Uri.tryParse(audioPath!)!.hasAbsolutePath);
      if (audioPath.contains("https:")) {
        sound = await getSoundPath(directory, audioPath);
      } else {
        sound = audioPath.replaceAll(' ', '---');
        print(sound);
      }
      fontPath = await _getFontPath(directory, language!);
      final _outputPath = join(saveDir!.path, "output.mp4");

      final _titleSection = _drawText(
        '${_centeredText.replaceAll(' ', '---')}',
        width: "((w-text_w)/2)",
        height: "((h-text_h)/2)",
        fontSize: orientation == "mobile"
            ? '(w/25)-${_centeredText.length}/10'
            : '(w/30)-${_centeredText.length}/10',
      );

      final _sheikhSection = _drawText(
        '${_sheikhName.replaceAll(' ', '---')}',
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
        '${_topText.replaceAll(' ', '---')}',
        width: orientation == "mobile"
            ? "((w-text_w)/2)+60"
            : "((w-text_w)/2)+100",
        height:
            orientation == "mobile" ? "((h-text_h)/2)-60" : "((h-text_h)/2)-90",
        fontSize: '(w/45)-${_topText.length}/20',
        fontColor: '#FFFFFF',
      );
      if (orientation == 'tablet') {
        var base = basename(videoPath!);
        videoPath = videoPath.replaceFirst(
            base, base.replaceFirst('mobile', 'youtube'));
      }
      final _ffmpegCommand =
          '-stream_loop -1 -i $videoPath -i $sound -shortest -map 0:v:0 -map 1:a:0 -y -vf ${_sheikhSection},$_titleSection,$_categorySection $_outputPath';

      final _splittedCommand = _ffmpegCommand.split(' ');
      List<String> newCommand = [];
      _splittedCommand.forEach((element) {
        final x = element.replaceAll('---', ' ');
        newCommand.add(x);
      });
      await Process.run("ffmpeg", newCommand)
          .then((value) => print(value.stderr));
      Navigator.of(context).pop();
    } on ProcessException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }
}
