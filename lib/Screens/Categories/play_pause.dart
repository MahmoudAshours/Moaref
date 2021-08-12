import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:konmoaref/Helpers/get_audioname.dart';
import 'package:konmoaref/Models/sound_state.dart';
import 'package:konmoaref/Provider/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayPauseButton extends StatefulWidget {
  PlayPauseButton(
      {Key? key, required this.snapshot, required this.index, this.provider})
      : super(key: key);
  final AsyncSnapshot<List<String?>> snapshot;
  final int index;
  final provider;

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  @override
  Widget build(BuildContext context) {
    final _dataProvider = Provider.of<DataProvider>(context);
    return TextButton(
      child: PlayerBuilder.isPlaying(
        player: _dataProvider.assetsAudioPlayer,
        builder: (BuildContext context, bool play) {
          return Icon(
            _dataProvider.boolList.isNotEmpty &&
                    _dataProvider.boolList[widget.index] == true &&
                    play
                ? Icons.pause
                : Icons.play_arrow,
            color: Colors.white,
          );
        },
      ),
      onPressed: () async {
        _dataProvider.fetchSoundData(widget.snapshot, widget.index);
        setState(() {});
        _dataProvider.assetsAudioPlayer.isPlaying.listen(
          (soundEvent) {
            if (soundEvent) {
              _dataProvider.setSound = Sound.IsPlaying;
            } else {
              _dataProvider.setSound = Sound.IsNotPlaying;
            }
          },
        );

        if (_dataProvider.sound == Sound.IsNotPlaying) {
          await _dataProvider.playSoundData(widget.snapshot, widget.index);
          Fluttertoast.showToast(
              msg:
                  "تم اختيار \n${FormattedAudioName.cloudAudioName(_dataProvider.cloudAudioPicked)}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.orange,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          if ((_dataProvider.boolList.isNotEmpty &&
                  !_dataProvider.boolList[widget.index]) ||
              _dataProvider.boolList.isEmpty) {
            _dataProvider.assetsAudioPlayer.stop();
            _dataProvider.nullifymp3();
          } else {
            _dataProvider.playSoundData(widget.snapshot, widget.index);
            Fluttertoast.showToast(
                msg:
                    "تم اختيار \n${FormattedAudioName.cloudAudioName(_dataProvider.cloudAudioPicked)}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.orange,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      },
    );
  }
}
