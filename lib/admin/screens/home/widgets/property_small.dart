import 'package:flutter/material.dart';
import 'package:roomy/admin/constants.dart';

import 'package:roomy/helpers/country_helpers.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/screens/property_details/widgets/property_actions.dart';
import 'package:roomy/admin/widgets/cached_image.dart';

class AdminPropertySmall extends StatelessWidget {
  final PropertyModel property;
  AdminPropertySmall(this.property);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.4,
      height: size.height * 0.29,
      margin: const EdgeInsets.only(right: 10, bottom: 5),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (ctx) => PropertyActions(property));
        },
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              // boxShadow: [
              // BoxShadow(
              //     blurRadius: 1,
              //     color: Theme.of(context).shadowColor,
              //     spreadRadius: 1)
              // ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: size.height * 0.16,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          child: cachedImage(
                            property.coverImage,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(
                                8,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.black26.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(property.rating.toStringAsFixed(1),
                                      style: TextStyle(
                                          color: Colors.grey[200],
                                          fontSize: 14)),
                                ],
                              ),
                            ))
                      ],
                    )),
                Expanded(
                  child: FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            property.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: kPrimary,
                                size: 12,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${property.location.town}, ${countryAbbrevation(property.location.country)}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                'KES ${property.price} ',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: kPrimary,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                property.rates,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: kPrimary,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
