import 'package:animate_do/animate_do.dart';
import 'package:ffmpegtest/Provider/data_provider.dart';
import 'package:ffmpegtest/Screens/Categories/category_comp.dart';
import 'package:ffmpegtest/Themes/theme.dart';
import 'package:ffmpegtest/Utils/Commons/langs_categories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ffmpegtest/Helpers/map_indexed.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        toolbarHeight: 30,
        actionsIconTheme: IconThemeData(color: Colors.black),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
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
            ? Center(child: CircularProgressIndicator())
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
                                  _dataProvider!.changeCategory(value);
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (_) => _categoriesDataStream(),
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

  Container _categoriesDataStream() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: StreamBuilder(
        stream: _dataProvider!.soundLinks.stream.asBroadcastStream(),
        builder: (_, AsyncSnapshot<List<String>>? snapshot) {
          return snapshot!.data == null
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: snapshot.data!
                        .mapIndexed(
                          (String title, int index) => CategoryComponent(
                            provider: _dataProvider!,
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
