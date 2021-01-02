import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:ffmpegtest/Themes/theme.dart';
import 'package:ffmpegtest/Utils/play_pause.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryComponent extends StatefulWidget {
  final provider;
  final i;
  final snapshot; 
  final e;

  const CategoryComponent(
      {Key key, this.provider, this.i, this.e, this.snapshot })
      : super(key: key);

  @override
  _CategoryComponentState createState() => _CategoryComponentState();
}

class _CategoryComponentState extends State<CategoryComponent> {
  DataProvider _dataProvider;

  @override
  void didChangeDependencies() {
    _dataProvider = Provider.of<DataProvider>(context, listen: false);
    super.didChangeDependencies();
  }
@override
  void dispose() {
    _dataProvider.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: FadeInUp(
          delay: Duration(milliseconds: 20 * widget.i),
          child: ListTile(
            leading: PlayPauseButton(
              snapshot: widget.snapshot,
              index: widget.i,
              provider: widget.provider,
            ),
            subtitle: !widget.provider.boolList.isEmpty &&
                    widget.provider.boolList[widget.i] == true
                ? PlayerBuilder.realtimePlayingInfos(
                    player: widget.provider.assetsAudioPlayer,
                    builder: (context, realTimeInfo) {
                      return realTimeInfo != null
                          ? Text(
                              "${realTimeInfo.currentPosition.inMinutes}:${realTimeInfo.currentPosition.inSeconds} -- ${realTimeInfo.duration.inMinutes} : ${realTimeInfo.duration.inSeconds}")
                          : SizedBox();
                    },
                  )
                : SizedBox(),
            title: Text(
              widget.e.toString().replaceAll('.mp3', ''),
              style: TextStyle(
                  color: kSecondaryFontColor, fontWeight: FontWeight.w600),
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
      ),
    );
  }
}
