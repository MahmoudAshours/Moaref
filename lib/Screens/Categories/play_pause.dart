import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:konmoaref/Models/sound_state.dart';
import 'package:konmoaref/Provider/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayPauseButton extends StatefulWidget {
  PlayPauseButton({Key? key, this.snapshot, this.index, this.provider})
      : super(key: key);
  final snapshot;
  final index;
  final provider;

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (c, prov, _) {
        return TextButton(
          child: PlayerBuilder.isPlaying(
            player: prov.assetsAudioPlayer,
            builder: (BuildContext context, bool play) {
              return Icon(
                prov.boolList.isNotEmpty &&
                        prov.boolList[widget.index] == true &&
                        play
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
              );
            },
          ),
          onPressed: () {
            prov.fetchSoundData(widget.snapshot, widget.index);
            setState(() {});
            prov.assetsAudioPlayer.isPlaying.listen(
              (soundEvent) {
                if (soundEvent) {
                  prov.setSound = Sound.IsPlaying;
                } else {
                  prov.setSound = Sound.IsNotPlaying;
                }
              },
            );

            if (prov.sound == Sound.IsNotPlaying) {
              prov.playSoundData(widget.snapshot, widget.index);
            } else {
              if ((prov.boolList.isNotEmpty && !prov.boolList[widget.index]) ||
                  prov.boolList.isEmpty) {
                prov.assetsAudioPlayer.stop();
                prov.nullifymp3();
              } else {
                prov.playSoundData(widget.snapshot, widget.index);
              }
            }
          },
        );
      },
    );
  }
}
