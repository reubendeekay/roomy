import 'dart:io';

class AdModel {
  final String id;
  final String adType;
  final File imageFile;
  final String imageUrl;
  final String conversion;
  final String country;
  final String ownerId;
  final String category;
  final String propertyId;
  final String searchTerm;
  final String clickUrl;
  final String description;

  AdModel({
    this.id,
    this.adType,
    this.imageFile,
    this.imageUrl,
    this.conversion,
    this.country,
    this.ownerId,
    this.category,
    this.propertyId,
    this.searchTerm,
    this.clickUrl,
    this.description,
  });
}
