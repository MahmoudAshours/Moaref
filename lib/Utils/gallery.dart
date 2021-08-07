import 'dart:io';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:ffmpegtest/Provider/gallery_provider.dart';
import 'package:ffmpegtest/Themes/theme.dart';
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

  _getThumbnails(videofile) async {
    final _videoUint8list = await VideoThumbnail.thumbnailData(
      video: videofile,
      imageFormat: ImageFormat.JPEG,
      quality: 25,
    );
    return _videoUint8list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            top: 100,
            left: 50,
            height: 170,
            width: MediaQuery.of(context).size.width / 1.3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: provider.videoPath != null
                  ? _loadedImage(provider.videoPath)
                  : Container(
                      color: Colors.transparent,
                      width: 100,
                      height: 100,
                    ),
            ),
          ),
          Positioned(
            top: 280,
            height: MediaQuery.of(context).size.height * 2,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 2,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: provider.galleryLinks.stream,
                  builder: (cxt, AsyncSnapshot galleryStream) =>
                      !galleryStream.hasData
                          ? Center(child: CircularProgressIndicator())
                          : _videosGridView(cxt, galleryStream),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GridView _videosGridView(
      BuildContext context, AsyncSnapshot<dynamic> galleryStream) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      padding: EdgeInsets.all(8),
      children: [
        _uploadVideoButton(context),
        if (provider.customWallpapers.isNotEmpty)
          ...provider.customWallpapers.map<Widget>(
            (element) {
              return FutureBuilder(
                future: _getThumbnails(element),
                builder: (_, AsyncSnapshot customImagesFuture) =>
                    !customImagesFuture.hasData
                        ? SizedBox()
                        : _customImageLoader(customImagesFuture),
              );
            },
          ).toList(),
        ...galleryStream.data
            .map<Widget>((element) => _videosLoader(element))
            .toList(),
      ],
    );
  }

  FadeInUp _customImageLoader(AsyncSnapshot<dynamic> customImagesFuture) {
    return FadeInUp(
      child: ClipRRect(
        child: Image.memory(
          customImagesFuture.data,
          fit: BoxFit.fill,
          gaplessPlayback: true,
          cacheHeight: 100,
          cacheWidth: 100,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  FutureBuilder<bool> _videosLoader(video) {
    return FutureBuilder(
      future: provider.checkIfVideoExists(video),
      builder: (context, AsyncSnapshot snapshot) {
        return !snapshot.hasData
            ? SizedBox()
            : snapshot.data
                ? FadeInUp(
                    child: GestureDetector(
                      onTap: () async {
                        await provider.setVideoPath(video);
                      },
                      child: ClipRRect(
                        child: _loadedImage(video),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  )
                : _blurredLoadingImage(video);
      },
    );
  }

  Image _loadedImage(e) {
    return Image.network(
      "https://nekhtem.com/kariem/ayat/konMoarfaan/video_l/images/$e",
      fit: BoxFit.fill,
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

  // _initalizeNewVideo() async {
  //   _videoPlayerController.pause();
  //   _videoPlayerController =
  //       VideoPlayerController.file(File(provider.videoPath));
  //   await _videoPlayerController.initialize();
  //   _videoPlayerController.play();
  // }

  FadeInUp _blurredLoadingImage(e) {
    return FadeInUp(
      child: Stack(
        fit: StackFit.expand,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 0.2,
              sigmaY: 0.2,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                "https://nekhtem.com/kariem/ayat/konMoarfaan/video_l/images/$e",
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
            onTap: () => provider.downloadFile(e),
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

  GestureDetector _uploadVideoButton(BuildContext context) {
    return GestureDetector(
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
    );
  }
}
