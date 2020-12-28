import 'package:animate_do/animate_do.dart';
import 'package:ffmpegtest/Helpers/asset_to_file.dart';
import 'package:ffmpegtest/Themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  var imageMemory;
  @override
  void initState() {
    getThumbnails().then((value) => setState(() {
          imageMemory = value;
        }));
    super.initState();
  }

  getThumbnails() async {
    var videofile =
        await assetToFile(assetPath: 'assets/Videos/bg_video_mobile_1.mp4');
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
          child: GridView.count(
            crossAxisCount: 5,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            padding: EdgeInsets.all(8),
            children: [
              Container(
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
              FadeInUp(
                child: ClipRRect(
                  child: imageMemory == null
                      ? CircularProgressIndicator()
                      : Image.memory(
                          imageMemory,
                          fit: BoxFit.fill,
                          cacheHeight: 100,
                          cacheWidth: 100,
                        ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              Container(
                color: Colors.blue,
              ),
              Container(
                color: Colors.black,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
