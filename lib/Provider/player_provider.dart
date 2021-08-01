import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerProvider extends ChangeNotifier {
  late VideoPlayerController _videoPlayerController1;
  ChewieController? chewieController;

  Future<void> initializePlayer(BuildContext context, String video) async {
    if (video.contains('assets')) {
      _videoPlayerController1 = VideoPlayerController.asset(video);
    } else {
      _videoPlayerController1 = VideoPlayerController.file(File(video));
    }
    try {
      await _videoPlayerController1.initialize();
      Future.delayed(Duration(seconds:1),(){});
    } catch (e) {
    }
    chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        autoPlay: true,
        looping: true,
        showControls: false,
        allowMuting: true,
        allowedScreenSleep: true,
        autoInitialize: true,
        allowFullScreen: true,
        aspectRatio: MediaQuery.of(context).size.aspectRatio);
  }
}
