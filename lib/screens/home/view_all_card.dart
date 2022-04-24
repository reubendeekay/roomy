import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/helpers/country_helpers.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/providers/property_provider.dart';
import 'package:roomy/screens/property_details/property_details_screen.dart';
import 'package:roomy/widgets/cached_image.dart';

class ViewAllCard extends StatefulWidget {
  final PropertyModel property;
  ViewAllCard(this.property);

  @override
  State<ViewAllCard> createState() => _ViewAllCardState();
}

class _ViewAllCardState extends State<ViewAllCard> {
  IconData getCategoryIcon() {
    switch (widget.property.propertyCategory.toLowerCase()) {
      case 'hotel':
        return FontAwesomeIcons.hotel;
        break;
      case 'restaurant':
        return FontAwesomeIcons.pizzaSlice;
        break;
      case 'shopping':
        return FontAwesomeIcons.shoppingBag;
        break;
      case 'activity':
        return FontAwesomeIcons.swimmingPool;
        break;
      case 'transport':
        return FontAwesomeIcons.car;
        break;
      case 'flight':
        return FontAwesomeIcons.planeArrival;
        break;
      case 'residence':
        return FontAwesomeIcons.building;
        break;
      case 'event':
        return FontAwesomeIcons.campground;
        break;
      default:
        return FontAwesomeIcons.globe;
    }
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final action = Provider.of<PropertyProvider>(context, listen: false);
    final List<String> images = [
      widget.property.coverImage,
      ...widget.property.images
    ];

    return GestureDetector(
      onTap: () {
        action.addView(widget.property.id);
        action.addHistory(widget.property.id);
        Navigator.of(context).pushNamed(PropertyDetailsScreen.routeName,
            arguments: widget.property);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).cardColor,
        ),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          children: [
            Stack(
              children: [
                CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                        autoPlay: false,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        disableCenter: true,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                    items: List.generate(
                        images.length,
                        (i) => ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5)),
                            child: cachedImage(
                              images[i],
                              fit: BoxFit.cover,
                            )))),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: images.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                            width: _current == entry.key ? 8.0 : 6.0,
                            height: _current == entry.key ? 8.0 : 6.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == entry.key
                                    ? kPrimary
                                    : Colors.grey[300])),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(3)),
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  width: 120,
                  child: Row(
                    children: [
                      Text(
                        '${widget.property.rating} ',
                        style: TextStyle(
                            color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '(${widget.property.reviews == null ? 0 : widget.property.reviews.length} reviews)',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'KES ${widget.property.price} ',
                        style: TextStyle(
                            color: kPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        widget.property.rates,
                        style: TextStyle(color: kPrimary, fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        widget.property.name,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            height: 1.3),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.circle,
                        size: 5,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          FaIcon(
                            getCategoryIcon(),
                            color: Colors.grey,
                            size: 10,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${widget.property.propertyCategory}',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey,
                      size: 14,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${widget.property.location.town}, ${countryAbbrevation(widget.property.location.country)}',
                      style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
