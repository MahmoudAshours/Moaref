import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:ffmpegtest/Provider/record_provider.dart';
import 'package:ffmpegtest/Themes/theme.dart';
import 'package:ffmpegtest/Utils/langs_categories.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

class Recording extends StatefulWidget {
  @override
  _RecordingState createState() => _RecordingState();
}

class _RecordingState extends State<Recording> {
  var path;

  @override
  Widget build(BuildContext context) {
    var dataProvider = Provider.of<DataProvider>(context);
    var soundProvider = Provider.of<RecordProvider>(context);

    return Column(
      children: [
        LangsCats(),
        SizedBox(height: 20),
        BounceInUp(
          duration: Duration(seconds: 1),
          child: Center(
            child: AvatarGlow(
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
                    onTap: () async {},
                    child: FaIcon(
                      FontAwesomeIcons.microphoneAlt,
                      color: Colors.white,
                    ),
                  ),
                  radius: 20.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        soundProvider.sounds == null || soundProvider.sounds.isEmpty
            ? Center(child: Text('هذه الخاصية تمكنك من تسجيل مقطع صوتي دعوي'))
            : Container(
                height: 400,
                child: SingleChildScrollView(
                  child: Column(
                    children: soundProvider.sounds
                        .map(
                          (e) => AudioWidget.file(
                            child: Container(
                              width: 200,
                              height: 200,
                              color: Colors.red,
                            ),
                            path: e,
                            play: true,
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
