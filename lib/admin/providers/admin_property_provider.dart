import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:roomy/models/property_model.dart';

class AdminPropertyProvider with ChangeNotifier {
  List<PropertyModel> _properties;

  List<PropertyModel> get properties => [..._properties];

  Future<void> sendProperty(PropertyModel property) async {
    final id = FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .doc()
        .id;

    List<String> imageUrls = [];
    List<String> serviceUrls = [];
    List<String> panoramas = [];

    final coverData = await FirebaseStorage.instance
        .ref('property/propertyData/$id/coverImage/')
        .putFile(property.coverFile);
    final coverUrl = await coverData.ref.getDownloadURL();
    /////////////////////////////////////////////////////////////////
    await Future.forEach(property.services, (element) async {
      final serviceData = await FirebaseStorage.instance
          .ref(
              'property/propertyData/$id/services/${DateTime.now().toIso8601String()}/')
          .putFile(element.image);
      final url = await serviceData.ref.getDownloadURL();
      serviceUrls.add(url);
    });
//////////////////////////////////////////////////////////////////

    if (property.panoramicView != null) {
      await Future.forEach(property.panoramicView, (element) async {
        final panorama = await FirebaseStorage.instance
            .ref(
                'property/propertyData/$id/panorama/${DateTime.now().toIso8601String()}/')
            .putFile(element.image);
        final url = await panorama.ref.getDownloadURL();

        panoramas.add(url);
      });
    }
/////////////////////////////////////////////////////////////////
    await Future.forEach(property.imageFiles, (element) async {
      final key = UniqueKey();

      final urlData = await FirebaseStorage.instance
          .ref('property/propertyData/$id/images/${key.toString()}}')
          .putFile(element);
      final url = await urlData.ref.getDownloadURL();
      imageUrls.add(url);
    }).then((_) => FirebaseFirestore.instance
            .collection('propertyData')
            .doc('propertyListing')
            .collection('properties')
            .doc(id)
            .set({
          'id': id,
          'description': property.description,
          'images': imageUrls,
          'name': property.name,
          'price': property.price,
          'propertyCategory': property.propertyCategory,
          'rates': property.rates.toLowerCase(),
          'ownerId': property.ownerId,
          'rating': 0,
          'views': 0,
          'likes': 0,
          'bookings': 0,
          'tags': property.tags,
          'coverImage': coverUrl,
          'offers': [],
          'reviews': [],
          'ownerName': property.propertyOwner,
          'location': property.location.toJson(),
          'ammenities': property.ammenities,
          'createdAt': Timestamp.now(),
          'view360': List.generate(
              property.panoramicView.length,
              (i) => {
                    'hotspots': property.panoramicView[i].hotspots,
                    'id': DateTime.now().toIso8601String(),
                    'image': panoramas[i],
                    'name': property.panoramicView[i].name,
                  }),
          'services': List.generate(
              property.services.length,
              (index) => {
                    'category': property.propertyCategory,
                    'name': null,
                    'price': property.services[index].price,
                    'status': 'Available',
                    'imageUrl': serviceUrls[index]
                  })
        }));

    notifyListeners();
  }

  Future<void> editProperty(PropertyModel property) async {
    final id = property.id;

    List<String> imageUrls = [];
    List<String> serviceUrls = [];
    List<String> panoramas = [];
    String coverUrl;
    if (property.coverImage != null) {
      final coverData = await FirebaseStorage.instance
          .ref('property/propertyData/$id/coverImage/')
          .putFile(property.coverFile);
      coverUrl = await coverData.ref.getDownloadURL();
    }
    /////////////////////////////////////////////////////////////////
    if (property.services.isNotEmpty) {
      await Future.forEach(property.services, (element) async {
        final serviceData = await FirebaseStorage.instance
            .ref(
                'property/propertyData/$id/services/${DateTime.now().toIso8601String()}/')
            .putFile(element.image);
        final url = await serviceData.ref.getDownloadURL();
        serviceUrls.add(url);
      });
    }
//////////////////////////////////////////////////////////////////

    if (property.panoramicView != null) {
      await Future.forEach(property.panoramicView, (element) async {
        final panorama = await FirebaseStorage.instance
            .ref(
                'property/propertyData/$id/panorama/${DateTime.now().toIso8601String()}/')
            .putFile(element.image);
        final url = await panorama.ref.getDownloadURL();

        panoramas.add(url);
      });
    }
/////////////////////////////////////////////////////////////////
    if (property.imageFiles.isNotEmpty) {
      await Future.forEach(property.imageFiles, (element) async {
        final key = UniqueKey();

        final urlData = await FirebaseStorage.instance
            .ref('property/propertyData/$id/images/${key.toString()}}')
            .putFile(element);
        final url = await urlData.ref.getDownloadURL();
        imageUrls.add(url);
      });
    }
    await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .doc(id)
        .update({
      'description': property.description,
      'images': FieldValue.arrayUnion(imageUrls),
      'name': property.name,
      'price': property.price,
      'propertyCategory': property.propertyCategory,
      'rates': property.rates.toLowerCase(),
      'tags': FieldValue.arrayUnion(property.tags),
      'coverImage': coverUrl ?? property.coverImage,
      'location': property.location.toJson(),
      'ammenities': property.ammenities,
      'updatedAt': Timestamp.now(),
      'view360': FieldValue.arrayUnion(List.generate(
          property.panoramicView.length,
          (i) => {
                'hotspots': property.panoramicView[i].hotspots,
                'id': DateTime.now().toIso8601String(),
                'image': panoramas[i],
                'name': property.panoramicView[i].name,
              })),
      'services': FieldValue.arrayUnion(List.generate(
          property.services.length,
          (index) => {
                'category': property.propertyCategory,
                'name': null,
                'price': property.services[index].price,
                'status': 'Available',
                'imageUrl': serviceUrls[index]
              }))
    });

    notifyListeners();
  }

  Future<void> deleteTravely(String id) async {
    await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .doc(id)
        .delete();
    notifyListeners();
  }
}
