import 'dart:io';

class View360Model {
  final String imageUrl;
  final File image;
  final String name;
  final String id;

  final List<ImageHotspot> hotspots;

  View360Model({this.imageUrl, this.image, this.name, this.id, this.hotspots});
}

class ImageHotspot {
  final double longitude;
  final double latitude;
  final String name;
  final String idNext;

  ImageHotspot({this.longitude, this.latitude, this.name, this.idNext});
}
