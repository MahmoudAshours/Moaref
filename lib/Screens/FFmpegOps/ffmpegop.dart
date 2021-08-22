import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konmoaref/Helpers/get_audioname.dart';
import 'package:konmoaref/Provider/data_provider.dart';
import 'package:konmoaref/Provider/ffmpeg_provider.dart';
import 'package:konmoaref/Provider/gallery_provider.dart';
import 'package:konmoaref/Provider/record_provider.dart';
import 'package:konmoaref/Provider/upload_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FFmpegOperations extends StatefulWidget {
  @override
  _FFmpegOperationsState createState() => _FFmpegOperationsState();
}

class _FFmpegOperationsState extends State<FFmpegOperations> {
  String _audioPicked = "";
  String _orientationPicked = "mobile";
  @override
  Widget build(BuildContext context) {
    final _galleryProvider = Provider.of<GalleryProvider>(context);
    final _ffmpegProvider = Provider.of<FfmpegProvider>(context);
    final _dataProvider = Provider.of<DataProvider>(context);
    final _recordProvider = Provider.of<RecordProvider>(context);
    final _uploadProvider = Provider.of<UploadProvider>(context);
    final _sheikhNameTextEditingController = TextEditingController();
    final _categoryTextEditingController = TextEditingController();
    final _videoNameTextEditingController = TextEditingController();
    return Scaffold(
      bottomSheet: Container(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('اختر مقطعك'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (_recordProvider.recordPath!.isNotEmpty)
                  AudioChecked(
                    onItemPressed: (audio) {
                      setState(() => _audioPicked = audio);
                    },
                    audioPicked: _audioPicked,
                    iconAudio: _recordProvider.recordPath!,
                    icon: FaIcon(FontAwesomeIcons.microphoneAlt),
                  ),
                if (_uploadProvider.uploadedAudioPath!.isNotEmpty)
                  AudioChecked(
                    onItemPressed: (audio) {
                      print(audio);
                      setState(() => _audioPicked = audio);
                    },
                    audioPicked: _audioPicked,
                    iconAudio: _uploadProvider.uploadedAudioPath!,
                    icon: FaIcon(FontAwesomeIcons.upload),
                  ),
                if (_dataProvider.cloudAudioPicked != null &&
                    _dataProvider.cloudAudioPicked!.isNotEmpty)
                  AudioChecked(
                    audioPicked: _audioPicked,
                    onItemPressed: (audio) {
                      setState(() => _audioPicked = audio);
                    },
                    iconAudio: _dataProvider.cloudAudioPicked!,
                    icon: FaIcon(FontAwesomeIcons.fileAudio),
                  )
              ],
            ),
          ],
        ),
        color: Colors.white,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                progressIndicatorBuilder: (BuildContext context, String url,
                        DownloadProgress downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, String url, error) => Icon(Icons.error),
                imageUrl:
                    "https://nekhtem.com/kariem/ayat/konMoarfaan/video_l/images/${basename(_galleryProvider.videoPath!.replaceAll('mp4', 'jpg'))}",
                fit: BoxFit.cover,
              ),
              MobileChecked(
                orientaitonPicked: _orientationPicked,
                onItemPressed: (or) {
                  setState(() {
                    _orientationPicked = or;
                  });
                },
              ),
              OrientationChecked(
                orientaitonPicked: _orientationPicked,
                onItemPressed: (or) {
                  setState(() {
                    _orientationPicked = or;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: FaIcon(FontAwesomeIcons.play),
        onPressed: () {
          if (_audioPicked != _dataProvider.cloudAudioPicked) {
            showDialog(
              context: context,
              useSafeArea: true,
              builder: (_) => Dialog(
                child: Material(
                  type: MaterialType.transparency,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextField(
                        controller: _videoNameTextEditingController,
                        decoration: InputDecoration(
                            hintText: 'اسم المقطع',
                            hintTextDirection: TextDirection.rtl,
                            hintStyle: TextStyle(color: Colors.green)),
                      ),
                      TextField(
                        controller: _sheikhNameTextEditingController,
                        decoration: InputDecoration(
                            hintText: 'اسم الشيخ',
                            hintTextDirection: TextDirection.rtl,
                            hintStyle: TextStyle(color: Colors.green)),
                      ),
                      TextField(
                        controller: _categoryTextEditingController,
                        decoration: InputDecoration(
                            hintText: 'نوع المقطع',
                            hintTextDirection: TextDirection.rtl,
                            hintStyle: TextStyle(color: Colors.green)),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _ffmpegProvider.startRendering(
                              [
                                _videoNameTextEditingController.text,
                                _categoryTextEditingController.text,
                                _sheikhNameTextEditingController.text
                              ],
                              _audioPicked,
                              _galleryProvider.videoPath,
                              context,
                              _dataProvider.lang,
                              _orientationPicked,
                            );
                          },
                          child: Text('OK'))
                    ],
                  ),
                ),
              ),
            );
          } else {
            _ffmpegProvider.startRendering(
              [
                '${FormattedAudioName.cloudAudioName(_dataProvider.cloudAudioPicked)}',
                '${FormattedAudioName.cloudAudioCategory(_dataProvider.cloudAudioPicked)}',
              ],
              _audioPicked,
              _galleryProvider.videoPath,
              context,
              _dataProvider.lang,
              _orientationPicked,
            );
          }
        },
      ),
    );
  }
}

class OrientationChecked extends StatelessWidget {
  final String orientaitonPicked;

  final ValueChanged<String> onItemPressed;

  const OrientationChecked(
      {Key? key, required this.orientaitonPicked, required this.onItemPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: key,
      onTap: () {
        onItemPressed('tablet');
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Stack(
            children: [
              CircleAvatar(
                child: FaIcon(
                  FontAwesomeIcons.tablet,
                  color: Colors.white,
                ),
              ),
              orientaitonPicked == 'tablet'
                  ? FaIcon(
                      FontAwesomeIcons.solidCheckCircle,
                      color: Colors.green,
                      size: 15,
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileChecked extends StatelessWidget {
  final String orientaitonPicked;
  final ValueChanged<String> onItemPressed;

  const MobileChecked(
      {Key? key, required this.orientaitonPicked, required this.onItemPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: key,
      onTap: () {
        onItemPressed('mobile');
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Stack(
            children: [
              CircleAvatar(
                child: FaIcon(
                  FontAwesomeIcons.mobile,
                  color: Colors.white,
                ),
              ),
              orientaitonPicked == 'mobile'
                  ? FaIcon(
                      FontAwesomeIcons.solidCheckCircle,
                      color: Colors.green,
                      size: 15,
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class AudioChecked extends StatefulWidget {
  final String audioPicked;
  final String iconAudio;
  final FaIcon icon;
  final ValueChanged<String> onItemPressed;

  const AudioChecked(
      {Key? key,
      required this.audioPicked,
      required this.iconAudio,
      required this.icon,
      required this.onItemPressed})
      : super(key: key);

  @override
  _AudioCheckedState createState() => _AudioCheckedState();
}

class _AudioCheckedState extends State<AudioChecked> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onItemPressed(widget.iconAudio),
      child: CircleAvatar(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Align(alignment: Alignment.center, child: widget.icon),
            Align(
              alignment: Alignment.bottomRight,
              child: widget.audioPicked == widget.iconAudio
                  ? FaIcon(
                      FontAwesomeIcons.solidCheckCircle,
                      color: Colors.green,
                      size: 15,
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
