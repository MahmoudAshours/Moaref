import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class RenderedVideoPreview extends StatefulWidget {
  final String videoPath;
  const RenderedVideoPreview({Key? key, required this.videoPath})
      : super(key: key);

  @override
  _RenderedVideoPreviewState createState() => _RenderedVideoPreviewState();
}

class _RenderedVideoPreviewState extends State<RenderedVideoPreview> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  void initState() {
    _initializeVideo().then(
      (value) => _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
        autoInitialize: true,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.videoPath.isNotEmpty && _chewieController != null
          ? Stack(
              children: [
                Chewie(controller: _chewieController!),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: GestureDetector(
                    onTap: () => Share.shareFiles(['${widget.videoPath}']),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CircleAvatar(
                        child: Icon(Icons.share),
                      ),
                    ),
                  ),
                )
              ],
            )
          : Container(
              color: Colors.transparent,
              width: 100,
              height: 100,
            ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    _videoPlayerController.pause();
    await _videoPlayerController.dispose();
    _chewieController!.dispose();
  }

  Future _initializeVideo() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.videoPath));
    await _videoPlayerController.initialize();
    setState(() {});
  }
}
