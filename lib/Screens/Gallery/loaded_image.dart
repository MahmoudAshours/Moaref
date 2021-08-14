import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LoadedImage extends StatelessWidget {
  final String path;
  const LoadedImage({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
          child: Container(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(
          value: downloadProgress.progress,
        ),
      )),
      errorWidget: (context, url, error) => Icon(Icons.error),
      imageUrl:
          "https://nekhtem.com/kariem/ayat/konMoarfaan/video_l/images/$path",
      fit: BoxFit.fill,
      filterQuality: FilterQuality.none,
    );
  }
}
