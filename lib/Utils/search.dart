import 'package:animate_do/animate_do.dart';
import 'package:konmoaref/Provider/data_provider.dart';
import 'package:konmoaref/Themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  //Yellowish color
  final Color _primaryColor = kSecondaryColor;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: _primaryColor,
          ),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(100),
        ),
        child: GestureDetector(
          onTap: () =>
              showSearch(context: context, delegate: CustomSearchClass()),
          child: Icon(
            Icons.search,
            color: kSecondaryColor,
          ),
        ),
      ),
    );
  }
}

class CustomSearchClass extends SearchDelegate {
  @override
  String get searchFieldLabel => "إبحث";
  @override
  List<Widget> buildActions(BuildContext context) {
// this will show clear query button
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
// adding a back button to close the search
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  late List<String> searchResult;
  @override
  Widget buildResults(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (_, provider, __) {
        searchResult = provider.categoryItems
            .where((element) => element.contains(query))
            .toList();
        return Container(
          margin: EdgeInsets.all(20),
          child: ListView(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              scrollDirection: Axis.vertical,
              children: searchResult
                  .map<Widget>(
                    (String searched) => FadeInUp(
                      child: ListTile(
                        title: Text(
                          '$searched',
                          textAlign: TextAlign.right,
                          locale: Locale('ar'),
                        ),
                        onTap: () {
                          provider.changeCategory(searched);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  )
                  .toList()),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
