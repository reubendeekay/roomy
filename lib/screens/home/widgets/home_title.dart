import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/filter_model.dart';
import 'package:roomy/screens/home/view_all_screen.dart';
import 'package:roomy/screens/search_screen/search_result_screen.dart';

class HomeTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  HomeTitle(this.title, this.icon);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Row(
        children: [
          FaIcon(
            icon,
            size: 15,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: kText.copyWith(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(ViewAllScreen.routeName),
            child: Text(
              'View all',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}

class HomeOptions extends StatefulWidget {
  @override
  _HomeOptionsState createState() => _HomeOptionsState();
}

class _HomeOptionsState extends State<HomeOptions> {
  int _selectedIndex = 0;
  List options = [
    {
      'name': 'All',
      'term': '',
      'icon': FontAwesomeIcons.globe,
    },
    {
      'name': 'Fun & Activities',
      'term': 'Activity',
      'icon': FontAwesomeIcons.swimmer,
    },
    {
      'name': 'Hotels',
      'term': 'Hotel',
      'icon': FontAwesomeIcons.umbrellaBeach,
    },
    {
      'name': 'Events',
      'term': 'Event',
      'icon': FontAwesomeIcons.campground,
    },
    {
      'name': 'Flights',
      'term': 'Flight',
      'icon': FontAwesomeIcons.planeArrival,
    },
    {
      'name': 'Transport',
      'term': 'Transport',
      'icon': FontAwesomeIcons.car,
    },
    {
      'name': 'Restaurants',
      'term': 'Restaurant',
      'icon': FontAwesomeIcons.pizzaSlice,
    },
    {
      'name': 'Shopping',
      'term': 'Shopping',
      'icon': FontAwesomeIcons.shoppingBag
    },
    {
      'name': 'Residences',
      'icon': FontAwesomeIcons.building,
      'term': 'Residence',
    },
    {
      'name': 'More',
      'term': '',
      'icon': FontAwesomeIcons.globe,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
      height: 40,
      child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: List.generate(
              options.length,
              (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    Navigator.of(context).pushNamed(
                      SearchResultScreen.routeName,
                      arguments: FilterModel(
                          category: options[index]['term'],
                          searchTerm: options[index]['name']),
                    );
                  },
                  child: option(
                      options[index]['name'], index, options[index]['icon'])))),
    );
  }

  Widget option(String option, int index, IconData icon) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          color: index == _selectedIndex ? kPrimary : Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          border: Border.all(
            width: index == _selectedIndex ? 0 : 1,
            color: Colors.grey.withOpacity(0.2),
          )),
      child: Center(
        child: Row(
          children: [
            Icon(icon,
                size: 15,
                color: index == _selectedIndex ? Colors.white : Colors.grey),
            SizedBox(
              width: 5,
            ),
            Text(
              option,
              style: TextStyle(
                color: index == _selectedIndex ? Colors.white : Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
