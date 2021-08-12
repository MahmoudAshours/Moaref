import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:konmoaref/Provider/data_provider.dart';
import 'package:konmoaref/Provider/ffmpeg_provider.dart';
import 'package:konmoaref/Provider/gallery_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class FFmpegOperations extends StatefulWidget {
  final text;
  FFmpegOperations(this.text);
  @override
  _FFmpegOperationsState createState() => _FFmpegOperationsState();
}

class _FFmpegOperationsState extends State<FFmpegOperations> {
  @override
  Widget build(BuildContext context) {
    final _galleryProvider = Provider.of<GalleryProvider>(context);
    final _ffmpegProvider = Provider.of<FfmpegProvider>(context);
    final _dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.network(
            "https://nekhtem.com/kariem/ayat/konMoarfaan/video_l/images/${basename(_galleryProvider.videoPath!.replaceAll('mp4', 'jpg'))}",
            fit: BoxFit.cover,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _ffmpegProvider.startRendering(
            'text', _dataProvider.cloudAudioPicked, _galleryProvider.videoPath),
      ),
    );
  }
}
