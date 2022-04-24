import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/screens/property_details/widgets/details_photos.dart';
import 'package:roomy/screens/property_details/widgets/other_amenities.dart';
import 'package:roomy/screens/property_details/widgets/property_details_location.dart';
import 'package:roomy/widgets/property/properties.dart';

class DetailsDescription extends StatelessWidget {
  final PropertyModel property;
  DetailsDescription(this.property);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<String> images = [...property.images];
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
        ReadMoreText(
          property.description,
          trimLines: 7,
          colorClickableText: kPrimary,
          style: const TextStyle(fontSize: 16),
        ),
        DetailsPhotos(images),
        if (property.propertyCategory.toLowerCase() != 'activity')
          OtherAmenities(property),
        PropertyDetailsLocation(property),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            property.propertyCategory.toLowerCase() != 'activity'
                ? 'Related Places'
                : 'Related Services',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: size.height * 0.245,
          constraints: BoxConstraints(minHeight: 200),
          child: RelatedProperties(
              category: property.propertyCategory, parentId: property.id),
        ),
      ]),
    );
  }
}
