import 'package:ffmpegtest/Helpers/asset_to_file.dart';
import 'package:ffmpegtest/Screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final splashVideo = await assetToFile(assetPath: 'assets/Videos/splash.mp4');
  runApp(MyApp(splashVideo));
}

class MyApp extends StatelessWidget {
  final splashVideo;
  MyApp(this.splashVideo);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'كن معرفا برسول الله ',
      home: SplashScreen(splashVideo),
      theme: ThemeData(fontFamily: 'NeoSansArabic'),
    );
  }
}
