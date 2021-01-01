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
  bool ispresed = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    assetsAudioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (c, prov, _) => FlatButton(
        child: Icon(ispresed ? Icons.pause : Icons.play_arrow),
        onPressed: () {
          var language = Uri.encodeComponent(prov.lang);
          var cat = Uri.encodeComponent(prov.category);
          var url =
              "https://nekhtem.com/kariem/ayat/konMoarfaan/$language/$cat/${widget.snapshot.data[widget.index]}";
          assetsAudioPlayer.open(Audio.network(url));
          setState(() {
            print(ispresed);
            if (ispresed == false) {
              assetsAudioPlayer.play();
              ispresed = true;
            } else if (ispresed == false) {
              assetsAudioPlayer.pause();
              ispresed = false;
            }
          });
        },
      ),
    );
  }
}
