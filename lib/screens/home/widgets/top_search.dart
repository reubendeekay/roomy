import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roomy/screens/search_screen/search_screen.dart';

class TopSearch extends StatefulWidget {
  @override
  _TopSearchState createState() => _TopSearchState();
}

class _TopSearchState extends State<TopSearch> {
  int isSelected = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Hero(
        tag: 'search-bar',
        transitionOnUserGestures: true,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
              // color: Color(0xFF6939DB),
              borderRadius: BorderRadius.circular(5)),
          child: GestureDetector(
            onTap: () =>
                Navigator.of(context).pushNamed(SearchScreen.routeName),
            child: Card(
              // color: Color(0xFF6939DB),
              color: Colors.grey[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      size: 22,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Search by name or location',
                        style: TextStyle(color: Colors.grey, fontSize: 18)),
                    Spacer(),
                    const Icon(
                      FontAwesomeIcons.slidersH,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
