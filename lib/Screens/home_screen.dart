import 'dart:io';

import 'package:konmoaref/Screens/AudioUpload/upload_file.dart';
import 'package:konmoaref/Screens/Categories/category_screen.dart';
import 'package:konmoaref/Screens/Recording/recording.dart';
import 'package:konmoaref/Themes/theme.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double ready = 0;

  @override
  Widget build(BuildContext context) {
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
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: Platform.isMacOS
                      ? GridView.count(
                          crossAxisSpacing:
                              MediaQuery.of(context).size.width / 8,
                          crossAxisCount: 2,
                          mainAxisSpacing: 40,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => CategoryScreen())),
                                child: _gridViewItems(
                                  activeAssetPath:
                                      'assets/Images/category_icon.png',
                                  label: 'التصنيف',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => UploadFile())),
                                child: _gridViewItems(
                                  activeAssetPath:
                                      'assets/Images/upload_file.png',
                                  label: 'ملف صوتي',
                                ),
                              )
                            ])
                      : GridView.count(
                          crossAxisSpacing:
                              MediaQuery.of(context).size.width / 7,
                          crossAxisCount: 2,
                          mainAxisSpacing: 30,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => Recording())),
                              child: _gridViewItems(
                                activeAssetPath: 'assets/Images/mic.png',
                                label: 'تسجيل',
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => CategoryScreen())),
                              child: _gridViewItems(
                                activeAssetPath:
                                    'assets/Images/category_icon.png',
                                label: 'التصنيف',
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => UploadFile())),
                              child: _gridViewItems(
                                activeAssetPath:
                                    'assets/Images/upload_file.png',
                                label: 'ملف صوتي',
                              ),
                            ),
                            // _gridViewItems(
                            //   activeAssetPath: 'assets/Images/information_button.png',
                            //   label: 'عن التطبيق',
                            // ),
                            // _gridViewItems(
                            //   activeAssetPath: 'assets/Images/smartphone_icon.png',
                            //   label: 'عن التطبيق',
                            // ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
