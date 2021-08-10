import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:konmoaref/Models/sound_state.dart';
import 'package:konmoaref/Provider/data_provider.dart';
import 'package:konmoaref/Provider/upload_provider.dart';
import 'package:konmoaref/Utils/langs_categories.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:konmoaref/Helpers/map_indexed.dart';

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
    return Scaffold(
      backgroundColor: Color(0xffD9DED5),
      body: SafeArea(
        child: Column(
          children: [
            LanguagesDropDownList(),
            SizedBox(height: 20),
            Image.asset('assets/Images/upload_media.png'),
            SizedBox(height: 7),
            uploadProvider.sounds == null ||
                    uploadProvider.sounds!.isEmpty ||
                    uploadProvider.uploadedAudioIsPlaying.isEmpty
                ? Center(
                    child: Text(
                      'هذه الخاصية تمكنك من إضافة مقطع صوتي لاستخرجه كمقطع دعوي',
                      textAlign: TextAlign.center,
                    ),
                  )
                : Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        children: uploadProvider.sounds!
                            .mapIndexed(
                              (e, i) => FadeInUp(
                                delay: Duration(milliseconds: 20 * i),
                                child: ListTile(
                                  trailing:
                                      Text('${e.toString().split('/')[7]}'),
                                  leading: TextButton(
                                    child: PlayerBuilder.isPlaying(
                                      player: uploadProvider.assetsAudioPlayer,
                                      builder:
                                          (BuildContext context, bool play) {
                                        return Icon(uploadProvider
                                                    .uploadedAudioIsPlaying
                                                    .isNotEmpty &&
                                                uploadProvider
                                                            .uploadedAudioIsPlaying[
                                                        i] ==
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
                                        if ((uploadProvider
                                                    .uploadedAudioIsPlaying
                                                    .isNotEmpty &&
                                                !uploadProvider
                                                        .uploadedAudioIsPlaying[
                                                    i]) ||
                                            uploadProvider
                                                .uploadedAudioIsPlaying
                                                .isEmpty) {
                                          uploadProvider.assetsAudioPlayer
                                              .stop();
                                          dataProvider.nullifymp3();
                                        } else {
                                          uploadProvider.playSoundData(i);
                                          dataProvider.setMp3(
                                              '${e.toString().split('/')[7]}');
                                        }
                                      }
                                    },
                                  ),
                                  subtitle: uploadProvider
                                              .uploadedAudioIsPlaying
                                              .isNotEmpty &&
                                          uploadProvider
                                                  .uploadedAudioIsPlaying[i] ==
                                              true
                                      ? PlayerBuilder.realtimePlayingInfos(
                                          player:
                                              uploadProvider.assetsAudioPlayer,
                                          builder: (context,
                                              RealtimePlayingInfos?
                                                  realTimeInfo) {
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
            _uploadAudioButton(context),
          ],
        ),
      ),
    );
  }

  FadeInUp _uploadAudioButton(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: 500),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.3,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xff364122)),
            ),
            onPressed: () => uploadProvider.uploadFile(context),
            child: Text(
              'إضافة ملف صوتي',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
