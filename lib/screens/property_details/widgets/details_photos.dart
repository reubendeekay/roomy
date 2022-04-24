import 'package:flutter/material.dart';
import 'package:roomy/screens/property_details/widgets/details_fullscreen.dart';
import 'package:roomy/widgets/cached_image.dart';

class DetailsPhotos extends StatelessWidget {
  final List<String> images;
  DetailsPhotos(this.images);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
          ),
          Text(
            'Photos',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List.generate(
                    images.length, (index) => photos(images[index], context))),
          )
        ],
      ),
    );
  }

  Widget photos(String asset, BuildContext context) {
    return Container(
      height: 140,
      width: 120,
      margin: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(DetailsFullScreen.routeName, arguments: asset),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Hero(
            tag: asset,
            transitionOnUserGestures: true,
            child: cachedImage(
              asset,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
