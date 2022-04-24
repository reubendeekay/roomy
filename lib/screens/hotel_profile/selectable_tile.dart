import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/helpers/country_helpers.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/providers/booking_provider.dart';
import 'package:roomy/screens/hotel_profile/activity_fullscreen.dart';

import 'package:roomy/widgets/cached_image.dart';
import 'package:roomy/widgets/rating_bar.dart';

class SelectablePropertyTile extends StatefulWidget {
  final PropertyModel property;
  SelectablePropertyTile(
    this.property,
  );

  @override
  _SelectablePropertyTileState createState() => _SelectablePropertyTileState();
}

class _SelectablePropertyTileState extends State<SelectablePropertyTile> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async {
        await Provider.of<BookingProvider>(context, listen: false)
            .addActivity(widget.property);
        setState(() {
          isSelected = !isSelected;
        });
      },
      onLongPress: () {
        Get.to(
          () => ActivityFullscreen(
              property: widget.property,
              isSelected: isSelected,
              onPressed: (val) async {
                setState(() {
                  isSelected = val;
                });
                await Provider.of<BookingProvider>(context, listen: false)
                    .addActivity(widget.property);
              }),
        );
      },
      child: Stack(
        children: [
          if (isSelected)
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              height: size.width * 0.25,
              width: size.width,
              color: kPrimary.withOpacity(0.2),
            ),
          Container(
            height: size.width * 0.25,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: cachedImage(widget.property.coverImage,
                          fit: BoxFit.cover)),
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
                          widget.property.name,
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
                              '${widget.property.location.town}, ${countryAbbrevation(widget.property.location.country)}',
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
                        rating: widget.property.rating,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            'KES ${widget.property.price}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
