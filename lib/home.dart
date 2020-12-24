import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class Home extends StatefulWidget {
  final text;
  Home(this.text);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  VideoPlayerController _controller;
  var _loading = true;
  @override
  void initState() {
    print(widget.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                child: VideoPlayer(_controller),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => _createFile("${widget.text}"));
        },
        child: _loading
            ? SizedBox()
            : Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
      ),
    );
  }

  Future _createFile(String text) async {
    try {
      var appDir = (await getApplicationDocumentsDirectory()).path;
      Directory(appDir).delete(recursive: true);
      final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
      final FlutterFFmpegConfig _config = FlutterFFmpegConfig();
      Directory directory = await getApplicationDocumentsDirectory();

      var dbPath = join(directory.path, "input.mp4");
      ByteData data = await rootBundle.load("assets/input.mp4");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);

      var soundPath = join(directory.path, "input.mp3");
      ByteData soundData = await rootBundle.load("assets/input.mp3");
      List<int> soundBytes = soundData.buffer
          .asUint8List(soundData.offsetInBytes, soundData.lengthInBytes);
      await File(soundPath).writeAsBytes(soundBytes);

      var fontPath = join(directory.path, "arabic.ttf");
      ByteData fontData = await rootBundle.load("assets/NeoSansArabic.ttf");
      List<int> fontBytes = fontData.buffer
          .asUint8List(fontData.offsetInBytes, fontData.lengthInBytes);
      await File(fontPath).writeAsBytes(fontBytes);

      var outputPath = join(directory.path, "output.mp4");
      var outpu1 = join(directory.path, "output1.mp4");
      String _loopVideo =
          '-stream_loop -1 -i $dbPath -i $soundPath -shortest -map 0:v:0 -map 1:a:0 -y $outputPath';

      String _addText =
          '-i $outputPath -vf "drawtext=fontfile=$fontPath:text=$text:fontcolor=white:fontsize=24:x=(w-text_w)/2:y=(h-text_h)/2, "drawtext=fontfile=$fontPath:text=$text:fontcolor=white:fontsize=24:x=(w-text_w+30)/2:y=(h-text_h)/2"" -codec:a copy $outpu1';

      _config.setFontDirectory(fontPath, null);

      _flutterFFmpeg
          .execute(_loopVideo)
          .then((value) => _flutterFFmpeg.execute(_addText).then(
                (value) =>
                    _controller = VideoPlayerController.file(File(outpu1))
                      ..initialize().then((_) {
                        setState(() {
                          _loading = false;
                        
                        });
                      })..play(),
              ));
    } catch (e) {
      print(e);
    }
  }
}
