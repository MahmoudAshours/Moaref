import 'package:ffmpegtest/Helpers/asset_to_file.dart';
import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:ffmpegtest/Provider/record_provider.dart';
import 'package:ffmpegtest/Screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final splashVideo = await assetToFile(assetPath: 'assets/Videos/splash.mp4');
  runApp(MyApp(splashVideo));
}

class MyApp extends StatelessWidget {
  final splashVideo;
  MyApp(this.splashVideo);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => RecordProvider())
      ],
      child: MaterialApp(
        title: 'كن معرفا برسول الله ',
        home: SplashScreen(splashVideo),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'NeoSansArabic'),
      ),
    );
  }
}
