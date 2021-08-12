import 'package:konmoaref/Provider/data_provider.dart';
import 'package:konmoaref/Screens/Categories/category_stream.dart';
import 'package:konmoaref/Themes/theme.dart';
import 'package:konmoaref/Utils/langs_categories.dart';
import 'package:flutter/material.dart';
import 'package:konmoaref/Utils/spinner.dart';
import 'package:provider/provider.dart';

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
            CategoryPicker(
              context: context,
              dataProvider: _dataProvider,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class CategoryPicker extends StatelessWidget {
  const CategoryPicker({
    Key? key,
    required this.context,
    required DataProvider? dataProvider,
  })  : _dataProvider = dataProvider,
        super(key: key);

  final BuildContext context;
  final DataProvider? _dataProvider;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: _dataProvider!.categoryLinks.stream.asBroadcastStream(),
      builder: (_, AsyncSnapshot<List<String>> snapshot) => Center(
        child: !snapshot.hasData &&
                snapshot.connectionState != ConnectionState.done
            ? Center(child: Spinner())
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
                                    builder: (_) => CategoryDataStream(),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xff364122),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  width: 150,
                                  height: 150,
                                  child: CategoryItem(value: value),
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
}

class CategoryItem extends StatelessWidget {
  final String value;
  const CategoryItem({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/Images/one_category_icon.png'),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(
                    color: kFontColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
