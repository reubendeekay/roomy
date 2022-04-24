import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/helpers/country_helpers.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/widgets/cached_image.dart';

class ActivityFullscreen extends StatefulWidget {
  static const routeName = '/activity-fullscreen';
  final Function(bool property) onPressed;
  final PropertyModel property;
  final bool isSelected;
  ActivityFullscreen({this.onPressed, this.property, this.isSelected});

  @override
  _ActivityFullscreenState createState() => _ActivityFullscreenState();
}

class _ActivityFullscreenState extends State<ActivityFullscreen> {
  bool isTapped = false;
  final CarouselController carouselController = CarouselController();
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isTapped = !isTapped;
              });
            },
            child: Container(
              child: CarouselSlider(
                carouselController: carouselController,
                options: CarouselOptions(
                  height: size.height,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: Duration(seconds: 8),
                  autoPlayAnimationDuration: Duration(seconds: 2),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  // enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
                items: widget.property.images
                    .map(
                      (e) => Container(
                        width: size.width,
                        height: size.height,
                        child: cachedImage(
                          e,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: isTapped ? -size.height * 0.5 : 0,
            child: Container(
              color: Colors.black54,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.property.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Text(
                          'KES ${widget.property.price}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 12,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${widget.property.location.town}, ${countryAbbrevation(widget.property.location.country)}',
                          style: TextStyle(fontSize: 12),
                        ),
                        Spacer(),
                        // if (isSelected)
                        AnimatedOpacity(
                          opacity: isSelected ? 1 : 0,
                          duration: Duration(milliseconds: 200),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: kPrimary,
                                size: 16,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Selected',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  )
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 350),
            bottom: isTapped ? -size.height * 0.7 : 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(widget.property.description),
                  ),
                  Container(
                    width: size.width,
                    height: 45,
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          isSelected = !isSelected;
                        });
                        widget.onPressed(isSelected);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: kPrimary,
                      child: Text(
                        isSelected ? 'Unselect' : 'Select',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isTapped)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          carouselController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.fastLinearToSlowEaseIn);
                        },
                        child: AnimatedOpacity(
                          opacity: isTapped ? 0 : 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: Container(
                            height: 45,
                            width: 45,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.black54, shape: BoxShape.circle),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          carouselController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.fastLinearToSlowEaseIn);
                        },
                        child: AnimatedOpacity(
                          opacity: isTapped ? 0 : 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: Container(
                            height: 45,
                            width: 45,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.black54, shape: BoxShape.circle),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}
