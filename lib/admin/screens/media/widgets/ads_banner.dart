import 'package:flutter/material.dart';
import 'package:roomy/models/ad_model.dart';
import 'package:roomy/widgets/cached_image.dart';

class AdsBanner extends StatelessWidget {
  AdsBanner(this.ad);
  final AdModel ad;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 5,
            child: cachedImage(
              ad.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: const [
              Spacer(),
              Icon(
                Icons.delete,
                color: Colors.red,
                size: 19,
              ),
              SizedBox(width: 5),
              Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
