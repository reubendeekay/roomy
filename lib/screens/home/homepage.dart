import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:roomy/providers/booking_provider.dart';
import 'package:roomy/providers/chat_provider.dart';
import 'package:roomy/providers/location_provider.dart';
import 'package:roomy/providers/property_provider.dart';
import 'package:roomy/screens/bookings/booking_map_trail.dart';
import 'package:roomy/screens/bookings/my_bookings.dart';

import 'package:roomy/screens/home/widgets/avatar.dart';
import 'package:roomy/screens/home/widgets/home_title.dart';
import 'package:roomy/screens/home/widgets/top_ads.dart';

import 'package:roomy/screens/home/widgets/top_search.dart';
import 'package:roomy/widgets/property/properties.dart';

class Homepage extends StatelessWidget {
  final homeScroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    Provider.of<ChatProvider>(context, listen: false).getChats();
    Provider.of<PropertyProvider>(context, listen: false).fetchProperties();
    Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();
    final trail =
        Provider.of<BookingProvider>(context, listen: false).trailProperty;

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey[400], width: 0.3))),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Row(children: [
                      UserAvatar(),
                      Expanded(
                        child: GestureDetector(
                            onTap: () async {
                              // await FirebaseFirestore.instance
                              //     .collection('propertyData')
                              //     .doc('propertyListing')
                              //     .collection('properties')
                              //     .get()
                              //     .then((value) async {
                              //   await Future.forEach(
                              //       value.docs,
                              //       (element) async => await FirebaseFirestore
                              //               .instance
                              //               .collection('propertyData')
                              //               .doc('propertyListing')
                              //               .collection('properties')
                              //               .doc(element.id)
                              //               .update({
                              //             'bookings': 0,
                              //           }));
                              // });

                              homeScroll.animateTo(0,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            },
                            child: Container(
                              height: 35,
                              color: Colors.transparent,
                            )),
                      ),
                      if (trail != null)
                        GestureDetector(
                            onTap: () {
                              Get.to(() => BookingMapTrail(trail));
                            },
                            child: SizedBox(
                              height: 30,
                              child: Lottie.asset('assets/blink.json'),
                            )),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(
                            MyBookingsScreen.routeName,
                            arguments: true),
                        child: Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.calendarCheck,
                              size: 18,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Bookings'),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ]),
                  ),
                  //Search Bar
                  TopSearch(),
                ],
              ),
            ),
            Expanded(
              child: ListView(controller: homeScroll, children: [
                HomeOptions(),
                //RECOMMENDED PROPERTIES
                HomeTitle('Featured', FontAwesomeIcons.star),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  height: size.height * 0.245,
                  constraints: BoxConstraints(minHeight: 200),
                  child: FeaturedProperty(),
                ),
                SizedBox(
                  height: 10,
                ),
                TopAds(),
                SizedBox(
                  height: 5,
                ),
                //TOP RATED PROPERTIES
                HomeTitle('Recommended for you', FontAwesomeIcons.gitter),
                Column(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    AllProperty()
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
