import 'dart:io';

import 'package:flutter/material.dart';
import 'package:roomy/admin/screens/property_review_details/widgets/admin_details_photos.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/screens/property_details/widgets/other_amenities.dart';
import 'package:roomy/screens/property_details/widgets/property_details_location.dart';

class DetailsDescription extends StatelessWidget {
  final PropertyModel property;
  DetailsDescription(this.property);
  @override
  Widget build(BuildContext context) {
    List<File> images = [...property.imageFiles];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          'Description',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          property.description,
          overflow: TextOverflow.fade,
          style: const TextStyle(fontSize: 16),
        ),
        AdminDetailsPhotos(images),
        PropertyDetailsLocation(property),
        OtherAmenities(property),
      ]),
    );
  }
}
