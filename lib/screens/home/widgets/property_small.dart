import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/helpers/country_helpers.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/providers/property_provider.dart';
import 'package:roomy/screens/property_details/property_details_screen.dart';
import 'package:roomy/widgets/cached_image.dart';

class PropertySmall extends StatelessWidget {
  final PropertyModel property;
  PropertySmall(this.property);

  @override
  Widget build(BuildContext context) {
    final action = Provider.of<PropertyProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.4,
      height: size.height * 0.29,
      constraints: BoxConstraints(minHeight: 260),
      margin: const EdgeInsets.only(right: 10, bottom: 5),
      child: GestureDetector(
        onTap: () {
          action.addView(
            property.id,
          );
          action.addHistory(
            property.id,
          );
          Navigator.of(context)
              .pushNamed(PropertyDetailsScreen.routeName, arguments: property);
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
                Container(
                    height: size.height * 0.16,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          child: Hero(
                            tag: property.id,
                            child: cachedImage(
                              property.coverImage,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  SizedBox(
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
                  child: Container(
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: kPrimary,
                                  size: 12,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${property.location.town}, ${countryAbbrevation(property.location.country)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'From',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            SizedBox(
                              height: 2.5,
                            ),
                            // Row(
                            //   children: [
                            Text(
                              'KES ${property.price} ',
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: kPrimary,
                                  fontWeight: FontWeight.bold),
                            ),
                            //     Text(
                            //       property.rates,
                            //       style: const TextStyle(
                            //           fontSize: 14,
                            //           color: kPrimary,
                            //           fontWeight: FontWeight.w300),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
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
