import 'package:chewie/chewie.dart';
import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:ffmpegtest/Utils/category.dart';
import 'package:ffmpegtest/Utils/gallery.dart';
import 'package:ffmpegtest/Utils/play_settings.dart';
import 'package:ffmpegtest/Utils/recording.dart';
import 'package:ffmpegtest/Utils/upload_file.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double height = 60;
  var currindex = 0;
  VideoPlayerController _videoPlayerController1;
  DataProvider _dataProvider;

  ChewieController _chewieController;
  final _assetsList = List.unmodifiable([
    'assets/Videos/bg_video_mobile_1.mp4',
    'assets/Videos/bg_video_mobile_2.mp4',
    'assets/Videos/bg_video_mobile_3.mp4',
    'assets/Videos/bg_video_mobile_4.mp4',
    'assets/Videos/bg_video_mobile_5.mp4',
  ]);

  @override
  void initState() {
    super.initState();
    this.initializePlayer(1);
  }

  @override
  void didChangeDependencies() {
    _dataProvider = Provider.of<DataProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _dataProvider.dispose();
    super.dispose();
  }

  Future<void> initializePlayer(index) async {
    final video = _assetsList[index];
    _videoPlayerController1 = VideoPlayerController.asset(video);
    await _videoPlayerController1.initialize();

    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        autoPlay: true,
        looping: true,
        autoInitialize: true,
        showControls: false,
        allowFullScreen: true,
        aspectRatio: MediaQuery.of(context).size.aspectRatio);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Chewie(controller: _chewieController),
          ),
          Consumer<DataProvider>(
            builder: (_, prov, __) => Positioned(
              top: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedCrossFade(
                  crossFadeState: prov.mp3Picked == null
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
                      child: Text(
                          '${prov.mp3Picked == null ? '' : prov.mp3Picked.toString().split('/')[8]}'),
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
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 8.2,
            child: PlaySettings(),
          ),
          DraggableScrollableSheet(
            minChildSize: 0.11,
            maxChildSize: 0.5,
            initialChildSize: 0.11,
            builder: (BuildContext context, ScrollController scrollController) {
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
    );
  }

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
