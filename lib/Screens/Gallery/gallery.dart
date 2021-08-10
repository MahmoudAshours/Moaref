import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:konmoaref/Provider/gallery_provider.dart';
import 'package:konmoaref/Screens/Gallery/blurred_image.dart';
import 'package:konmoaref/Screens/Gallery/custom_imageloader.dart';
import 'package:konmoaref/Screens/Gallery/loaded_image.dart';
import 'package:konmoaref/Screens/Gallery/upload_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late GalleryProvider provider;
  late VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.file(File(''));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<GalleryProvider>(context);
    provider.getGalleryImages();
    super.didChangeDependencies();
  }

  Future<Uint8List>? _getThumbnails(String videofile) async {
    final _videoUint8list = await VideoThumbnail.thumbnailData(
      video: videofile,
      imageFormat: ImageFormat.JPEG,
      quality: 10,
    );
    return _videoUint8list!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff5E713B),
        toolbarHeight: 30,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff5E713B),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'المكتبة',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: 250,
            ),
          ),
          Positioned(
            top: 80,
            left: 50,
            height: 170,
            width: MediaQuery.of(context).size.width / 1.4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: provider.videoPath.isNotEmpty
                  ? VideoPlayer(_videoPlayerController)
                  : Container(
                      color: Colors.transparent,
                      width: 100,
                      height: 100,
                    ),
            ),
          ),
          Positioned(
            top: 260,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 300,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: provider.galleryLinks.stream,
                  builder: (c, AsyncSnapshot galleryStream) => !galleryStream
                          .hasData
                      ? Center(child: CircularProgressIndicator())
                      : GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          padding: EdgeInsets.all(8),
                          children: [
                            UploadVideo(),
                            if (provider.customWallpapers.isNotEmpty)
                              ...provider.customWallpapers.map<Widget>(
                                (String element) {
                                  return FutureBuilder(
                                    future: _getThumbnails(element),
                                    builder: (_,
                                            AsyncSnapshot<Uint8List>
                                                customImagesFuture) =>
                                        !customImagesFuture.hasData
                                            ? SizedBox()
                                            : CustomImageLoader(
                                                customImagesFuture:
                                                    customImagesFuture),
                                  );
                                },
                              ).toList(),
                            ...galleryStream.data
                                .map<Widget>((String element) => FutureBuilder(
                                      future:
                                          provider.checkIfVideoExists(element),
                                      builder: (context,
                                          AsyncSnapshot<bool>? snapshot) {
                                        return !snapshot!.hasData
                                            ? SizedBox()
                                            : snapshot.data!
                                                ? FadeInUp(
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        await provider
                                                            .setVideoPath(
                                                                element);
                                                        await _initalizeNewVideo();
                                                        //01007814655
                                                      },
                                                      child: ClipRRect(
                                                        child: LoadedImage(
                                                            path: element),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
                                                  )
                                                : BlurredLoadingImage(
                                                    path: element);
                                      },
                                    ))
                                .toList(),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _initalizeNewVideo() async {
    _videoPlayerController =
        VideoPlayerController.file(File(provider.videoPath));
    await _videoPlayerController.initialize();
    _videoPlayerController.play();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}
