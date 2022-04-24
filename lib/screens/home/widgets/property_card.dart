import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomy/helpers/country_helpers.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/providers/property_provider.dart';
import 'package:roomy/screens/property_details/property_details_screen.dart';
import 'package:roomy/widgets/cached_image.dart';

class PropertyCard extends StatelessWidget {
  final PropertyModel property;
  PropertyCard(this.property);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final action = Provider.of<PropertyProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      color: Theme.of(context).cardColor,
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    blurRadius: 1,
                    color: Theme.of(context).shadowColor,
                    spreadRadius: 1)
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  child: Stack(
                    children: [
                      Container(
                        // height: 250,
                        width: size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
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
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(
                            8,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.black26.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(property.rating.toStringAsFixed(1),
                                  style: TextStyle(
                                      color: Colors.grey[200], fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  property.name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 5,
                                          color: Colors.black45,
                                        )
                                      ],
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: size.width,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        '${property.location.town}, ${countryAbbrevation(property.location.country)}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 5,
                                                color: Colors.black45,
                                              )
                                            ],
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Spacer(),
                                      Row(
                                        children: [
                                          Text(
                                            'KES${property.price} ',
                                            style: TextStyle(
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 5,
                                                    color: Colors.black45,
                                                  )
                                                ],
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            property.rates,
                                            style: TextStyle(
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 5,
                                                    color: Colors.black45,
                                                  )
                                                ],
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
