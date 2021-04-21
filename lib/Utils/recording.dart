import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:ffmpegtest/Models/sound_state.dart';
import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:ffmpegtest/Provider/record_provider.dart';
import 'package:ffmpegtest/Themes/theme.dart';
import 'package:ffmpegtest/Utils/Commons/langs_categories.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ffmpegtest/Helpers/map_indexed.dart';

class Recording extends StatefulWidget {
  @override
  _RecordingState createState() => _RecordingState();
}

class _RecordingState extends State<Recording> {
  DataProvider dataProvider;
  RecordProvider soundProvider;

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
    soundProvider.isRecording();
    return Column(
      children: [
        LangsCats(),
        SizedBox(height: 20),
        BounceInUp(
          duration: Duration(seconds: 1),
          child: Center(
            child: soundProvider.recording
                ? AvatarGlow(
                    glowColor: Colors.orange,
                    endRadius: 40.0,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: Material(
                      elevation: 8.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: kSecondaryColor,
                        child: GestureDetector(
                          onTap: () => soundProvider.endRecord(),
                          child: FaIcon(
                            FontAwesomeIcons.microphoneAlt,
                            color: Colors.white,
                          ),
                        ),
                        radius: 20.0,
                      ),
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: kSecondaryColor,
                    child: GestureDetector(
                      onTap: () async => await soundProvider.recordSound(),
                      child: FaIcon(
                        FontAwesomeIcons.microphoneAlt,
                        color: Colors.white,
                      ),
                    ),
                    radius: 20.0,
                  ),
          ),
        ),
        SizedBox(height: 20),
        soundProvider.sounds == null ||
                soundProvider.sounds.isEmpty ||
                soundProvider.boolList.isEmpty
            ? Center(child: Text('هذه الخاصية تمكنك من تسجيل مقطع صوتي دعوي'))
            : Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: soundProvider.sounds
                        .mapIndexed(
                          (e, i) => FadeInUp(
                            delay: Duration(milliseconds: 20 * i),
                            child: ListTile(
                              trailing: Text('${i + 1} تسجيل '),
                              leading: TextButton(
                                child: PlayerBuilder.isPlaying(
                                  player: soundProvider.assetsAudioPlayer,
                                  builder: (BuildContext context, bool play) {
                                    return Icon(soundProvider
                                                .boolList.isNotEmpty &&
                                            soundProvider.boolList[i] == true &&
                                            play
                                        ? Icons.pause
                                        : Icons.play_arrow);
                                  },
                                ),
                                onPressed: () {
                                  soundProvider.fetchSoundData(i);
                                  soundProvider.assetsAudioPlayer.isPlaying
                                      .listen(
                                    (event) {
                                      if (event) {
                                        print(event);
                                        soundProvider.setSound =
                                            Sound.IsPlaying;
                                      } else {
                                        soundProvider.setSound =
                                            Sound.IsNotPlaying;
                                      }
                                    },
                                  );

                                  if (soundProvider.sound ==
                                      Sound.IsNotPlaying) {
                                    soundProvider.playSoundData(i);
                                    dataProvider.setMp3('${i + 1} تسجيل ');
                                  } else {
                                    if ((soundProvider.boolList.isNotEmpty &&
                                            !soundProvider.boolList[i]) ||
                                        soundProvider.boolList.isEmpty) {
                                      soundProvider.assetsAudioPlayer.stop();
                                      dataProvider.nullifymp3();
                                    } else {
                                      soundProvider.playSoundData(i);
                                      dataProvider.setMp3('${i + 1} تسجيل ');
                                    }
                                  }
                                },
                              ),
                              subtitle: soundProvider.boolList.isNotEmpty &&
                                      soundProvider.boolList[i] == true
                                  ? PlayerBuilder.realtimePlayingInfos(
                                      player: soundProvider.assetsAudioPlayer,
                                      builder: (context, realTimeInfo) {
                                        return realTimeInfo != null
                                            ? Text(
                                                "${realTimeInfo.currentPosition.inMinutes}:${realTimeInfo.currentPosition.inSeconds} -- ${realTimeInfo.duration.inMinutes} : ${realTimeInfo.duration.inSeconds}")
                                            : SizedBox();
                                      },
                                    )
                                  : SizedBox(),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
      ],
    );
  }
}
