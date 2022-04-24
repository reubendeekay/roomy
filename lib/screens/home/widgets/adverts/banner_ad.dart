import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomy/models/ad_model.dart';
import 'package:roomy/models/filter_model.dart';
import 'package:roomy/providers/property_provider.dart';
import 'package:roomy/screens/hotel_profile/hotel_profile_screen.dart';
import 'package:roomy/screens/search_screen/search_result_screen.dart';
import 'package:roomy/widgets/cached_image.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerAd extends StatelessWidget {
  final AdModel ad;
  BannerAd({@required this.ad});

  Future onTap(BuildContext context) {
    if (ad.category != null) {
      return Navigator.of(context).pushNamed(SearchResultScreen.routeName,
          arguments: FilterModel(searchTerm: ad.category));
    }
    if (ad.ownerId != null && ad.conversion == 'Profile') {
      Provider.of<PropertyProvider>(context, listen: false)
          .getHotelOwner(ad.ownerId);
      Provider.of<PropertyProvider>(context, listen: false)
          .getUserReviews(ad.ownerId);
      return Navigator.of(context)
          .pushNamed(HotelProfileScreen.routeName, arguments: ad.ownerId);
    }
    if (ad.searchTerm != null) {
      return Navigator.of(context).pushNamed(SearchResultScreen.routeName,
          arguments: FilterModel(searchTerm: ad.searchTerm));
    }

    if (ad.clickUrl != null) {
      return launch(ad.clickUrl);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: AspectRatio(
          aspectRatio: 5,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: ClipRRect(
              // borderRadius: BorderRadius.circular(10),
              child: cachedImage(
                ad.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          )),
    );
  }
}
