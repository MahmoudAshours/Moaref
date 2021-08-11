import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:konmoaref/Provider/data_provider.dart';
import 'package:konmoaref/Provider/ffmpeg_provider.dart';
import 'package:konmoaref/Provider/gallery_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';

class FFmpegOperations extends StatefulWidget {
  final text;
  FFmpegOperations(this.text);
  @override
  _FFmpegOperationsState createState() => _FFmpegOperationsState();
}

class _FFmpegOperationsState extends State<FFmpegOperations> {
  // late VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    print(widget.text);
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
        onPressed: () => _ffmpegProvider.createFile(
            'text', _dataProvider.cloudAudioPicked, _galleryProvider.videoPath),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
  // Future _createFile(String text) async {
  //   try {
  //     var appDir = (await getApplicationDocumentsDirectory()).path;
  //     Directory(appDir).delete(recursive: true);
  //     final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  //     final FlutterFFmpegConfig _config = FlutterFFmpegConfig();
  //     Directory directory = await getApplicationDocumentsDirectory();

  //     var dbPath = join(directory.path, "input.mp4");
  //     ByteData data = await rootBundle.load("assets/input.mp4");
  //     List<int> bytes =
  //         data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  //     await File(dbPath).writeAsBytes(bytes);

  //     var soundPath = join(directory.path, "input.mp3");
  //     ByteData soundData = await rootBundle.load("assets/input.mp3");
  //     List<int> soundBytes = soundData.buffer
  //         .asUint8List(soundData.offsetInBytes, soundData.lengthInBytes);
  //     await File(soundPath).writeAsBytes(soundBytes);

  //     var fontPath = join(directory.path, "arabic.ttf");
  //     ByteData fontData = await rootBundle.load("assets/NeoSansArabic.ttf");
  //     List<int> fontBytes = fontData.buffer
  //         .asUint8List(fontData.offsetInBytes, fontData.lengthInBytes);
  //     await File(fontPath).writeAsBytes(fontBytes);

  //     var outputPath = join(directory.path, "output.mp4");
  //     var outpu1 = join(directory.path, "output1.mp4");
  //     String _loopVideo =
  //         '-stream_loop -1 -i $dbPath -i $soundPath -shortest -map 0:v:0 -map 1:a:0 -y $outputPath';

  //     String _addText =
  //         '-i $outputPath -vf "drawtext=fontfile=$fontPath:text=$text:fontcolor=white:fontsize=24:x=(w-text_w)/2:y=(h-text_h)/2, "drawtext=fontfile=$fontPath:text=$text:fontcolor=white:fontsize=24:x=(w-text_w+30)/2:y=(h-text_h)/2"" -codec:a copy $outpu1';

  //     _config.setFontDirectory(fontPath, null);

  // _flutterFFmpeg
  //     .execute(_loopVideo)
  //     .then((value) => _flutterFFmpeg.execute(_addText).then(
  //           (value) =>
  //               _controller = VideoPlayerController.file(File(outpu1))
  //                 ..initialize().then((_) {
  //                   setState(() {
  //                     _loading = false;
  //                   });
  //                 })
  //                 ..play(),
  //         ));
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
