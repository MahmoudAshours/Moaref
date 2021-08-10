import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:konmoaref/Provider/record_provider.dart';
import 'package:konmoaref/Themes/theme.dart';
import 'package:provider/provider.dart';

class RecordingImage extends StatelessWidget {
  const RecordingImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final soundProvider = Provider.of<RecordProvider>(context);
    return soundProvider.recording
        ? AvatarGlow(
            glowColor: Colors.orange,
            endRadius: 190.0,
            duration: Duration(milliseconds: 2000),
            repeat: true,
            showTwoGlows: true,
            repeatPauseDuration: Duration(milliseconds: 100),
            child: Material(
              elevation: 18.0,
              shape: CircleBorder(),
              child: CircleAvatar(
                backgroundColor: kSecondaryColor,
                child: GestureDetector(
                  onTap: () => soundProvider.endRecord(),
                  child: Image.asset('assets/Images/record.png'),
                ),
                radius: 140.0,
              ),
            ),
          )
        : CircleAvatar(
            backgroundColor: kSecondaryColor,
            child: GestureDetector(
              onTap: () async => await soundProvider.recordSound(),
              child: Image.asset('assets/Images/record.png'),
            ),
            radius: 140.0,
          );
  }
}
