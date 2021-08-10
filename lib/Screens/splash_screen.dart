import 'dart:io';

import 'package:konmoaref/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen(this.videoPath);
  final String videoPath;
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _videoPlayerController1;
  ChewieController? _chewieController;
  @override
  void initState() {
    initializePlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _chewieController != null
          ? Chewie(controller: _chewieController!)
          : SizedBox(),
    );
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 =
        VideoPlayerController.file(File(widget.videoPath));
    await _videoPlayerController1.initialize();

    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        autoPlay: true,
        autoInitialize: true,
        showControls: false,
        allowFullScreen: true,
        aspectRatio: MediaQuery.of(context).size.aspectRatio);
    setState(() {});
    _videoPlayerController1.addListener(() {
      if (_videoPlayerController1.value.position ==
          _videoPlayerController1.value.duration) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    });
  }
}
