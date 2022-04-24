import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:roomy/models/filter_model.dart';
import 'package:roomy/providers/property_provider.dart';
import 'package:roomy/providers/search_provider.dart';
import 'package:roomy/screens/home/filters.dart';
import 'package:roomy/screens/home/widgets/property_card.dart';
import 'package:roomy/screens/search_screen/search_result_screen.dart';
import 'package:roomy/screens/search_screen/widgets/recent_searches.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search-screen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = ScrollController();
  final searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    searchController.dispose();
  }

  FilterModel searchQuery;

  @override
  Widget build(BuildContext context) {
    Provider.of<PropertyProvider>(context, listen: false).fetchHistory();
    return Scaffold(
      body: SafeArea(
        child: Snap(
          controller: _controller.appBar,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: Hero(
                  tag: 'search-bar',
                  transitionOnUserGestures: true,
                  child: Card(
                    // color: Color(0xFF6939DB),
                    color: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),

                    child: TextField(
                      controller: searchController,
                      style: TextStyle(color: Colors.black),
                      onSubmitted: (val) {
                        if (val.isNotEmpty) {
                          Provider.of<SearchProvider>(context, listen: false)
                              .clearSearch();
                          Navigator.of(context).pushNamed(
                            SearchResultScreen.routeName,
                            arguments: FilterModel(name: searchController.text),
                          );
                          Provider.of<PropertyProvider>(context, listen: false)
                              .addRecentSearch(searchController.text);
                        }
                      },
                      textInputAction: TextInputAction.search,
                      autofocus: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: GestureDetector(
                            onTap: () {
                              if (searchController.text.isNotEmpty) {
                                Provider.of<SearchProvider>(context,
                                        listen: false)
                                    .clearSearch();
                                Navigator.of(context).pushNamed(
                                  SearchResultScreen.routeName,
                                  arguments:
                                      FilterModel(name: searchController.text),
                                );

                                Provider.of<PropertyProvider>(context,
                                        listen: false)
                                    .addRecentSearch(searchController.text);

                                searchController.clear();
                              }
                            },
                            child: Icon(
                              Icons.search,
                              size: 22,
                              color: Colors.grey[500],
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () => showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: const Radius.circular(20),
                                      topRight: const Radius.circular(20)),
                                ),
                                context: context,
                                builder: (ctx) => Filters(
                                      onFilter: (val) {
                                        setState(() {
                                          searchQuery = val;
                                        });
                                        print(searchQuery.location);
                                      },
                                    )),
                            child: Icon(
                              FontAwesomeIcons.slidersH,
                              size: 18,
                              color: Colors.grey[500],
                            ),
                          ),
                          hintText: 'Search name or location',
                          hintStyle:
                              TextStyle(color: Colors.grey[500], fontSize: 18)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: RecentSearches(
                  searchController.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
