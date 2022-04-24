import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roomy/animations/error_icon.dart';
import 'package:roomy/animations/not_found_icon.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/helpers/featured_simmer.dart';
import 'package:roomy/helpers/property_shimmer.dart';
import 'package:roomy/loading_screen.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/models/service_model.dart';
import 'package:roomy/models/view360_model.dart';
import 'package:roomy/screens/home/view_all_card.dart';
import 'package:roomy/screens/home/widgets/property_small.dart';
import 'package:roomy/screens/hotel_profile/hotel_profile_tile.dart';
import 'package:roomy/screens/property_details/widgets/details_reviews.dart';

class AllProperty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('propertyData')
            .doc('propertyListing')
            .collection('properties')
            .orderBy('views')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError || snapshot.data == null) {
            return PropertyShimmer();
          } else {
            List<DocumentSnapshot> documents = snapshot.data.docs;
            return ListView(
              shrinkWrap: true,
              reverse: true,
              physics: NeverScrollableScrollPhysics(),
              children: documents
                  .map(
                    (e) => ViewAllCard(
                      PropertyModel(
                        id: e.id,
                        name: e['name'],
                        coverImage: e['coverImage'],
                        ammenities: e['ammenities'],
                        price: e['price'],
                        views: e['views'],
                        rating: double.parse(e['rating'].toString()),
                        location: PropertyLocation(
                          country: e['location']['country'],
                          latitude: e['location']['latitude'],
                          longitude: e['location']['longitude'],
                          town: e['location']['town'],
                        ),
                        rates: e['rates'],
                        images: e['images'],
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
                                imageUrl: s['imageUrl'],
                                status: s['status'],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  )
                  .toList(),
            );
          }
        });
  }
}

class FeaturedProperty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('propertyData')
            .doc('propertyListing')
            .collection('properties')
            .where(
              'propertyCategory',
              isEqualTo: 'Hotel',
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError || snapshot.data == null) {
            return FeaturedShimmer();
          } else {
            List<DocumentSnapshot> documents = snapshot.data.docs;
            return ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: documents
                  .map((e) => PropertySmall(PropertyModel(
                        id: e.id,
                        name: e['name'],
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

class HotelProperties extends StatelessWidget {
  final String id;
  HotelProperties({this.id});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: id == null
            ? FirebaseFirestore.instance
                .collection('propertyData')
                .doc('propertyListing')
                .collection('properties')
                .snapshots()
            : FirebaseFirestore.instance
                .collection('propertyData')
                .doc('propertyListing')
                .collection('properties')
                .where('ownerId', isEqualTo: id)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError || snapshot.data == null) {
            return LoadingScreen();
          } else {
            List<DocumentSnapshot> documents = snapshot.data.docs;
            return ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return HotelPropertyTile(PropertyModel(
                  id: documents[index].id,
                  rating: double.parse(documents[index]['rating'].toString()),
                  name: documents[index]['name'],
                  coverImage: documents[index]['coverImage'],
                  ammenities: documents[index]['ammenities'],
                  price: documents[index]['price'],
                  location: PropertyLocation(
                    country: documents[index]['location']['country'],
                    latitude: documents[index]['location']['latitude'],
                    longitude: documents[index]['location']['longitude'],
                    town: documents[index]['location']['town'],
                  ),
                  rates: documents[index]['rates'],
                  views: documents[index]['views'],
                  images: documents[index]['images'],
                  reviews: documents[index]['reviews'],
                  ownerId: documents[index]['ownerId'],
                  propertyOwner: documents[index]['ownerName'],
                  propertyCategory: documents[index]['propertyCategory'],
                  description: documents[index]['description'],
                  offers: documents[index]['offers'],
                  panoramicView: documents[index]['view360']
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
                  services: documents[index]['services']
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
                ));
              },
            );
          }
        });
  }
}

class ViewAllWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('propertyData')
            .doc('propertyListing')
            .collection('properties')
            .orderBy('views')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorIcon();
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return PropertyShimmer();
          } else {
            List<DocumentSnapshot> documents = snapshot.data.docs;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return documents.length < 1
                    ? NotFoundIcon()
                    : ViewAllCard(PropertyModel(
                        id: documents[index].id,
                        rating:
                            double.parse(documents[index]['rating'].toString()),
                        name: documents[index]['name'],
                        coverImage: documents[index]['coverImage'],
                        ammenities: documents[index]['ammenities'],
                        price: documents[index]['price'],
                        location: PropertyLocation(
                          country: documents[index]['location']['country'],
                          latitude: documents[index]['location']['latitude'],
                          longitude: documents[index]['location']['longitude'],
                          town: documents[index]['location']['town'],
                        ),
                        rates: documents[index]['rates'],
                        views: documents[index]['views'],
                        images: documents[index]['images'],
                        reviews: documents[index]['reviews'],
                        ownerId: documents[index]['ownerId'],
                        propertyOwner: documents[index]['ownerName'],
                        propertyCategory: documents[index]['propertyCategory'],
                        description: documents[index]['description'],
                        panoramicView: documents[index]['view360']
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
                        offers: documents[index]['offers'],
                        services: documents[index]['services']
                            .map<ServiceModel>(
                              (s) => ServiceModel(
                                category: s['category'],
                                price: double.parse(s['price'].toString()),
                                name: s['name'],
                                imageUrl: s['imageUrl'],
                                status: s['status'],
                              ),
                            )
                            .toList(),
                      ));
              },
            );
          }
        });
  }
}

class Reviews extends StatelessWidget {
  final String id;
  Reviews(this.id);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('propertyData')
            .doc('propertyListing')
            .collection('properties')
            .doc(id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorIcon();
          }
          if (!snapshot.hasData) {
            return NotFoundIcon();
          } else {
            DocumentSnapshot document = snapshot.data;

            return document['reviews'].length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, i) => ReviewTile(
                        review: ReviewModel(
                      dateReviewed: document['reviews'][i]['dateReviewed'],
                      nameOfReviewer: document['reviews'][i]['nameOfReviewer'],
                      review: document['reviews'][i]['review'],
                      profilePic: document['reviews'][i]['profilePic'],
                      rating: double.parse(
                          document['reviews'][i]['rating'].toString()),
                    )),
                    itemCount: document['reviews'].length,
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text('No reviews yet'),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 42,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: kPrimary),
                            borderRadius: BorderRadius.circular(2)),
                        child: TextButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => SimpleDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  children: [UserReview(id)])),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Give a Review',
                                  style: const TextStyle(
                                    color: kPrimary,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                FaIcon(
                                  FontAwesomeIcons.comment,
                                  color: kPrimary,
                                  size: 16,
                                ),
                              ]),
                        ),
                      ),
                    ],
                  );
          }
        });
  }
}

class RelatedProperties extends StatelessWidget {
  final String category;
  final String parentId;
  RelatedProperties({@required this.category, this.parentId});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('propertyData')
            .doc('propertyListing')
            .collection('properties')
            .where(
              'propertyCategory',
              isEqualTo: category,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError || snapshot.data == null) {
            return FeaturedShimmer();
          } else {
            List<DocumentSnapshot> documents = snapshot.data.docs;
            // documents.removeWhere((element) => element.id == parentId);

            return ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: documents
                  .map((e) => e.id != parentId
                      ? PropertySmall(PropertyModel(
                          id: e.id,
                          name: e['name'],
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
                        ))
                      : Container())
                  .toList(),
            );
          }
        });
  }
}
