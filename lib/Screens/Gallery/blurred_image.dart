import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
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
    return Container(
      width: 100,
      height: 100,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl:
                  "https://nekhtem.com/kariem/ayat/konMoarfaan/video_l/images/$path",
              fit: BoxFit.fill,
              filterQuality: FilterQuality.none,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Container(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
              errorWidget: (context, url, error) => Icon(Icons.error),
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
      ),
    );
  }
}
