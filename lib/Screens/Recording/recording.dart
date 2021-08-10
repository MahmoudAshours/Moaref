import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:konmoaref/Models/sound_state.dart';
import 'package:konmoaref/Provider/data_provider.dart';
import 'package:konmoaref/Provider/record_provider.dart';
import 'package:konmoaref/Screens/Recording/recording_widget.dart';
import 'package:konmoaref/Utils/langs_categories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:konmoaref/Helpers/map_indexed.dart';

class Recording extends StatefulWidget {
  @override
  _RecordingState createState() => _RecordingState();
}

class _RecordingState extends State<Recording> {
  late DataProvider dataProvider;
  late RecordProvider soundProvider;

  @override
  void didChangeDependencies() {
    dataProvider = Provider.of<DataProvider>(context);
    soundProvider = Provider.of<RecordProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    soundProvider.assetsAudioPlayer
        .stop()
        .then((value) => dataProvider.nullifymp3());
  }

  @override
  Widget build(BuildContext context) {
    soundProvider.isRecordingListener();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 30,
        actionsIconTheme: IconThemeData(color: Colors.black),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              LanguagesDropDownList(),
              SizedBox(height: 20),
              BounceInUp(
                duration: Duration(seconds: 1),
                child: Center(child: RecordingImage()),
              ),
              SizedBox(height: 20),
              soundProvider.recordedFilePaths == null ||
                      soundProvider.recordedFilePaths!.isEmpty ||
                      soundProvider.playingBoolList.isEmpty
                  ? Center(
                      child: Text('هذه الخاصية تمكنك من تسجيل مقطع صوتي دعوي'))
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: soundProvider.recordedFilePaths!
                            .mapIndexed((e, index) => _recordTile(index))
                            .toList(),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  FadeInUp _recordTile(int i) {
    return FadeInUp(
      delay: Duration(milliseconds: 20 * i),
      child: ListTile(
        trailing: Text('${i + 1} تسجيل '),
        leading: TextButton(
          child: PlayerBuilder.isPlaying(
            player: soundProvider.assetsAudioPlayer,
            builder: (BuildContext context, bool play) {
              return Icon(soundProvider.playingBoolList.isNotEmpty &&
                      soundProvider.playingBoolList[i] == true &&
                      play
                  ? Icons.pause
                  : Icons.play_arrow);
            },
          ),
          onPressed: () {
            soundProvider.fetchSoundData(i);
            soundProvider.assetsAudioPlayer.isPlaying.listen(
              (audioEvent) {
                if (audioEvent) {
                  soundProvider.setSound = Sound.IsPlaying;
                } else {
                  soundProvider.setSound = Sound.IsNotPlaying;
                }
              },
            );

            if (soundProvider.sound == Sound.IsNotPlaying) {
              soundProvider.playSoundData(i);
              dataProvider.setMp3('${i + 1} تسجيل ');
            } else {
              if ((soundProvider.playingBoolList.isNotEmpty &&
                      !soundProvider.playingBoolList[i]) ||
                  soundProvider.playingBoolList.isEmpty) {
                soundProvider.assetsAudioPlayer.stop();
                dataProvider.nullifymp3();
              } else {
                soundProvider.playSoundData(i);
                dataProvider.setMp3('${i + 1} تسجيل ');
              }
            }
          },
        ),
        subtitle: soundProvider.playingBoolList.isNotEmpty &&
                soundProvider.playingBoolList[i] == true
            ? _recordingInfo()
            : SizedBox(),
      ),
    );
  }

  PlayerBuilder _recordingInfo() {
    return PlayerBuilder.realtimePlayingInfos(
      player: soundProvider.assetsAudioPlayer,
      builder: (context, RealtimePlayingInfos? realTimeInfo) {
        return realTimeInfo != null
            ? Text(
                "${realTimeInfo.currentPosition.inMinutes}:${realTimeInfo.currentPosition.inSeconds} -- ${realTimeInfo.duration.inMinutes} : ${realTimeInfo.duration.inSeconds}")
            : SizedBox();
      },
    );
  }
}
