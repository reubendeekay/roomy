import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:panorama/panorama.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/property_model.dart';

class View360 extends StatelessWidget {
  static const routeName = '/view-360';

  @override
  Widget build(BuildContext context) {
    final PropertyModel property = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: property.panoramicView != null
                ? Panorama(
                    child: Image.asset('assets/images/360.jpeg'),
                    sensitivity: 1.5,
                    hotspots: [
                      Hotspot(
                          width: 100,
                          height: 100,
                          widget: Column(
                            children: [
                              SizedBox(
                                  height: 50,
                                  child: Lottie.asset('assets/blink.json')),
                              Text(
                                'Upper Floor',
                                style: TextStyle(
                                    shadows: [
                                      Shadow(
                                        blurRadius: 5,
                                        color: Colors.grey,
                                      ),
                                    ],
                                    color: kPrimary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          longitude: 113.7410619450045,
                          latitude: 22.330733447913843),
                      Hotspot(
                        width: 100,
                        height: 100,
                        longitude: -57.18980983301003,
                        latitude: -8.609817916566941,
                        widget: Column(
                          children: [
                            SizedBox(
                                height: 50,
                                child: Lottie.asset('assets/blink.json')),
                            Text(
                              'Garden',
                              style: TextStyle(shadows: [
                                Shadow(
                                  blurRadius: 5,
                                  color: Colors.grey,
                                ),
                              ], color: kPrimary, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Hotspot(
                          width: 100,
                          height: 100,
                          widget: Column(
                            children: [
                              SizedBox(
                                  height: 50,
                                  child: Lottie.asset('assets/blink.json')),
                              Text(
                                'Bedroom',
                                style: TextStyle(
                                    shadows: [
                                      Shadow(
                                        blurRadius: 5,
                                        color: Colors.grey,
                                      ),
                                    ],
                                    color: kPrimary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          longitude: 98.87906469679817,
                          latitude: -5.853952287734685),
                      Hotspot(
                        longitude: 82.70298114221919,
                        latitude: -7.58408161178445,
                        width: 100,
                        height: 100,
                        widget: Column(
                          children: [
                            SizedBox(
                                height: 50,
                                child: Lottie.asset('assets/blink.json')),
                            Text(
                              'Kitchen',
                              style: TextStyle(shadows: [
                                Shadow(
                                  blurRadius: 5,
                                  color: Colors.grey,
                                ),
                              ], color: kPrimary, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                    onTap: (longitude, latitude, tilt) {
                      Get.to(() => NextPage());
                    },
                  )
                : Center(
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          child: Transform.scale(
                              scale: 2,
                              child: Lottie.asset('assets/error.json')),
                        ),
                        Text('No 360 View data available')
                      ],
                    ),
                  ),
          ),
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(5)),
                          margin: EdgeInsets.all(12),
                          padding: EdgeInsets.fromLTRB(15, 8, 5, 8),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          )),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              child: Panorama(
            child: Image.asset('assets/images/360.jpg'),
            sensitivity: 1.5,
            hotspots: [
              Hotspot(
                  width: 100,
                  height: 100,
                  widget: Column(
                    children: [
                      SizedBox(
                          height: 50, child: Lottie.asset('assets/blink.json')),
                      Text(
                        'Living Room',
                        style: TextStyle(shadows: [
                          Shadow(
                            blurRadius: 5,
                            color: Colors.grey,
                          ),
                        ], color: kPrimary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  longitude: 65.46167854867674,
                  latitude: -11.577421651983773),
            ],
            onTap: (longitude, latitude, tilt) {
              Navigator.of(context).pop();
            },
          )),
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(5)),
                          margin: EdgeInsets.all(12),
                          padding: EdgeInsets.fromLTRB(15, 8, 5, 8),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          )),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
