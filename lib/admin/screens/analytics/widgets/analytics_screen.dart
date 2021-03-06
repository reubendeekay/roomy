import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roomy/admin/constants.dart';
import 'package:roomy/admin/screens/manage_property/admin_property_card.dart';
import 'package:roomy/models/property_model.dart';

class AnalyticsScreen extends StatefulWidget {
  static const routeName = '/analytics_screen';
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int selectedOption = 0;
  List analyticsOptions = ['Most Viewed', 'Recents', 'Most Liked'];

  @override
  Widget build(BuildContext context) {
    Stream getStream() {
      if (selectedOption == 0) {
        return FirebaseFirestore.instance
            .collection('propertyData')
            .doc('propertyListing')
            .collection('properties')
            .orderBy('views', descending: true)
            .snapshots();
      } else if (selectedOption == 1) {
        return FirebaseFirestore.instance
            .collection('propertyData')
            .doc('propertyListing')
            .collection('properties')
            .orderBy('createdAt', descending: true)
            .snapshots();
      } else if (selectedOption == 2) {
        return FirebaseFirestore.instance
            .collection('propertyData')
            .doc('propertyListing')
            .collection('properties')
            .orderBy('likes', descending: true)
            .snapshots();
      }
      return null;
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Analytics'.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: kPrimary,
        ),
        body: ListView(
          children: [
            Container(
              height: 40,
              margin: const EdgeInsets.fromLTRB(12, 20, 0, 10),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = index;
                    });
                  },
                  child: AnalyticOption(
                    isSelected: selectedOption == index,
                    title: analyticsOptions[index],
                  ),
                ),
                itemCount: analyticsOptions.length,
              ),
            ),
            StreamBuilder(
                stream: getStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.hasError ||
                      snapshot.data == null) {
                    return Container();
                  } else {
                    List<DocumentSnapshot> documents = snapshot.data.docs;
                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: documents
                          .map((e) => AdminPropertyCard(PropertyModel(
                                id: e.id,
                                name: e['name'],
                                coverImage: e['coverImage'],
                                ammenities: e['ammenities'],
                                price: e['price'],
                                rating: double.parse(e['rating'].toString()),
                                views: e['views'],
                                location: PropertyLocation(
                                  country: e['location']['country'],
                                  latitude: e['location']['latitude'],
                                  longitude: e['location']['longitude'],
                                  town: e['location']['town'],
                                ),
                                images: e['images'],
                                bookings: e['bookings'],
                                rates: e['rates'],
                                reviews: e['reviews'],
                                ownerId: e['ownerId'],
                                propertyOwner: e['ownerName'],
                                propertyCategory: e['propertyCategory'],
                                description: e['description'],
                                offers: e['offers'],
                              )))
                          .toList(),
                    );
                  }
                })
          ],
        ));
  }
}

class AnalyticOption extends StatefulWidget {
  final String title;
  final bool isSelected;
  AnalyticOption({
    this.title,
    this.isSelected,
  });

  @override
  _AnalyticOptionState createState() => _AnalyticOptionState();
}

class _AnalyticOptionState extends State<AnalyticOption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: widget.isSelected ? kPrimary : Colors.transparent,
      ),
      child: Text(
        widget.title,
        style: TextStyle(
          color: widget.isSelected ? Colors.white : Colors.grey,
          fontWeight: widget.isSelected ? FontWeight.w400 : FontWeight.w600,
        ),
      ),
    );
  }
}
