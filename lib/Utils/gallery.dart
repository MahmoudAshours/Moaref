import 'package:animate_do/animate_do.dart';
import 'package:ffmpegtest/Provider/gallery_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                    children: s.data
                        .map<Widget>(
                          (e) => FadeInUp(
                            child: ClipRRect(
                              child: Image.network(
                                "https://nekhtem.com/kariem/ayat/konMoarfaan/video_l/images/$e",
                                fit: BoxFit.fill,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                  );
                                },
                                cacheHeight: 100,
                                cacheWidth: 100,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ),
      ),
    );
  }
}
