import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:roomy/helpers/property_shimmer.dart';
import 'package:roomy/models/filter_model.dart';
import 'package:roomy/providers/search_provider.dart';
import 'package:roomy/screens/home/view_all_card.dart';
import 'package:roomy/animations/error_icon.dart';
import 'package:roomy/animations/not_found_icon.dart';

class SearchResultScreen extends StatefulWidget {
  static const routeName = '/search-result';

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  String searchTerm;
  final _formKey = GlobalKey<FormState>();
  bool isLocationTapped = false;
  String selectedPlace;
  FilterModel newSearchQuery;
  @override
  Widget build(BuildContext context) {
    // List<Widget> locations = places
    //     .map((e) => GestureDetector(
    //         onTap: () {
    //           setState(() {
    //             selectedPlace = e;
    //           });
    //         },
    //         child: Text(e)))
    //     .toList();
    var searchQueries =
        ModalRoute.of(context).settings.arguments as FilterModel;
    final size = MediaQuery.of(context).size;
    return Scaffold(
        // backgroundColor: Theme.of(context).shadowColor,
        body: SafeArea(
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              color: Theme.of(context).primaryColor,
              margin: EdgeInsets.only(bottom: 5),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            color: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              initialValue: searchQueries.name == null
                                  ? ''
                                  : searchQueries.name,
                              onFieldSubmitted: (val) {
                                if (val.isNotEmpty) {
                                  setState(() {
                                    newSearchQuery = FilterModel(
                                      name: val,
                                      category: val,
                                      location: val,
                                      ammenities: [val],
                                      searchTerm: searchQueries.searchTerm,
                                    );
                                    isLocationTapped = true;
                                  });
                                }
                              },
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: -5,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  size: 22,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                hintText:
                                    'Search for ${searchQueries.searchTerm != null ? searchQueries.searchTerm : 'a destination'}',
                                hintStyle: GoogleFonts.openSans(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        if (searchQueries.searchTerm != null)
                          SizedBox(
                            width: 10,
                          ),
                        if (searchQueries.searchTerm != null)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLocationTapped = !isLocationTapped;
                              });
                            },
                            child: Container(
                                // height: 50,
                                // width: 50,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8)),
                                child: Icon(
                                  Icons.my_location_sharp,
                                  color: Colors.grey[500],
                                  size: 20,
                                )),
                          )
                      ],
                    ),
                    if (searchQueries.searchTerm != null && isLocationTapped)
                      Card(
                        color: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          textAlignVertical: TextAlignVertical.center,
                          textInputAction: TextInputAction.search,
                          onFieldSubmitted: (val) {
                            if (val.isNotEmpty) {
                              setState(() {
                                newSearchQuery = FilterModel(
                                  name: val,
                                  category: val,
                                  location: val,
                                  ammenities: [val],
                                  searchTerm: searchQueries.searchTerm,
                                );
                              });
                              Provider.of<SearchProvider>(context,
                                      listen: false)
                                  .searchProperty(newSearchQuery);
                            }
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: -5,
                            ),
                            prefixIcon: const Icon(
                              Icons.location_on,
                              size: 22,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                            hintText: 'Filter by location',
                            hintStyle: GoogleFonts.openSans(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          FutureBuilder(
            future: newSearchQuery == null
                ? Provider.of<SearchProvider>(context, listen: false)
                    .searchProperty(searchQueries)
                : Provider.of<SearchProvider>(context, listen: false)
                    .searchProperty(newSearchQuery),
            builder: (ctx, data) {
              if (data.connectionState == ConnectionState.waiting) {
                return Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, i) => PropertyShimmer(),
                    itemCount: 6,
                  ),
                );
              }
              print(size.height);
              if (data.error != null) {
                return ErrorIcon();
              }
              final search = Provider.of<SearchProvider>(context, listen: false)
                  .yourSearch;

              return search.length > 0
                  ? Expanded(
                      child: ListView(
                        children: List.generate(
                          search.length,
                          (index) => ViewAllCard(search[index]),
                        ),
                      ),
                    )
                  : NotFoundIcon();
            },
          ),
        ],
      ),
    ));
  }
}
