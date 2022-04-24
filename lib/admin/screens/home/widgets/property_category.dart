import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:roomy/admin/screens/home/widgets/property_small.dart';
import 'package:roomy/helpers/featured_simmer.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/models/service_model.dart';
import 'package:roomy/models/view360_model.dart';

class AdminFeaturedProperty extends StatelessWidget {
  final String criteria;
  AdminFeaturedProperty({this.criteria = 'views'});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('propertyData')
            .doc('propertyListing')
            .collection('properties')
            .where('ownerId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError || snapshot.data == null) {
            return FeaturedShimmer();
          } else {
            List<DocumentSnapshot> documents = snapshot.data.docs;
            documents.sort((a, b) =>
                b[criteria].toString().compareTo(a[criteria].toString()));

            return ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: documents
                  .map((e) => AdminPropertySmall(PropertyModel(
                        id: e.id,
                        name: e['name'],
                        bookings: e['bookings'],
                        coverImage: e['coverImage'],
                        views: e['views'],
                        ammenities: e['ammenities'],
                        price: e['price'],
                        location: PropertyLocation(
                          country: e['location']['country'],
                          latitude: e['location']['latitude'],
                          longitude: e['location']['longitude'],
                          town: e['location']['town'],
                        ),
                        rates: e['rates'],
                        images: e['images'],
                        rating: double.parse(e['rating'].toString()),
                        reviews: e['reviews'],
                        ownerId: e['ownerId'],
                        propertyOwner: e['ownerName'],
                        propertyCategory: e['propertyCategory'],
                        description: e['description'],
                        offers: e['offers'],
                        panoramicView: e['view360']
                            .map<View360Model>((s) => View360Model(
                                imageUrl: s['image'],
                                id: s['id'].toString(),
                                name: s['name'],
                                hotspots: s['hotspots']
                                    .map<ImageHotspot>((k) => ImageHotspot(
                                        idNext: k['idNext'],
                                        name: k['name'],
                                        latitude: k['latitude'],
                                        longitude: k['longitude']))
                                    .toList()))
                            .toList(),
                        services: e['services']
                            .map<ServiceModel>(
                              (s) => ServiceModel(
                                category: s['category'],
                                price: double.parse(s['price'].toString()),
                                name: s['name'],
                                status: s['status'],
                                imageUrl: s['imageUrl'],
                              ),
                            )
                            .toList(),
                      )))
                  .toList(),
            );
          }
        });
  }
}
