import 'dart:typed_data';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:konmoaref/Helpers/dialog.dart';
import 'package:konmoaref/Provider/gallery_provider.dart';
import 'package:konmoaref/Screens/Gallery/blurred_image.dart';
import 'package:konmoaref/Screens/Gallery/custom_imageloader.dart';
import 'package:konmoaref/Screens/Gallery/loaded_image.dart';
import 'package:konmoaref/Screens/Gallery/upload_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:konmoaref/Utils/spinner.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MacGallery extends StatefulWidget {
  final String audioPath;

  const MacGallery({Key? key, required this.audioPath}) : super(key: key);
  @override
  _MacGalleryState createState() => _MacGalleryState();
}

class _MacGalleryState extends State<MacGallery> {
  late GalleryProvider _provider;

  @override
  void didChangeDependencies() {
    _provider = Provider.of<GalleryProvider>(context);
    _provider.getGalleryImages();
    super.didChangeDependencies();
  }

  Future<Uint8List?>? _getThumbnails(String videofile) async {
    return VideoThumbnail.thumbnailData(
      video: videofile,
      imageFormat: ImageFormat.JPEG,
      quality: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _provider.videoPath.isNotEmpty
          ? FloatingActionButton.extended(
              label: Text('أنشئ المقطع'),
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (_) => CustomizedDialog(audioPicked: widget.audioPath),
              ),
            )
          : SizedBox(),
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
              height: 200,
            ),
          ),
          Positioned(
            top: 210,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 300,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: _provider.galleryLinks.stream,
                  builder: (c, AsyncSnapshot galleryStream) => !galleryStream
                          .hasData
                      ? Center(child: Spinner())
                      : GridView.count(
                          crossAxisCount:
                              (MediaQuery.of(context).size.width / 100).ceil(),
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          padding: EdgeInsets.all(8),
                          children: [
                            UploadVideo(),
                            if (_provider.customWallpapers.isNotEmpty)
                              ..._provider.customWallpapers.map<Widget>(
                                (String element) {
                                  return FutureBuilder(
                                    future: _getThumbnails(element),
                                    builder: (_,
                                            AsyncSnapshot<Uint8List?>?
                                                customImagesFuture) =>
                                        !customImagesFuture!.hasData
                                            ? SizedBox()
                                            : GestureDetector(
                                                onTap: () async =>
                                                    await _provider
                                                        .setVideoPath(element,
                                                            isUploaded: true),
                                                child: CustomImageLoader(
                                                    customImagesFuture:
                                                        customImagesFuture),
                                              ),
                                  );
                                },
                              ).toList(),
                            ...galleryStream.data
                                .map<Widget>(
                                  (String element) => FutureBuilder(
                                    future:
                                        _provider.checkIfVideoExists(element),
                                    builder: (context,
                                        AsyncSnapshot<bool>? snapshot) {
                                      return !snapshot!.hasData
                                          ? SizedBox()
                                          : snapshot.data!
                                              ? FadeInUp(
                                                  child: GestureDetector(
                                                    onTap: () async =>
                                                        await _provider
                                                            .setVideoPath(
                                                                element),
                                                    child: ClipRRect(
                                                      child: LoadedImage(
                                                          path: element),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                )
                                              : BlurredLoadingImage(
                                                  path: element);
                                    },
                                  ),
                                )
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
}
