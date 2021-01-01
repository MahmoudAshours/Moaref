import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayPauseButton extends StatefulWidget {
  PlayPauseButton({this.snapshot, this.index});
  final snapshot;
  final index;
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
        child: Icon(!isPressed ? Icons.pause : Icons.play_arrow),
        onPressed: () {
          var language = Uri.encodeComponent(prov.lang);
          var cat = Uri.encodeComponent(prov.category);
          var url =
              "https://nekhtem.com/kariem/ayat/konMoarfaan/$language/$cat/${widget.snapshot.data[widget.index]}";
          var x = assetsAudioPlayer.isPlaying.value;

          setState(() {
            isPressed = x;
            if (!x) {
              assetsAudioPlayer.open(Audio.network(url));
              assetsAudioPlayer.play();
              isPressed = x;
            } else {
              assetsAudioPlayer.pause();
              isPressed = x;
            }
          });
        },
      ),
    );
  }
}
