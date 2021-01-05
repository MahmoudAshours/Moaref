import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:ffmpegtest/Utils/Categories/category_comp.dart';
import 'package:ffmpegtest/Utils/Commons/langs_categories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ffmpegtest/Helpers/map_indexed.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  DataProvider _dataProvider;

  @override
  void didChangeDependencies() {
    _dataProvider = Provider.of<DataProvider>(context, listen: false);
    _dataProvider.fetchLanguage();

    _dataProvider.fetchCategory();

    _dataProvider.fetchSounds();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LangsCats(),
        SizedBox(height: 10),
        Container(
          height: MediaQuery.of(context).size.height / 4.4,
          child: StreamBuilder(
            stream: _dataProvider.soundLinks.stream.asBroadcastStream(),
            builder: (c, AsyncSnapshot<List<String>> snapshot) {
              return !snapshot.hasData
                  ? Center(child: SizedBox())
                  : SingleChildScrollView(
                      child: Column(
                        children: snapshot.data
                            .mapIndexed(
                              (String e, int i) => CategoryComponent(
                                provider: _dataProvider,
                                i: i,
                                e: e,
                                snapshot: snapshot,
                              ),
                            )
                            .toList(),
                      ),
                    );
            },
          ),
        )
      ],
    );
  }
}
