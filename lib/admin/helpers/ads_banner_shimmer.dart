import 'package:flutter/material.dart';
import 'package:roomy/helpers/my_shimmer.dart';

class AdsBannerShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyShimmer(
      child: Container(
        color: Colors.grey,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: const AspectRatio(aspectRatio: 5),
      ),
    );
  }
}
