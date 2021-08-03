import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:ffmpegtest/Provider/gallery_provider.dart';
import 'package:ffmpegtest/Provider/player_provider.dart';
import 'package:ffmpegtest/Screens/Categories/category_screen.dart';
import 'package:ffmpegtest/Themes/theme.dart';
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

  late DataProvider _dataProvider;
  late GalleryProvider _galleryProvider;
  late PlayerProvider _playerProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    _dataProvider = Provider.of<DataProvider>(context, listen: true);
    _galleryProvider = Provider.of<GalleryProvider>(context, listen: true);
    _playerProvider = Provider.of<PlayerProvider>(context, listen: true);

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
        backgroundColor: kPrimaryColor,
        body: Stack(
          children: [
            Opacity(
              opacity: 0.4,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                    image: AssetImage(
                      'assets/Images/zakhrafa.png',
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/Images/logo.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 4,
              left: MediaQuery.of(context).size.width / 4.8,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 1.5,
                child: GridView.count(
                  crossAxisSpacing: 30,
                  crossAxisCount: 2,
                  mainAxisSpacing: 30,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => Recording())),
                      child: _gridViewItems(
                        activeAssetPath: 'assets/Images/mic.png',
                        label: 'تسجيل',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => CategoryScreen())),
                      child: _gridViewItems(
                        activeAssetPath: 'assets/Images/category_icon.png',
                        label: 'التصنيف',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => UploadFile())),
                      child: _gridViewItems(
                        activeAssetPath: 'assets/Images/upload_file.png',
                        label: 'ملف صوتي',
                      ),
                    ),
                    _gridViewItems(
                      activeAssetPath: 'assets/Images/video_library.png',
                      label: 'المكتبة',
                    ),
                    _gridViewItems(
                      activeAssetPath: 'assets/Images/information_button.png',
                      label: 'عن التطبيق',
                    ),
                    _gridViewItems(
                      activeAssetPath: 'assets/Images/smartphone_icon.png',
                      label: 'عن التطبيق',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  mp3Name() => _dataProvider.mp3Picked == null
      ? ''
      : _dataProvider.mp3Picked!.contains('/')
          ? _dataProvider.mp3Picked!.contains(RegExp("^[a-zA-Z0-9]*\$"))
              ? _dataProvider.mp3Picked.toString().split('/')[8]
              : Uri.decodeComponent(
                  _dataProvider.mp3Picked.toString().split('/')[8])
          : _dataProvider.mp3Picked;

  Container _gridViewItems(
      {required String activeAssetPath, required String label}) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff364122),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xffF4D04C),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            activeAssetPath,
            width: 70,
            alignment: Alignment.center,
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
