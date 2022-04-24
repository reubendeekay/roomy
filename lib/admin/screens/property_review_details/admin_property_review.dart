import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomy/admin/constants.dart';
import 'package:roomy/admin/providers/admin_property_provider.dart';
import 'package:roomy/admin/screens/auth/widgets/loading_screen.dart';

import 'package:roomy/admin/screens/property_review_details/widgets/admin_details_description.dart';

import 'package:roomy/admin/screens/property_review_details/widgets/top_images.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/providers/location_provider.dart';

class AdminPropertyReview extends StatefulWidget {
  static const routeName = '/property-review-details';

  @override
  _AdminPropertyReviewState createState() => _AdminPropertyReviewState();
}

class _AdminPropertyReviewState extends State<AdminPropertyReview> {
  bool isLiked = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final property = ModalRoute.of(context).settings.arguments as PropertyModel;

    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: isLoading
            ? LoadingScreen()
            : Stack(clipBehavior: Clip.none, children: [
                SafeArea(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.transparent,
                        expandedHeight: size.height * 0.4,
                        floating: false,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Text('',
                              style: TextStyle(fontSize: 15.0, shadows: [
                                Shadow(
                                    color: Theme.of(context).primaryColor,
                                    blurRadius: 5)
                              ])),
                          background: AdminTopImages(
                              [property.coverFile, ...property.imageFiles]),
                        ),
                      ),
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (context, i) => DetailsBody(property),
                              childCount: 1))
                    ],
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 5),
                      width: size.width,
                      color: Colors.white,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$ ${property.price}/${property.rates.toLowerCase()}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimary),
                            ),
                            const Spacer(),
                            RaisedButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });

                                Future.wait([
                                  Provider.of<AdminPropertyProvider>(context,
                                          listen: false)
                                      .sendProperty(property)
                                ]).then((_) => setState(() {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Provider.of<LocationProvider>(context,
                                              listen: false)
                                          .clearLocation();
                                    }));
                              },
                              color: kPrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 12),
                                  child: isLoading
                                      ? const CircularProgressIndicator()
                                      : const Text(
                                          'Confirm & Post',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )),
                            )
                          ]),
                    )),
                SafeArea(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back,
                              color: kPrimary,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                            child: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: kPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
      ),
    );
  }
}

class DetailsBody extends StatefulWidget {
  final PropertyModel property;
  DetailsBody(this.property);
  @override
  _DetailsBodyState createState() => _DetailsBodyState();
}

class _DetailsBodyState extends State<DetailsBody> {
  int selectedOption = 0;

  @override
  Widget build(BuildContext context) {
    List screens = [
      DetailsDescription(widget.property),

      // PropertyReviews(
      //   property: widget.property,
      // ),
    ];
    final size = MediaQuery.of(context).size;
    return Container(
        // height: size.height * 0.55,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.grey[50]]),
        ),
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: kPrimary,
                  size: 16,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '${widget.property.location.town}, ${widget.property.location.country}',
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  widget.property.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 16,
                ),
                const Text(
                  '0 Reviews',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: const [
              Text(
                'High-speed wifi',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.circle,
                size: 6,
                color: kPrimary,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Deskspace',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.circle,
                size: 6,
                color: kPrimary,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Safe location',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
              ),
            ]),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.bed,
                      color: kPrimary,
                      size: 30,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      '2',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Icon(
                      Icons.bathtub_outlined,
                      color: kPrimary,
                      size: 30,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      '1',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Icon(
                      Icons.room_service_outlined,
                      color: kPrimary,
                      size: 30,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      '1',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              thickness: 1,
              height: 2,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = 0;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 30,
                          color:
                              selectedOption == 0 ? kPrimary : Colors.grey[300],
                        ),
                        Text(
                          'Information',
                          style: TextStyle(
                              color: selectedOption == 0
                                  ? kPrimary
                                  : Colors.grey[300],
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.comment_outlined,
                        size: 30,
                        color: Colors.grey[300],
                      ),
                      Text(
                        'Reviews',
                        style: TextStyle(
                            color: Colors.grey[300],
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.local_offer_outlined,
                        size: 30,
                        color: Colors.grey[300],
                      ),
                      Text(
                        'Offers',
                        style: TextStyle(
                            color: Colors.grey[300],
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.share_outlined,
                        size: 30,
                        color: Colors.grey[300],
                      ),
                      Text(
                        'Shared',
                        style: TextStyle(
                            color: Colors.grey[300],
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              child: screens[selectedOption],
            ),
            const SizedBox(
              height: 40,
            )
          ]),
        ));
  }
}
