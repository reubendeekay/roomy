import 'package:flutter/material.dart';
import 'package:roomy/screens/property_details/widgets/property_actions.dart';

import 'package:roomy/admin/widgets/cached_image.dart';
import 'package:roomy/admin/constants.dart';

import 'package:roomy/admin/widgets/rating_bar.dart';
import 'package:roomy/helpers/country_helpers.dart';
import 'package:roomy/models/property_model.dart';

class AdminPropertyCard extends StatelessWidget {
  final PropertyModel property;
  AdminPropertyCard(this.property);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (ctx) => PropertyActions(property));
      },
      child: Column(
        children: [
          Container(
            height: size.width * 0.25,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child:
                          cachedImage(property.coverImage, fit: BoxFit.cover)),
                  width: size.width * 0.3,
                  height: size.width * 0.25,
                ),
                FittedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 2.5),
                        child: Text(
                          property.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            '${property.location.town}, ${countryAbbrevation(property.location.country)}',
                            style: const TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Ratings(
                        size: 15,
                        rating: property.rating,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            'KES ${property.price}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kPrimary),
                          ),
                          Text(
                            ' ' + property.rates,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: kPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
