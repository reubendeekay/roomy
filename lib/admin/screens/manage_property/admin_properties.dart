import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomy/admin/screens/manage_property/admin_property_card.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/models/service_model.dart';

class AdminProperties extends StatelessWidget {
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
            return Container();
          } else {
            List<DocumentSnapshot> documents = snapshot.data.docs;
            return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: documents
                  .map((e) => AdminPropertyCard(PropertyModel(
                        id: e.id,
                        bookings: e['bookings'],
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
                        reviews: e['reviews'],
                        ownerId: e['ownerId'],
                        propertyOwner: e['ownerName'],
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
                        propertyCategory: e['propertyCategory'],
                        description: e['description'],
                        offers: e['offers'],
                        rates: e['rates'],
                      )))
                  .toList(),
            );
          }
        });
  }
}
