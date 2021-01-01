import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ffmpegtest/Themes/theme.dart';
import 'package:ffmpegtest/Utils/play_pause.dart';
import 'package:flutter/material.dart';

class CategoryComponent extends StatelessWidget {
  final provider;
  final i;
  final snapshot;
  final e;

  const CategoryComponent(
      {Key key, this.provider, this.i, this.e, this.snapshot})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: FadeInUp(
          delay: Duration(milliseconds: 20 * i),
          child: ListTile(
            leading: PlayPauseButton(
              snapshot: snapshot,
              index: i,
              key: ValueKey('$i'),
            ),
            subtitle: PlayerBuilder.isPlaying(
              player: provider.assetsAudioPlayer,
              builder: (context, duration) {
                return Text("$duration");
              },
            ),
            title: Text(
              e.toString().replaceAll('.mp3', ''),
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
