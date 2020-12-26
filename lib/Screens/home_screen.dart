import 'package:ffmpegtest/Themes/theme.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double height = 60;
  var currindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: DraggableScrollableSheet(
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
                        activeAssetPath: 'assets/maedit.png',
                        nonActiveAssetPath: 'assets/mdedit.png',
                        controller: scrollController,
                        label: 'التصنيف',
                        index: 0),
                    _bottomNavigationItemBuilder(
                        activeAssetPath: 'assets/mamic.png',
                        nonActiveAssetPath: 'assets/mdmic.png',
                        controller: scrollController,
                        label: 'تسجيل',
                        index: 1),
                    _bottomNavigationItemBuilder(
                        activeAssetPath: 'assets/mabrush.png',
                        nonActiveAssetPath: 'assets/mdbrush.png',
                        controller: scrollController,
                        label: 'ملف صوتي',
                        index: 2),
                    _bottomNavigationItemBuilder(
                        activeAssetPath: 'assets/maphoto.png',
                        nonActiveAssetPath: 'assets/mdphoto.png',
                        controller: scrollController,
                        label: 'المكتبة',
                        index: 3),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: currindex == 0
                      ? ListView.builder(
                          controller: scrollController,
                          itemCount: 25,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text('Item $index'),
                              trailing: Icon(Icons.ac_unit),
                            );
                          },
                        )
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: 25,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text('Itemss'),
                              trailing: Icon(Icons.ac_unit),
                            );
                          },
                        ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _bottomNavigationItemBuilder(
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
          height: 100,
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
