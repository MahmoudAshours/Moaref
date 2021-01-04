import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:ffmpegtest/Themes/theme.dart';
import 'package:ffmpegtest/Utils/langs_categories.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:record/record.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Recording extends StatefulWidget {
  @override
  _RecordingState createState() => _RecordingState();
}

class _RecordingState extends State<Recording> {
  var path;

  @override
  Widget build(BuildContext context) {
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
                    onTap: () async {
                      await Record.hasPermission();
                      Directory directory = await getTemporaryDirectory();
                      path = join(directory.path, 'recz.m4a');
                      print(path);
                      await Record.start(
                        path: '$path', // required
                        encoder: AudioEncoder.AAC, // by default
                      );
                    },
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
        RaisedButton(onPressed: () async {
          Record.stop()
              .then((value) => Future.delayed(Duration(seconds: 5), () {
                    setState(() {});
                  }));
        }),
        SizedBox(height: 20),
        Center(child: Text('هذه الخاصية تمكنك من تسجيل مقطع صوتي دعوي')),
        path != null
            ? AudioWidget.file(
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.red,
                ),
                path: path,
                play: true,
              )
            : SizedBox()
      ],
    );
  }
}
