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
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  VideoPlayerController _controller;

  @override
  void initState() {
    _createFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.initialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  Future _createFile() async {
    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

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

    var outputPath = join(directory.path, "output.mp4");

    _flutterFFmpeg
        .execute(
            "-i $dbPath -i $soundPath -c copy -map 0:v:0 -map 1:a:0 $outputPath")
        .then((rc) => print("FFmpeg process exited with rc $rc"));

    _controller = VideoPlayerController.file(File(outputPath))
      ..initialize().then((_) {
        setState(() {});
      });
  }
}
