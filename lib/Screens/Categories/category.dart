import 'package:animate_do/animate_do.dart';
import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:ffmpegtest/Screens/Categories/category_comp.dart';
import 'package:ffmpegtest/Themes/theme.dart';
import 'package:ffmpegtest/Utils/Commons/langs_categories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ffmpegtest/Helpers/map_indexed.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  DataProvider? _dataProvider;

  @override
  void didChangeDependencies() {
    _dataProvider = Provider.of<DataProvider>(context, listen: false);
    _dataProvider!.fetchLanguage();
    _dataProvider!.fetchCategory();
    _dataProvider!.fetchSounds();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: LanguagesDropDownList(),
            ),
            _categoryPicker(_dataProvider!),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _categoryPicker(DataProvider provider) {
    return StreamBuilder<List<String>>(
      stream: provider.categoryLinks.stream.asBroadcastStream(),
      builder: (_, AsyncSnapshot<List<String>> snapshot) => Center(
        child: !snapshot.hasData &&
                snapshot.connectionState != ConnectionState.done
            ? CircularProgressIndicator()
            : SafeArea(
                top: false,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 100,
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 50,
                    children: snapshot.data!
                        .map<Widget>(
                          (String value) => SafeArea(
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (_) => _categoriesDataListView(),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xff364122),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  width: 150,
                                  height: 150,
                                  child: _categoryItem(value),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
      ),
    );
  }

  Container _categoriesDataListView() {
    return Container(
      child: StreamBuilder(
        stream: _dataProvider!.soundLinks.stream.asBroadcastStream(),
        builder: (_, AsyncSnapshot<List<String>>? snapshot) {
          return snapshot!.data == null
              ? Center(child: Container(color: Colors.black))
              : SingleChildScrollView(
                  child: Column(
                    children: snapshot.data!
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
    );
  }

  SlideInUp _categoryItem(String value) {
    return SlideInUp(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/Images/one_category_icon.png'),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Text(
                  value,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: kFontColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
