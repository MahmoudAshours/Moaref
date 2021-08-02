import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ffmpegtest/Screens/Categories/play_pause.dart';
import 'package:flutter/material.dart';

class CategoryComponent extends StatefulWidget {
  final provider;
  final i;
  final snapshot;
  final e;

  const CategoryComponent(
      {Key? key, this.provider, this.i, this.e, this.snapshot})
      : super(key: key);

  @override
  _CategoryComponentState createState() => _CategoryComponentState();
}

class _CategoryComponentState extends State<CategoryComponent> {
  @override
  void dispose() {
    super.dispose();
    widget.provider.assetsAudioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: FadeInUp(
          delay: Duration(milliseconds: 20 * widget.i as int),
          child: ListTile(
            trailing: CircleAvatar(
              backgroundColor: Color(0xff364122),
              child: PlayPauseButton(
                snapshot: widget.snapshot,
                index: widget.i,
                provider: widget.provider,
              ),
            ),
            subtitle: !widget.provider.boolList.isEmpty &&
                    widget.provider.boolList[widget.i] == true
                ? PlayerBuilder.realtimePlayingInfos(
                    player: widget.provider.assetsAudioPlayer,
                    builder: (context, RealtimePlayingInfos? realTimeInfo) {
                      return realTimeInfo != null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${realTimeInfo.currentPosition.inSeconds} : ${realTimeInfo.currentPosition.inMinutes} -- ${realTimeInfo.duration.inSeconds} : ${realTimeInfo.duration.inMinutes}",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: Color(0xffC19C42),
                                    fontWeight: FontWeight.w800),
                              ),
                            )
                          : SizedBox();
                    },
                  )
                : SizedBox(),
            title: Text(
              widget.e.toString().replaceAll('.mp3', ''),
              style: TextStyle(
                  color: Color(0xff364122), fontWeight: FontWeight.w600),
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
      ),
    );
  }
}
