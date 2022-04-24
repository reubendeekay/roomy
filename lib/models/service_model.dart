import 'dart:io';

class ServiceModel {
  final String imageUrl;
  final File image;
  final String status;
  final double price;
  final String name;
  final String category;

  ServiceModel(
      {this.imageUrl,
      this.image,
      this.status,
      this.price,
      this.name,
      this.category});
}
