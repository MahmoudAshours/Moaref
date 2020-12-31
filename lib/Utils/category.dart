import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:ffmpegtest/Themes/theme.dart';
import 'package:ffmpegtest/Utils/langs_categories.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LangsCats(),
        SizedBox(height: 10),
        Container(
          height: MediaQuery.of(context).size.height / 4.4,
          child: Consumer<DataProvider>(
            builder: (BuildContext c, DataProvider provider, _) =>
                FutureBuilder(
              future: provider.fetchSounds(),
              builder: (c, AsyncSnapshot snapshot) => !snapshot.hasData
                  ? Center(child: SizedBox())
                  : ListView.separated(
                      separatorBuilder: (BuildContext c, int i) {
                        return FadeInUpBig(
                          delay: Duration(milliseconds: 50 * i),
                          child: Divider(
                            thickness: 2,
                            color: Colors.black12,
                          ),
                        );
                      },
                      itemCount: snapshot.data.length ?? 0,
                      itemBuilder: (BuildContext context, int i) {
                        return SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: FadeInUp(
                              delay: Duration(milliseconds: 20 * i),
                              child: ListTile(
                                leading: Container(
                                  height: 30,
                                  width: 30,
                                  key: Key(i.toString()),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: kSecondaryColor,
                                  ),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () =>
                                          provider.fetchSoundData(snapshot, i),
                                      child: provider.sound ==
                                                  Sound.IsNotPlaying &&
                                              provider.currentIndex == i
                                          ? FaIcon(
                                              FontAwesomeIcons.play,
                                              color: Colors.white,
                                              key: Key(i.toString()),
                                              size: 16,
                                            )
                                          : FaIcon(
                                              FontAwesomeIcons.stop,
                                              color: Colors.white,
                                              key: Key(i.toString()),
                                              size: 16,
                                            ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  snapshot.data[i]
                                      .toString()
                                      .replaceAll('.mp3', ''),
                                  style: TextStyle(
                                      color: kSecondaryFontColor,
                                      fontWeight: FontWeight.w600),
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        )
      ],
    );
  }
}
