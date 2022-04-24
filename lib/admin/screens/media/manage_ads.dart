import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roomy/admin/helpers/ads_banner_shimmer.dart';
import 'package:roomy/admin/screens/media/add_ad.dart';
import 'package:roomy/admin/screens/media/widgets/ads_banner.dart';
import 'package:roomy/admin/widgets/secondary_title.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/ad_model.dart';

class ManageAds extends StatelessWidget {
  static const routeName = '/manage-ads';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Manage Ads',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(AddAdScreen.routeName);
            },
            child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(width: 1, color: Colors.blueGrey)),
                margin: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: const Center(
                  child: Text(
                    'Publish an advert',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                )),
          ),
          SecondaryTitle('Active Ads'),
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('adverts').snapshots(),
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) {
                  return ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    children: List.generate(10, (index) => AdsBannerShimmer()),
                  );
                }

                List<DocumentSnapshot> docs = snapshot.data.docs;
                return ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  children: docs
                      .map((e) => AdsBanner(AdModel(
                            imageUrl: e['imageUrl'],
                            id: e.id,
                          )))
                      .toList(),
                );
              })
        ],
      ),
    );
  }
}
