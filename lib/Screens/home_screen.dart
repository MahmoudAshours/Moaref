import 'dart:math';
import 'package:chewie/chewie.dart';
import 'package:ffmpegtest/Helpers/static_assets_files.dart';
import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:ffmpegtest/Provider/gallery_provider.dart';
import 'package:ffmpegtest/Utils/Categories/category.dart';
import 'package:ffmpegtest/Utils/gallery.dart';
import 'package:ffmpegtest/Utils/Commons/play_settings.dart';
import 'package:ffmpegtest/Utils/recording.dart';
import 'package:ffmpegtest/Utils/upload_file.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  @override
  bool get wantKeepAlive => true;
  double height = 60;
  var currindex = 0;
  DataProvider _dataProvider;
  GalleryProvider _galleryProvider;

  Random rand = Random();
  var number;
  @override
  void initState() {
    number = rand.nextInt(3);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _dataProvider = Provider.of<DataProvider>(context);
    _galleryProvider = Provider.of<GalleryProvider>(context, listen: true);

    _dataProvider.initializePlayer(
        context,
        _galleryProvider.videoPath.isEmpty
            ? StaticAssets.bgVideos[number]
            : _galleryProvider.videoPath)
      ..then((value) => setState(() {}));

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _dataProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            _dataProvider.chewieController != null
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ChangeNotifierProvider<GalleryProvider>.value(
                      value: GalleryProvider()..videoPath,
                      child: Chewie(controller: _dataProvider.chewieController),
                    ),
                  )
                : SizedBox(),
            Positioned(
              top: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedCrossFade(
                  crossFadeState: _dataProvider.mp3Picked == null
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: Duration(seconds: 1),
                  firstChild: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    width: 240,
                    height: 40,
                    child: AnimatedDefaultTextStyle(
                      child: Text('${mp3Name()}'),
                      duration: Duration(seconds: 3),
                      style: TextStyle(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  secondChild: Container(
                    width: 240,
                    height: 40,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height / 8.2,
              child: PlaySettings(),
            ),
            DraggableScrollableSheet(
              minChildSize: 0.11,
              maxChildSize: 0.5,
              initialChildSize: 0.11,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  color: Colors.white,
                  child: Wrap(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        textDirection: TextDirection.rtl,
                        children: [
                          _bottomNavigationItemBuilder(
                              activeAssetPath: 'assets/Images/maedit.png',
                              nonActiveAssetPath: 'assets/Images/mdedit.png',
                              controller: scrollController,
                              label: 'التصنيف',
                              index: 0),
                          _bottomNavigationItemBuilder(
                              activeAssetPath: 'assets/Images/mamic.png',
                              nonActiveAssetPath: 'assets/Images/mdmic.png',
                              controller: scrollController,
                              label: 'تسجيل',
                              index: 1),
                          _bottomNavigationItemBuilder(
                              activeAssetPath: 'assets/Images/mabrush.png',
                              nonActiveAssetPath: 'assets/Images/mdbrush.png',
                              controller: scrollController,
                              label: 'ملف صوتي',
                              index: 2),
                          _bottomNavigationItemBuilder(
                              activeAssetPath: 'assets/Images/maphoto.png',
                              nonActiveAssetPath: 'assets/Images/mdphoto.png',
                              controller: scrollController,
                              label: 'المكتبة',
                              index: 3),
                        ],
                      ),
                      SafeArea(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: _itemsBody(),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  mp3Name() => _dataProvider.mp3Picked == null
      ? ''
      : _dataProvider.mp3Picked.contains('/')
          ? _dataProvider.mp3Picked.contains(RegExp("^[a-zA-Z0-9]*\$"))
              ? _dataProvider.mp3Picked.toString().split('/')[8]
              : Uri.decodeComponent(
                  _dataProvider.mp3Picked.toString().split('/')[8])
          : _dataProvider.mp3Picked;

  _itemsBody() {
    switch (currindex) {
      case 0:
        return Category();
        break;
      case 1:
        return Recording();
        break;
      case 2:
        return UploadFile();
        break;
      case 3:
        return Gallery();
        break;
      default:
        return CircularProgressIndicator();
    }
  }

  SingleChildScrollView _bottomNavigationItemBuilder(
      {String activeAssetPath,
      String nonActiveAssetPath,
      String label,
      ScrollController controller,
      int index}) {
    return SingleChildScrollView(
      controller: controller,
      child: GestureDetector(
        onTap: () => setState(() => currindex = index),
        child: Container(
          height: 80,
          child: Column(
            children: [
              AnimatedCrossFade(
                firstChild: Image.asset(
                  activeAssetPath,
                  width: 70,
                  height: 50,
                ),
                secondChild: Image.asset(
                  nonActiveAssetPath,
                  width: 70,
                  height: 50,
                ),
                duration: Duration(milliseconds: 700),
                crossFadeState: currindex == index
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
              Expanded(child: Text(label))
            ],
          ),
        ),
      ),
    );
  }
}
