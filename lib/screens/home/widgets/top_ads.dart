import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roomy/models/ad_model.dart';
import 'package:roomy/screens/home/widgets/adverts/banner_ad.dart';

class TopAds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('adverts').snapshots(),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              color: Theme.of(context).shadowColor,
              child: AspectRatio(
                aspectRatio: 5,
              ),
            );
          }
          List<DocumentSnapshot> docs = snapshot.data.docs;
          return CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 5,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 8),
              autoPlayAnimationDuration: Duration(seconds: 2),
              autoPlayCurve: Curves.fastOutSlowIn,
              // enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            items: docs
                .map((e) => BannerAd(
                      ad: AdModel(
                        adType: e['adType'],
                        category: e['category'],
                        description: e['description'],
                        clickUrl: e['clickUrl'],
                        imageUrl: e['imageUrl'],
                        conversion: e['conversion'],
                        country: e['country'],
                        ownerId: e['ownerId'],
                        searchTerm: e['searchTerm'],
                      ),
                    ))
                .toList(),
          );
        });
  }
}
