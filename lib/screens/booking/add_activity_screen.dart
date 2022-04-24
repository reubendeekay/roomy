import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:roomy/animations/not_found_icon.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/providers/search_provider.dart';
import 'package:roomy/screens/booking/payment_screen.dart';

import 'package:roomy/screens/hotel_profile/selectable_tile.dart';

class AddActivityScreen extends StatefulWidget {
  static const routeName = '/add-services';

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final nearbyServices = Provider.of<SearchProvider>(context).nearbyServices;
    final size = MediaQuery.of(context).size;
    final property = ModalRoute.of(context).settings.arguments as PropertyModel;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'ADD ACTIVITIES',
          style: const TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w900),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Card(
                  color: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    controller: searchController,
                    onEditingComplete: () async {
                      await Provider.of<SearchProvider>(context, listen: false)
                          .searchService(searchController.text);
                      setState(() {});
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
                      hintText: 'Search for services',
                      hintStyle: GoogleFonts.openSans(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
              //RECOMMENDED SERVICES
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      'Recommended Services',
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      child: Text(
                        '*Long press an item to view full details',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ...List.generate(nearbyServices.length, (index) {
                      print(nearbyServices.length);
                      return SelectablePropertyTile(
                        nearbyServices[index],
                      );
                    }),
                    if (nearbyServices.length < 1) NotFoundIcon()
                  ],
                ),
              )
            ],
          ),
          Positioned(
            bottom: 15,
            right: 20,
            left: 20,
            child: SizedBox(
              height: 45,
              width: size.width,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  color: kPrimary,
                  onPressed: () => Navigator.of(context)
                      .pushNamed(PaymentScreen.routeName, arguments: property),
                  child: const Text(
                    'Continue',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
