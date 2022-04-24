import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:roomy/models/filter_model.dart';
import 'package:roomy/providers/search_provider.dart';
import 'package:roomy/screens/search_screen/search_result_screen.dart';
import 'package:roomy/widgets/property/properties.dart';

class ViewAllScreen extends StatefulWidget {
  static const routeName = '/view-all';

  @override
  _ViewAllScreenState createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).shadowColor,
      body: SafeArea(
          child: Column(
        children: [
          Hero(
            tag: 'search-bar',
            transitionOnUserGestures: true,
            child: Container(
              color: Theme.of(context).primaryColor,
              margin: EdgeInsets.only(bottom: 5),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: GestureDetector(
                  child: Card(
                    color: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (val) {
                        Provider.of<SearchProvider>(context, listen: false)
                            .clearSearch();
                        Navigator.of(context).pushNamed(
                          SearchResultScreen.routeName,
                          arguments: val,
                        );
                      },
                      onEditingComplete: () {
                        Provider.of<SearchProvider>(context, listen: false)
                            .clearSearch();
                        Navigator.of(context).pushNamed(
                          SearchResultScreen.routeName,
                          arguments: FilterModel(name: searchController.text),
                        );
                      },
                      textAlignVertical: TextAlignVertical.center,
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
                        hintText: 'Search for a travely ',
                        hintStyle: GoogleFonts.openSans(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: ViewAllWidgets()),
        ],
      )),
    );
  }
}
