import 'package:flutter/material.dart';
import 'package:konmoaref/Provider/data_provider.dart';
import 'package:konmoaref/Screens/Categories/category_comp.dart';
import 'package:konmoaref/Utils/spinner.dart';
import 'package:provider/provider.dart';
import 'package:konmoaref/Helpers/map_indexed.dart';

class CategoryDataStream extends StatelessWidget {
  const CategoryDataStream({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    final _dataProvider = Provider.of<DataProvider>(context);
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: StreamBuilder(
        stream: _dataProvider.soundLinks.stream.asBroadcastStream(),
        builder: (_, AsyncSnapshot<List<String>>? snapshot) {
          return snapshot!.data == null
              ? Center(child: Spinner())
              : SingleChildScrollView(
                  child: Column(
                    children: snapshot.data!
                        .mapIndexed(
                          (String title, int index) => CategoryComponent(
                            provider: _dataProvider,
                            index: index,
                            title: title,
                            snapshot: snapshot,
                          ),
                        )
                        .toList(),
                  ),
                );
        },
      ),
    );
  }
}
