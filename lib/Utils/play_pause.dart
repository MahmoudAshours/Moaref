import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayPauseButton extends StatefulWidget {
  PlayPauseButton({Key key, this.snapshot, this.index, this.s, this.provider})
      : super(key: key);
  final snapshot;
  final index;
  final s;
  final provider;
  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  final assetsAudioPlayer = AssetsAudioPlayer.withId('0');
  bool isPressed = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (c, prov, _) => FlatButton(
        child: PlayerBuilder.isPlaying(
          player: prov.assetsAudioPlayer,
          builder: (context, play) {
            return Icon(prov.boolList.isNotEmpty &&
                    prov.boolList[widget.index] == true &&
                    play
                ? Icons.pause
                : Icons.play_arrow);
          },
        ),
        onPressed: () {
          prov.fetchSoundData(widget.snapshot, widget.index);
          prov.assetsAudioPlayer.isPlaying.listen((event) {
            setState(() {
              isPressed = event;
            });
          });

          setState(
            () {
              if (!isPressed) {
                prov.playSoundData(widget.snapshot, widget.index);
                prov.assetsAudioPlayer.play();
              } else {
                if (prov.boolList.isNotEmpty && !prov.boolList[widget.index]) {
                  prov.assetsAudioPlayer.pause();
                } else {
                  prov.playSoundData(widget.snapshot, widget.index);
                }
              }
            },
          );
        },
      ),
    );
  }
}
