import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:konmoaref/Provider/record_provider.dart';
import 'package:provider/provider.dart';

class RecordingInfo extends StatelessWidget {
  const RecordingInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _recordProvider = Provider.of<RecordProvider>(context);
    return PlayerBuilder.realtimePlayingInfos(
      player: _recordProvider.assetsAudioPlayer,
      builder: (context, RealtimePlayingInfos? realTimeInfo) {
        return realTimeInfo != null
            ? Text(
                "${realTimeInfo.currentPosition.inMinutes}:${realTimeInfo.currentPosition.inSeconds} -- ${realTimeInfo.duration.inMinutes} : ${realTimeInfo.duration.inSeconds}")
            : SizedBox();
      },
    );
  }
}
