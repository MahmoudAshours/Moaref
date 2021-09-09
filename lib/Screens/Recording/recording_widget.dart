import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konmoaref/Provider/record_provider.dart';
import 'package:konmoaref/Themes/theme.dart';
import 'package:provider/provider.dart';

class RecordingImage extends StatelessWidget {
  const RecordingImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final soundProvider = Provider.of<RecordProvider>(context);

    soundProvider.isRecordingListener();
    return soundProvider.recording
        ? GestureDetector(
            onTap: () => soundProvider.endRecord(),
            child: Center(
              child: AvatarGlow(
                glowColor: Colors.orange,
                endRadius: 100.0,
                duration: Duration(milliseconds: 2000),
                repeat: true,
                showTwoGlows: true,
                repeatPauseDuration: Duration(milliseconds: 100),
                child: Material(
                  elevation: 18.0,
                  shape: CircleBorder(),
                  child: CircleAvatar(
                    backgroundColor: kSecondaryColor,
                    child: FaIcon(FontAwesomeIcons.stop,
                        size: 40, color: Colors.red),
                    radius: 80.0,
                  ),
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () async => await soundProvider.recordSound(),
            child: Center(
              child: CircleAvatar(
                backgroundColor: kSecondaryColor,
                child: FaIcon(
                  FontAwesomeIcons.microphoneAlt,
                  size: 40,
                ),
                radius: 80.0,
              ),
            ),
          );
  }
}
