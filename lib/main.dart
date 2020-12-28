import 'package:ffmpegtest/Provider/search_provider.dart';
import 'package:ffmpegtest/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SearchProvider())],
      child: MaterialApp(
        title: 'كن معرفا برسول الله ',
        home: HomeScreen(),
        theme: ThemeData(fontFamily: 'NeoSansArabic'),
      ),
    );
  }
}
