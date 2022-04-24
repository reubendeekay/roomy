import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/models/service_model.dart';
import 'package:roomy/models/user_model.dart';
import 'package:roomy/models/view360_model.dart';

class PropertyProvider with ChangeNotifier {
  List<PropertyModel> _properties = [];
  List<PropertyModel> _yourHistory = [];
  List<PropertyModel> _yourWishlist = [];
  List<PropertyModel> get properties => [..._properties];
  List<PropertyModel> get yourHistory => [..._yourHistory];
  List<PropertyModel> get yourWishlist => [..._yourWishlist];
  UserModel _hotel;
  UserModel get hotel => _hotel;
  List<ReviewModel> _hotelReviews = [];
  List<ReviewModel> get hotelReviews => [..._hotelReviews];

  Future<void> fetchProperties() async {
    final propertyData = await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .get();
    List<PropertyModel> propData = [];

    propertyData.docs.forEach((e) {
      propData.add(PropertyModel(
        id: e.id,
        name: e['name'],
        coverImage: e['coverImage'],
        ammenities: e['ammenities'],
        price: e['price'],
        rating: double.parse(e['rating'].toString()),
        rates: e['rates'],
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
      ));
    });

    _properties = propData;

    notifyListeners();
  }

  Future<void> addReview(ReviewModel review, String id) async {
    final reviewData = await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .doc(id)
        .get();

    await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .doc(id)
        .update({
      'reviews': FieldValue.arrayUnion([review.toJson()]),
      'rating': (reviewData['rating'] + review.rating) / 2,
    });

    notifyListeners();
  }

  Future<void> addRecentSearch(String searchTerm) async {
    if (searchTerm.isNotEmpty) {
      final searchData = await FirebaseFirestore.instance
          .collection('userData')
          .doc('recentSearch')
          .collection(FirebaseAuth.instance.currentUser.uid)
          .get();
      if (searchData.docs.contains(searchTerm)) {
        await FirebaseFirestore.instance
            .collection('userData')
            .doc('recentSearch')
            .collection(FirebaseAuth.instance.currentUser.uid)
            .doc(searchData.docs
                .firstWhere((element) => element.data()['term'] == searchTerm)
                .id)
            .update({
          'createdAt': Timestamp.now(),
        });
      } else {
        await FirebaseFirestore.instance
            .collection('userData')
            .doc('recentSearch')
            .collection(FirebaseAuth.instance.currentUser.uid)
            .doc()
            .set({
          'term': searchTerm,
          'createdAt': Timestamp.now(),
        });
      }
    }
    notifyListeners();
  }

  Future<void> addView(
    String id,
  ) async {
    await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .doc(id)
        .update({
      'views': FieldValue.increment(1),
    });

    // FirebaseFirestore.instance
    //     .collection('propertyData')
    //     .doc('propertyListing')
    //     .collection('properties')
    //     .doc(id)
    //     .get()
    //     .then((value) => FirebaseFirestore.instance
    //         .collection('users')
    //         .doc(value['ownerId'])
    //         .collection('hosting')
    //         .doc('account')
    //         .update({'totalViews': FieldValue.increment(1)}));
    notifyListeners();
  }

  Future<void> addHistory(
    String propertyId,
  ) async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final history = FirebaseFirestore.instance
        .collection('userData')
        .doc('history')
        .collection(uid);
    final historyData = await history.get();

    if (historyData.docs.contains(propertyId)) {
      history.doc(propertyId).update({'createdAt': Timestamp.now()});
    } else {
      history.doc(propertyId).set({
        'createdAt': Timestamp.now(),
        'id': propertyId,
      });
    }
  }

  Future<void> fetchHistory() async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final history = await FirebaseFirestore.instance
        .collection('userData')
        .doc('history')
        .collection(uid)
        .orderBy('createdAt')
        .get();
    List<PropertyModel> propData = [];

    Future.forEach(history.docs, (element) async {
      await FirebaseFirestore.instance
          .collection('propertyData')
          .doc('propertyListing')
          .collection('properties')
          .doc(element.id)
          .get()
          .then((e) => propData.add(PropertyModel(
                id: e.id,
                name: e['name'],
                coverImage: e['coverImage'],
                ammenities: e['ammenities'],
                price: e['price'],
                rating: double.parse(e['rating'].toString()),
                rates: e['rates'],
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
              )));
    }).then((_) {
      _yourHistory = propData;
      notifyListeners();
    });

    notifyListeners();
  }

  Future<void> fetchWishlist() async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final history =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    List<PropertyModel> propData = [];
    List historyList = history.data()['wishlist'];

    await Future.forEach(historyList, (element) async {
      await FirebaseFirestore.instance
          .collection('propertyData')
          .doc('propertyListing')
          .collection('properties')
          .doc(element)
          .get()
          .then((e) => propData.add(PropertyModel(
                id: e.id,
                name: e['name'],
                rating: double.parse(e['rating'].toString()),
                views: e['views'],
                coverImage: e['coverImage'],
                ammenities: e['ammenities'],
                price: e['price'],
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
                propertyCategory: e['propertyCategory'],
                rates: e['rates'],
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
              )));
    }).then((_) {
      _yourWishlist = propData;
      notifyListeners();
    });

    // print(_yourWishlist.first.name);

    notifyListeners();
  }

  Future<void> getHotelOwner(String id) async {
    final results = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: id)
        .get();
    final _currentUser = results.docs.first.data();
    final obtainedHotel = UserModel(
        address: _currentUser['address'],
        dateOfBirth: _currentUser['dateOfBirth'],
        email: _currentUser['email'],
        fullName: _currentUser['fullName'],
        nationalId: _currentUser['nationalId'],
        phoneNumber: _currentUser['phoneNumber'],
        imageUrl: _currentUser['profilePic'],
        wishlist: _currentUser['wishlist'],
        userId: _currentUser['userId'],
        password: _currentUser['password']);
    _hotel = obtainedHotel;

    notifyListeners();
  }

  Future<void> getUserReviews(String id) async {
    final results = await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .where('ownerId', isEqualTo: id)
        .get();

    List<ReviewModel> reviews = [];

    results.docs.forEach((element) {
      reviews.addAll([
        ...element['reviews']
            .map<ReviewModel>((e) => ReviewModel(
                  dateReviewed: e['dateReviewed'],
                  nameOfReviewer: e['nameOfReviewer'],
                  review: e['review'],
                  profilePic: e['profilePic'],
                  rating: double.parse(e['rating'].toString()),
                ))
            .toList()
      ]);
    });
    print(reviews.first.nameOfReviewer);
    _hotelReviews = reviews;
    notifyListeners();
  }
}
