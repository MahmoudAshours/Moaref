import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:konmoaref/Provider/gallery_provider.dart';
import 'package:konmoaref/Utils/downloading_progress.dart';
import 'package:provider/provider.dart';

class BlurredLoadingImage extends StatelessWidget {
  final String path;
  const BlurredLoadingImage({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GalleryProvider>(context);

    return Stack(
      fit: StackFit.passthrough,
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 0.2,
            sigmaY: 0.2,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              "https://nekhtem.com/kariem/ayat/konMoarfaan/video_l/images/$path",
              fit: BoxFit.fill,
              filterQuality: FilterQuality.low,
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
            ),
          ),
        ),
        GestureDetector(
          onTap: () => {
            showDownloadDialog(context),
            provider
                .downloadFile(path)
                .then((value) => Navigator.of(context).pop()),
          },
          child: Center(
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.download_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
