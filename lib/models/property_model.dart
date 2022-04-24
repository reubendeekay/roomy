import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roomy/models/service_model.dart';
import 'package:roomy/models/view360_model.dart';

class PropertyModel {
  final String name;
  final String id;
  final int bookings;
  final List<File> imageFiles;
  final List<dynamic> images;
  final File coverFile;
  final String coverImage;
  final String description;
  final String price;
  final String rates;
  final PropertyLocation location;
  final List<dynamic> ammenities;
  final String propertyOwner;
  final String ownerId;
  final List<dynamic> reviews;
  final List<dynamic> offers;
  final String propertyCategory;
  final double rating;
  final List<dynamic> tags;
  final int views;
  List<ServiceModel> services;
  List<View360Model> panoramicView = [];

  PropertyModel(
      {this.name,
      this.id,
      this.bookings,
      this.coverImage,
      this.imageFiles,
      this.description,
      this.price,
      this.location,
      this.ammenities,
      this.propertyOwner,
      this.tags,
      this.rates,
      this.ownerId,
      this.reviews,
      this.offers,
      this.propertyCategory,
      this.coverFile,
      this.images,
      this.rating,
      this.views,
      this.panoramicView,
      this.services});
}

class PropertyLocation {
  final double latitude;
  final double longitude;
  final String town;
  final String country;

  const PropertyLocation({
    this.latitude,
    this.longitude,
    this.country,
    this.town,
  });

  Map<String, Object> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'town': town,
    };
  }
}

class ReviewModel {
  final String nameOfReviewer;
  final double rating;
  final String review;
  final Timestamp dateReviewed;
  final String profilePic;

  ReviewModel(
      {this.nameOfReviewer,
      this.rating,
      this.review,
      this.dateReviewed,
      this.profilePic});

  Map<String, dynamic> toJson() {
    return {
      'nameOfReviewer': nameOfReviewer,
      'rating': rating,
      'review': review,
      'dateReviewed': dateReviewed,
      'profilePic': profilePic
    };
  }
}
