import 'package:flutter/material.dart';

class LoadedImage extends StatelessWidget {
  final String path;
  const LoadedImage({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      "https://nekhtem.com/kariem/ayat/konMoarfaan/video_l/images/$path",
      fit: BoxFit.fill,
      filterQuality: FilterQuality.none,
      gaplessPlayback: true,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      cacheHeight: 100,
      cacheWidth: 100,
    );
  }
}
