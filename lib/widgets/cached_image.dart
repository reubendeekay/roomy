import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roomy/helpers/my_shimmer.dart';

Widget cachedImage(
  String url, {
  double width,
  double height,
  BoxFit fit,
}) {
  return CachedNetworkImage(
    imageUrl: url,
    height: height,
    width: width,
    fit: fit,
    progressIndicatorBuilder: (context, url, downloadProgress) => MyShimmer(
      child: Container(
        height: height,
        width: width,
        color: Colors.grey.withOpacity(0.2),
        child: Image.asset('assets/images/logo.png'),
      ),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}
