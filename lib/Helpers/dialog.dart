import 'dart:io';

import 'package:flutter/material.dart';
import 'package:konmoaref/Helpers/get_audioname.dart';
import 'package:konmoaref/Provider/MacosProvider/ffmpeg_macprovider.dart';
import 'package:konmoaref/Provider/data_provider.dart';
import 'package:konmoaref/Provider/ffmpeg_provider.dart';
import 'package:konmoaref/Provider/gallery_provider.dart';
import 'package:konmoaref/Provider/orientation_provider.dart';
import 'package:provider/provider.dart';

class CustomizedDialog extends StatefulWidget {
  final String audioPicked;

  const CustomizedDialog({Key? key, required this.audioPicked})
      : super(key: key);
  @override
  _CustomizedDialogState createState() => _CustomizedDialogState();
}

class _CustomizedDialogState extends State<CustomizedDialog> {
  OrientationProvider? _orientation;

  @override
  void didChangeDependencies() {
    _orientation = Provider.of<OrientationProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _orientation!.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: dialogContent(context, _orientation!),
    );
  }

  Widget dialogContent(BuildContext context, OrientationProvider orientation) {
    return Stack(
      children: <Widget>[
        Align(
            alignment: Alignment.centerRight,
            child: card(context, orientation)),
      ],
    );
  }

  Widget card(BuildContext context, OrientationProvider orientation) {
    return Container(
      padding: EdgeInsets.only(
        top: Consts.avatarRadius + Consts.padding,
        right: Consts.padding,
      ),
      child: orientation.getIndex == 0
          ? OrientationPickerColumn(audioPicked: widget.audioPicked)
          : GeneratedVideoInformation(
              orientationPicked: orientation.getOrientation,
              audioPicked: widget.audioPicked),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

class GeneratedVideoInformation extends StatefulWidget {
  final String orientationPicked;
  final String audioPicked;

  GeneratedVideoInformation(
      {Key? key, required this.orientationPicked, required this.audioPicked})
      : super(key: key);

  @override
  _GeneratedVideoInformationState createState() =>
      _GeneratedVideoInformationState();
}

class _GeneratedVideoInformationState extends State<GeneratedVideoInformation> {
  final _sheikhNameTextEditingController = TextEditingController();

  final _categoryTextEditingController = TextEditingController();

  final _videoNameTextEditingController = TextEditingController();

  var _ffmpegProvider;
  @override
  void didChangeDependencies() {
    _ffmpegProvider = Platform.isMacOS
        ? Provider.of<FFmpegMacProvider>(context)
        : Provider.of<FfmpegProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _galleryProvider = Provider.of<GalleryProvider>(context);

    final _dataProvider = Provider.of<DataProvider>(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        physics: ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
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
                    widget.audioPicked,
                    _galleryProvider.videoPath,
                    context,
                    _dataProvider.lang,
                    widget.orientationPicked,
                  );
                  Platform.isMacOS ? DoNothingAction() : showProgress(context);
                },
                child: Text('أنشئ')),
          ],
        ),
      ),
    );
  }
}

class OrientationPickerColumn extends StatefulWidget {
  final String audioPicked;
  const OrientationPickerColumn({Key? key, required this.audioPicked})
      : super(key: key);

  @override
  _OrientationPickerColumnState createState() =>
      _OrientationPickerColumnState();
}

class _OrientationPickerColumnState extends State<OrientationPickerColumn> {
  var _ffmpegProvider;

  @override
  void didChangeDependencies() {
    _ffmpegProvider = Platform.isMacOS
        ? Provider.of<FFmpegMacProvider>(context)
        : Provider.of<FfmpegProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<OrientationProvider>(context);
    final _dataProvider = Provider.of<DataProvider>(context);

    final _galleryProvider = Provider.of<GalleryProvider>(context);

    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              'اختر نوع الفيديو',
              style: TextStyle(fontSize: 24, color: Colors.green[800]),
            ),
          ),
        ),
        OrientationChecked(
          orientationIcon: 'mobile',
          onItemPressed: (orientationPicked) =>
              _provider.orientation = orientationPicked,
          orientaitonPicked: _provider.getOrientation,
        ),
        SizedBox(height: 16.0),
        OrientationChecked(
          orientationIcon: 'tablet',
          onItemPressed: (orientationPicked) =>
              _provider.orientation = orientationPicked,
          orientaitonPicked: _provider.getOrientation,
        ),
        SizedBox(height: 24.0),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            onPressed: () {
              if (widget.audioPicked == _dataProvider.cloudAudioPicked) {
                _ffmpegProvider.startRendering(
                  [
                    '${FormattedAudioName.cloudAudioName(_dataProvider.cloudAudioPicked)}',
                    '${FormattedAudioName.cloudAudioCategory(_dataProvider.cloudAudioPicked)}',
                  ],
                  widget.audioPicked,
                  _galleryProvider.videoPath,
                  context,
                  _dataProvider.lang,
                  _provider.getOrientation,
                );
                Platform.isMacOS ? DoNothingAction() : showProgress(context);
              } else
                _provider.pageIndex = 1;
            },
            child: Text('أكمل'),
          ),
        ),
      ],
    );
  }
}

showProgress(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => StatefulBuilder(
      builder: (c, setStater) {
        final _ffmpegProvider = Provider.of<FfmpegProvider>(c);

        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('جاري العمل على المقطع'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.green),
                    value:
                        double.parse('${_ffmpegProvider.percentage / 100.0}')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _ffmpegProvider.cancelOperation();
                    },
                    child: Text('أغلق')),
              )
            ],
          ),
        );
      },
    ),
  );
}

class OrientationChecked extends StatelessWidget {
  final String orientaitonPicked;
  final String orientationIcon;
  final ValueChanged<String> onItemPressed;

  const OrientationChecked(
      {Key? key,
      required this.orientaitonPicked,
      required this.onItemPressed,
      required this.orientationIcon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onItemPressed(orientationIcon),
        child: ListTile(
          title: Text(
            orientationIcon == "tablet" ? 'مقطع عرضي' : 'مقطع طولي',
            textDirection: TextDirection.rtl,
          ),
          trailing: CircleAvatar(
              radius: 20,
              backgroundColor: orientaitonPicked == orientationIcon
                  ? Colors.red
                  : Colors.transparent,
              child: orientationIcon == "tablet"
                  ? Image.asset('assets/Images/landscape.png')
                  : Image.asset('assets/Images/portrait.png')),
        ));
  }
}
