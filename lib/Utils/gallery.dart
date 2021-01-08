import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:ffmpegtest/Provider/gallery_provider.dart';
import 'package:ffmpegtest/Themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  GalleryProvider provider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<GalleryProvider>(context);
    provider.getGalleryImages();
    super.didChangeDependencies();
  }

  getThumbnails(videofile) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videofile,
      imageFormat: ImageFormat.JPEG,
      quality: 25,
    );
    return uint8list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height / 2.9,
          child: StreamBuilder(
            stream: provider.galleryLinks.stream,
            builder: (c, s) => !s.hasData
                ? Center(child: CircularProgressIndicator())
                : GridView.count(
                    crossAxisCount: 5,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    padding: EdgeInsets.all(8),
                    children: [
                      GestureDetector(
                        onTap: () => provider.uploadFile(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: kBackgroundIconColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.folder_open_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (provider.customWallpapers.isNotEmpty)
                        ...provider.customWallpapers.map<Widget>(
                          (e) {
                            return FutureBuilder(
                              future: getThumbnails(e),
                              builder: (c, s) => !s.hasData
                                  ? SizedBox()
                                  : FadeInUp(
                                      child: ClipRRect(
                                        child: Image.memory(
                                          s.data,
                                          fit: BoxFit.fill,
                                          gaplessPlayback: true,
                                          cacheHeight: 100,
                                          cacheWidth: 100,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                            );
                          },
                        ).toList(),
                      ...s.data
                          .map<Widget>(
                            (e) => FutureBuilder(
                              future: provider.checkIfExists(e),
                              builder: (context, snapshot) {
                                print(e);
                                print(snapshot.data);
                                return !snapshot.hasData
                                    ? SizedBox()
                                    : snapshot.data
                                        ? FadeInUp(
                                            child: ClipRRect(
                                              child: Image.network(
                                                "https://nekhtem.com/kariem/ayat/konMoarfaan/video_l/images/$e",
                                                fit: BoxFit.fill,
                                                gaplessPlayback: true,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent
                                                            loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes
                                                          : null,
                                                    ),
                                                  );
                                                },
                                                cacheHeight: 100,
                                                cacheWidth: 100,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          )
                                        : FadeInUp(
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                    sigmaX: 0.2,
                                                    sigmaY: 0.2,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.network(
                                                      "https://nekhtem.com/kariem/ayat/konMoarfaan/video_l/images/$e",
                                                      fit: BoxFit.fill,
                                                      filterQuality:
                                                          FilterQuality.low,
                                                      gaplessPlayback: true,
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    loadingProgress
                                                                        .expectedTotalBytes
                                                                : null,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: ()=>provider.downloadFile(e),
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
                              },
                            ),
                          )
                          .toList(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
