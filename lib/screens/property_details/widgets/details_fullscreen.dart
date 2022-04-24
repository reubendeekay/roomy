import 'package:flutter/material.dart';
import 'package:roomy/widgets/cached_image.dart';

class DetailsFullScreen extends StatelessWidget {
  static const routeName = '/details-fullscreen';

  @override
  Widget build(BuildContext context) {
    final image = ModalRoute.of(context).settings.arguments;
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Hero(
        tag: image,
        transitionOnUserGestures: true,
        child: cachedImage(
          image,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
