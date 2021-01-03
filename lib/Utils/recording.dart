import 'package:animate_do/animate_do.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:ffmpegtest/Themes/theme.dart';
import 'package:ffmpegtest/Utils/langs_categories.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Recording extends StatelessWidget {
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
                  child: FaIcon(
                    FontAwesomeIcons.microphoneAlt,
                    color: Colors.white,
                  ),
                  radius: 20.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Center(child: Text('هذه الخاصية تمكنك من تسجيل مقطع صوتي دعوي'))
      ],
    );
  }
}
