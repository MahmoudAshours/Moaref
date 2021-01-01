import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:ffmpegtest/Themes/theme.dart';
import 'package:ffmpegtest/Utils/category_comp.dart';
import 'package:ffmpegtest/Utils/langs_categories.dart';
import 'package:ffmpegtest/Utils/play_pause.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ffmpegtest/Helpers/map_indexed.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
              builder: (c, AsyncSnapshot<List<String>> snapshot) =>
                  !snapshot.hasData
                      ? Center(child: SizedBox())
                      : SingleChildScrollView(
                          child: Column(
                            children: snapshot.data
                                .mapIndexed(
                                  (e, i) => CategoryComponent(
                                    provider: provider,
                                    i: i,
                                    e: e,
                                    snapshot: snapshot,
                                    key: ValueKey('$i'),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
            ),
          ),
        )
      ],
    );
  }
}
