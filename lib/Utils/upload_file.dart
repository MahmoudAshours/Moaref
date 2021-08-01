import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ffmpegtest/Models/sound_state.dart';
import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:ffmpegtest/Provider/upload_provider.dart';
import 'package:ffmpegtest/Utils/Commons/langs_categories.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:ffmpegtest/Helpers/map_indexed.dart';

class UploadFile extends StatefulWidget {
  @override
  _UploadFileState createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  late DataProvider dataProvider;
  late UploadProvider uploadProvider;
  @override
  void didChangeDependencies() {
    dataProvider = Provider.of<DataProvider>(context);
    uploadProvider = Provider.of<UploadProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    uploadProvider.assetsAudioPlayer
        .stop()
        .then((value) => dataProvider.nullifymp3());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LangsCats(),
        SizedBox(height: 20),
        FadeInUp(
          duration: Duration(milliseconds: 500),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: ElevatedButton(
                onPressed: () {
                  uploadProvider.uploadFile(context);
                },
                child: Text('إضافة ملف صوتي',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ),
        SizedBox(height: 7),
        uploadProvider.sounds == null ||
                uploadProvider.sounds.isEmpty ||
                uploadProvider.boolList.isEmpty
            ? Center(
                child: Text(
                'هذه الخاصية تمكنك من إضافة مقطع صوتي لاستخرجه كمقطع دعوي',
                textAlign: TextAlign.center,
              ))
            : Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: uploadProvider.sounds
                        .mapIndexed(
                          (e, i) => FadeInUp(
                            delay: Duration(milliseconds: 20 * i),
                            child: ListTile(
                              trailing: Text('${e.toString().split('/')[7]}'),
                              leading: TextButton(
                                child: PlayerBuilder.isPlaying(
                                  player: uploadProvider.assetsAudioPlayer,
                                  builder: (BuildContext context, bool play) {
                                    return Icon(
                                        uploadProvider.boolList.isNotEmpty &&
                                                uploadProvider.boolList[i] ==
                                                    true &&
                                                play
                                            ? Icons.pause
                                            : Icons.play_arrow);
                                  },
                                ),
                                onPressed: () {
                                  uploadProvider.fetchSoundData(i);
                                  uploadProvider.assetsAudioPlayer.isPlaying
                                      .listen(
                                    (event) {
                                      if (event) {
                                        print(event);
                                        uploadProvider.setSound =
                                            Sound.IsPlaying;
                                      } else {
                                        uploadProvider.setSound =
                                            Sound.IsNotPlaying;
                                      }
                                    },
                                  );

                                  if (uploadProvider.sound ==
                                      Sound.IsNotPlaying) {
                                    uploadProvider.playSoundData(i);
                                    dataProvider.setMp3(
                                        '${e.toString().split('/')[7]}');
                                  } else {
                                    if ((uploadProvider.boolList.isNotEmpty &&
                                            !uploadProvider.boolList[i]) ||
                                        uploadProvider.boolList.isEmpty) {
                                      uploadProvider.assetsAudioPlayer.stop();
                                      dataProvider.nullifymp3();
                                    } else {
                                      uploadProvider.playSoundData(i);
                                      dataProvider.setMp3(
                                          '${e.toString().split('/')[7]}');
                                    }
                                  }
                                },
                              ),
                              subtitle: uploadProvider.boolList.isNotEmpty &&
                                      uploadProvider.boolList[i] == true
                                  ? PlayerBuilder.realtimePlayingInfos(
                                      player: uploadProvider.assetsAudioPlayer,
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
              )
      ],
    );
  }
}
