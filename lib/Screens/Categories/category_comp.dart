import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:konmoaref/Provider/data_provider.dart';
import 'package:konmoaref/Screens/Categories/play_pause.dart';
import 'package:flutter/material.dart';

class CategoryComponent extends StatefulWidget {
  final DataProvider provider;
  final int index;
  final AsyncSnapshot<List<String?>> snapshot;
  final String title;

  const CategoryComponent(
      {Key? key,
      required this.provider,
      required this.index,
      required this.title,
      required this.snapshot})
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
          delay: Duration(milliseconds: 20 * widget.index),
          child: ListTile(
            trailing: CircleAvatar(
              backgroundColor: Color(0xff364122),
              child: PlayPauseButton(
                snapshot: widget.snapshot,
                index: widget.index,
                provider: widget.provider,
              ),
            ),
            subtitle: widget.provider.cloudAudioPlayingBool.isNotEmpty &&
                    widget.provider.cloudAudioPlayingBool[widget.index] == true
                ? PlayerBuilder.realtimePlayingInfos(
                    player: widget.provider.assetsAudioPlayer,
                    builder: (context, RealtimePlayingInfos? realTimeInfo) {
                      return realTimeInfo != null
                          ? PlayTimeDisplayed(
                              realtimePlayingInfos: realTimeInfo)
                          : SizedBox();
                    },
                  )
                : SizedBox(),
            title: AudioTitle(title: widget.title),
          ),
        ),
      ),
    );
  }
}

class AudioTitle extends StatelessWidget {
  final String title;

  const AudioTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toString().replaceAll('.mp3', ''),
      style: TextStyle(color: Color(0xff364122), fontWeight: FontWeight.w600),
      textDirection: TextDirection.rtl,
    );
  }
}

class PlayTimeDisplayed extends StatelessWidget {
  final RealtimePlayingInfos realtimePlayingInfos;
  const PlayTimeDisplayed({
    Key? key,
    required this.realtimePlayingInfos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "${realtimePlayingInfos.currentPosition.inSeconds} : ${realtimePlayingInfos.currentPosition.inMinutes} -- ${realtimePlayingInfos.duration.inSeconds} : ${realtimePlayingInfos.duration.inMinutes}",
        textDirection: TextDirection.rtl,
        style: TextStyle(color: Color(0xffC19C42), fontWeight: FontWeight.w800),
      ),
    );
  }
}
