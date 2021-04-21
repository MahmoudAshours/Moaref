import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ffmpegtest/Models/sound_state.dart';
import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayPauseButton extends StatelessWidget {
  PlayPauseButton({Key key, this.snapshot, this.index, this.provider})
      : super(key: key);
  final snapshot;
  final index;
  final provider;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (c, prov, _) {
        return TextButton(
          child: PlayerBuilder.isPlaying(
            player: prov.assetsAudioPlayer,
            builder: (BuildContext context, bool play) {
              return Icon(prov.boolList.isNotEmpty &&
                      prov.boolList[index] == true &&
                      play
                  ? Icons.pause
                  : Icons.play_arrow);
            },
          ),
          onPressed: () {
            prov.fetchSoundData(snapshot, index);
            prov.assetsAudioPlayer.isPlaying.listen(
              (event) {
                if (event) {
                  prov.setSound = Sound.IsPlaying;
                } else {
                  prov.setSound = Sound.IsNotPlaying;
                }
              },
            );

            if (prov.sound == Sound.IsNotPlaying) {
              prov.playSoundData(snapshot, index);
            } else {
              if ((prov.boolList.isNotEmpty && !prov.boolList[index]) ||
                  prov.boolList.isEmpty) {
                prov.assetsAudioPlayer.stop();
                prov.nullifymp3();
              } else {
                prov.playSoundData(snapshot, index);
              }
            }
          },
        );
      },
    );
  }
}
