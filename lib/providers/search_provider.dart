import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:roomy/models/filter_model.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/models/service_model.dart';
import 'package:roomy/models/view360_model.dart';

class SearchProvider with ChangeNotifier {
  List<PropertyModel> _yourSearch = [];
  List<PropertyModel> get yourSearch => [..._yourSearch];
  List<PropertyModel> _nearbyServices = [];
  List<PropertyModel> get nearbyServices => [..._nearbyServices];

  Future<void> searchProperty(FilterModel filter) async {
    final results = await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .get();
    List<PropertyModel> propData = [];

    if ((filter.ammenities == null &&
            filter.price == null &&
            filter.rating == null &&
            filter.location == null &&
            filter.category == null &&
            (filter.name == null || filter.name.isEmpty)) ||
        filter.category == 'All') {
      results.docs.forEach((element) {
        propData.add(PropertyModel(
            id: element.id,
            name: element['name'],
            rates: element['rates'],
            coverImage: element['coverImage'],
            ammenities: element['ammenities'],
            price: element['price'],
            views: element['views'],
            rating: double.parse(element['rating'].toString()),
            location: PropertyLocation(
              country: element['location']['country'],
              latitude: element['location']['latitude'],
              longitude: element['location']['longitude'],
              town: element['location']['town'],
            ),
            images: element['images'],
            reviews: element['reviews'],
            ownerId: element['ownerId'],
            propertyOwner: element['ownerName'],
            propertyCategory: element['propertyCategory'],
            description: element['description'],
            offers: element['offers'],
            panoramicView: element['view360']
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
            services: element['services']
                .map<ServiceModel>(
                  (s) => ServiceModel(
                    category: s['category'],
                    price: double.parse(s['price'].toString()),
                    name: s['name'],
                    status: s['status'],
                    imageUrl: s['imageUrl'],
                  ),
                )
                .toList()));
      });
    }

    if (filter.name.isNotEmpty) {
      results.docs
          .where((element) =>
              element
                  .data()['name']
                  .toLowerCase()
                  .contains(filter.name.toLowerCase()) ||
              element
                  .data()['location']['town']
                  .toLowerCase()
                  .contains(filter.name.toLowerCase()) ||
              element
                  .data()['location']['country']
                  .toLowerCase()
                  .contains(filter.name.toLowerCase()) ||
              element
                  .data()['propertyCategory']
                  .toLowerCase()
                  .contains(filter.name.toLowerCase()) ||
              element
                  .data()['description']
                  .toLowerCase()
                  .contains(filter.name.toLowerCase()))
          .forEach((element) {
        propData.add(PropertyModel(
            id: element.id,
            name: element['name'],
            rates: element['rates'],
            coverImage: element['coverImage'],
            ammenities: element['ammenities'],
            price: element['price'],
            views: element['views'],
            rating: double.parse(element['rating'].toString()),
            location: PropertyLocation(
              country: element['location']['country'],
              latitude: element['location']['latitude'],
              longitude: element['location']['longitude'],
              town: element['location']['town'],
            ),
            images: element['images'],
            reviews: element['reviews'],
            ownerId: element['ownerId'],
            propertyOwner: element['ownerName'],
            propertyCategory: element['propertyCategory'],
            description: element['description'],
            offers: element['offers'],
            panoramicView: element['view360']
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
            services: element['services']
                .map<ServiceModel>(
                  (s) => ServiceModel(
                    category: s['category'],
                    price: double.parse(s['price'].toString()),
                    name: s['name'],
                    status: s['status'],
                    imageUrl: s['imageUrl'],
                  ),
                )
                .toList()));
      });
    }
    if (filter.price != null) {
      results.docs
          .where((element) =>
              double.parse(element.data()['price']) <= filter.price)
          .forEach((element) {
        propData.add(PropertyModel(
            id: element.id,
            name: element['name'],
            coverImage: element['coverImage'],
            ammenities: element['ammenities'],
            price: element['price'],
            rates: element['rates'],
            views: element['views'],
            rating: double.parse(element['rating'].toString()),
            location: PropertyLocation(
              country: element['location']['country'],
              latitude: element['location']['latitude'],
              longitude: element['location']['longitude'],
              town: element['location']['town'],
            ),
            images: element['images'],
            reviews: element['reviews'],
            ownerId: element['ownerId'],
            propertyOwner: element['ownerName'],
            propertyCategory: element['propertyCategory'],
            description: element['description'],
            offers: element['offers'],
            panoramicView: element['view360']
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
            services: element['services']
                .map<ServiceModel>(
                  (s) => ServiceModel(
                    category: s['category'],
                    price: double.parse(s['price'].toString()),
                    name: s['name'],
                    status: s['status'],
                    imageUrl: s['imageUrl'],
                  ),
                )
                .toList()));
      });
    }
    if (filter.rating != null) {
      results.docs
          .where((element) => element.data()['rating'] <= filter.rating)
          .forEach((element) {
        propData.add(PropertyModel(
            id: element.id,
            name: element['name'],
            coverImage: element['coverImage'],
            ammenities: element['ammenities'],
            price: element['price'],
            rates: element['rates'],
            views: element['views'],
            rating: double.parse(element['rating'].toString()),
            location: PropertyLocation(
              country: element['location']['country'],
              latitude: element['location']['latitude'],
              longitude: element['location']['longitude'],
              town: element['location']['town'],
            ),
            images: element['images'],
            reviews: element['reviews'],
            ownerId: element['ownerId'],
            propertyOwner: element['ownerName'],
            propertyCategory: element['propertyCategory'],
            description: element['description'],
            offers: element['offers'],
            panoramicView: element['view360']
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
            services: element['services']
                .map<ServiceModel>(
                  (s) => ServiceModel(
                    category: s['category'],
                    price: double.parse(s['price'].toString()),
                    name: s['name'],
                    status: s['status'],
                    imageUrl: s['imageUrl'],
                  ),
                )
                .toList()));
      });
    }

    if (filter.location != null) {
      results.docs
          .where((element) => element
              .data()['location']['town']
              .toLowerCase()
              .contains(filter.location.toLowerCase()))
          .forEach((element) {
        propData.add(PropertyModel(
            id: element.id,
            name: element['name'],
            coverImage: element['coverImage'],
            ammenities: element['ammenities'],
            rates: element['rates'],
            price: element['price'],
            views: element['views'],
            rating: double.parse(element['rating'].toString()),
            location: PropertyLocation(
              country: element['location']['country'],
              latitude: element['location']['latitude'],
              longitude: element['location']['longitude'],
              town: element['location']['town'],
            ),
            images: element['images'],
            reviews: element['reviews'],
            ownerId: element['ownerId'],
            propertyOwner: element['ownerName'],
            propertyCategory: element['propertyCategory'],
            description: element['description'],
            offers: element['offers'],
            panoramicView: element['view360']
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
            services: element['services']
                .map<ServiceModel>(
                  (s) => ServiceModel(
                    category: s['category'],
                    price: double.parse(s['price'].toString()),
                    name: s['name'],
                    status: s['status'],
                    imageUrl: s['imageUrl'],
                  ),
                )
                .toList()));
      });
    }

    if (filter.category != null) {
      results.docs
          .where((element) =>
              element.data()['propertyCategory'] == filter.category)
          .forEach((element) {
        propData.add(PropertyModel(
            id: element.id,
            name: element['name'],
            coverImage: element['coverImage'],
            ammenities: element['ammenities'],
            price: element['price'],
            rates: element['rates'],
            views: element['views'],
            rating: double.parse(element['rating'].toString()),
            location: PropertyLocation(
              country: element['location']['country'],
              latitude: element['location']['latitude'],
              longitude: element['location']['longitude'],
              town: element['location']['town'],
            ),
            images: element['images'],
            reviews: element['reviews'],
            ownerId: element['ownerId'],
            propertyOwner: element['ownerName'],
            propertyCategory: element['propertyCategory'],
            description: element['description'],
            offers: element['offers'],
            panoramicView: element['view360']
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
            services: element['services']
                .map<ServiceModel>(
                  (s) => ServiceModel(
                    category: s['category'],
                    price: double.parse(s['price'].toString()),
                    name: s['name'],
                    status: s['status'],
                    imageUrl: s['imageUrl'],
                  ),
                )
                .toList()));
      });
    }

    if (filter.ammenities != null) {
      filter.ammenities.forEach((e) {
        results.docs
            .where((element) => element.data()['ammenities'].contains(e))
            .forEach((element) {
          propData.add(PropertyModel(
              id: element.id,
              name: element['name'],
              coverImage: element['coverImage'],
              ammenities: element['ammenities'],
              price: element['price'],
              rates: element['rates'],
              views: element['views'],
              rating: double.parse(element['rating'].toString()),
              location: PropertyLocation(
                country: element['location']['country'],
                latitude: element['location']['latitude'],
                longitude: element['location']['longitude'],
                town: element['location']['town'],
              ),
              images: element['images'],
              reviews: element['reviews'],
              ownerId: element['ownerId'],
              propertyOwner: element['ownerName'],
              propertyCategory: element['propertyCategory'],
              description: element['description'],
              offers: element['offers'],
              panoramicView: element['view360']
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
              services: element['services']
                  .map<ServiceModel>(
                    (s) => ServiceModel(
                      category: s['category'],
                      price: double.parse(s['price'].toString()),
                      name: s['name'],
                      status: s['status'],
                      imageUrl: s['imageUrl'],
                    ),
                  )
                  .toList()));
        });
      });

      // if (filter.category != null) {
      //   filter.ammenities.forEach((e) {
      //     results.docs
      //         .where((element) => element.data()['type'].contains(e))
      //         .forEach((element) {
      //       propData.add(PropertyModel(
      //         id: element.id,
      //         name: element['name'],
      //         coverImage: element['coverImage'],
      //         ammenities: element['ammenities'],
      //         price: element['price'],
      //         views: element['views'],
      //         rating: double.parse(element['rating'].toString()),
      //         location: PropertyLocation(
      //           country: element['location']['country'],
      //           latitude: element['location']['latitude'],
      //           longitude: element['location']['longitude'],
      //           town: element['location']['town'],
      //         ),
      //
      //         images: element['images'],
      //         reviews: element['reviews'],
      //         ownerId: element['ownerId'],
      //         propertyOwner: element['ownerName'],
      //         propertyCategory: element['propertyCategory'],
      //         description: element['description'],
      //         offers: element['offers'],
      //       ));
      //     });
      //   });
      // }
    }
    _yourSearch = propData;
    print('Completed search');
    notifyListeners();
  }

  void clearSearch() {
    _yourSearch = [];
    notifyListeners();
  }

  Future<void> getNearbyServices(PropertyModel property) async {
    final results = await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .where('type', isEqualTo: 'Activity')
        .get();
    List<PropertyModel> propData = [];

    results.docs
        .where((element) =>
            (element['location']['latitude'] >
                element['location']['latitude'] - 1.5) &&
            (element['location']['latitude'] <
                element['location']['latitude'] + 1.5) &&
            (element['location']['longitude'] >
                element['location']['longitude'] - 5) &&
            (element['location']['longitude'] <
                element['location']['longitude'] + 5))
        .forEach((e) {
      propData.add(PropertyModel(
          id: e.id,
          name: e['name'],
          coverImage: e['coverImage'],
          ammenities: e['ammenities'],
          price: e['price'],
          views: e['views'],
          rates: e['rates'],
          rating: double.parse(e['rating'].toString()),
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
              .toList()));
    });
    _nearbyServices = propData;

    notifyListeners();
  }

  Future<void> searchService(String search) async {
    final results = await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .where('propertyCategory', isEqualTo: 'Activity')
        .get();

    List<PropertyModel> propData = [];

    results.docs
        .where(
      (element) =>
          element['name'].toLowerCase().contains(search.toLowerCase()) ||
          element['location']['country'].toLowerCase() ==
              search.toLowerCase() ||
          element['location']['town']
              .toLowerCase()
              .contains(search.toLowerCase()) ||
          element['description'].toLowerCase().contains(search.toLowerCase()),
    )
        .forEach((element) {
      propData.add(PropertyModel(
          id: element.id,
          name: element['name'],
          coverImage: element['coverImage'],
          ammenities: element['ammenities'],
          price: element['price'],
          rates: element['rates'],
          views: element['views'],
          rating: double.parse(element['rating'].toString()),
          location: PropertyLocation(
            country: element['location']['country'],
            latitude: element['location']['latitude'],
            longitude: element['location']['longitude'],
            town: element['location']['town'],
          ),
          images: element['images'],
          reviews: element['reviews'],
          ownerId: element['ownerId'],
          propertyOwner: element['ownerName'],
          propertyCategory: element['propertyCategory'],
          description: element['description'],
          offers: element['offers'],
          panoramicView: element['view360']
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
          services: element['services']
              .map<ServiceModel>(
                (s) => ServiceModel(
                  category: s['category'],
                  price: double.parse(s['price'].toString()),
                  name: s['name'],
                  status: s['status'],
                  imageUrl: s['imageUrl'],
                ),
              )
              .toList()));
    });
    _nearbyServices = propData;
    print(_nearbyServices.length);

    notifyListeners();
  }
}
