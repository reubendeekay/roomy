import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/helpers/country_helpers.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/providers/property_provider.dart';
import 'package:roomy/screens/property_details/property_details_screen.dart';
import 'package:roomy/widgets/cached_image.dart';
import 'package:roomy/widgets/rating_bar.dart';

class HotelPropertyTile extends StatelessWidget {
  final PropertyModel property;
  HotelPropertyTile(this.property);

  @override
  Widget build(BuildContext context) {
    final action = Provider.of<PropertyProvider>(context, listen: false);

    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        action.addView(property.id);
        action.addHistory(property.id);
        Navigator.of(context)
            .pushNamed(PropertyDetailsScreen.routeName, arguments: property);
      },
      child: Column(
        children: [
          Container(
            height: size.width * 0.25,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:
                          cachedImage(property.coverImage, fit: BoxFit.cover)),
                  width: size.width * 0.26,
                  height: size.width * 0.25,
                ),
                FittedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 2.5),
                        child: Text(
                          property.name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.grey,
                              size: 16,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              '${property.location.town}, ${countryAbbrevation(property.location.country)}',
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Ratings(
                        size: 15,
                        rating: property.rating,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            'KES ${property.price}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: kPrimary),
                          ),
                          Text(
                            ' per night',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: kPrimary),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
