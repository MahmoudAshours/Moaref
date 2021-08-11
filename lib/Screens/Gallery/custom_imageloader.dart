import 'dart:typed_data';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class CustomImageLoader extends StatelessWidget {
  final AsyncSnapshot<Uint8List?> customImagesFuture;
  const CustomImageLoader({Key? key, required this.customImagesFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: ClipRRect(
        child: Image.memory(
          customImagesFuture.data!,
          fit: BoxFit.fill,
          gaplessPlayback: true,
          cacheHeight: 100,
          cacheWidth: 100,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
