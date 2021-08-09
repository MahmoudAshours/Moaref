import 'package:konmoaref/Provider/ffmpeg_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaySettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FfmpegProvider>(context);

    return Container(
      width: 190,
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () => provider.createFile('text'),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Image.asset('assets/Images/render.png'),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Image.asset('assets/Images/landscape.png'),
          ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Image.asset('assets/Images/portrait.png'),
          )
        ],
      ),
    );
  }
}
