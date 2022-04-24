import 'package:flutter/material.dart';
import 'package:roomy/constants.dart';

class FilterOnBackground extends StatelessWidget {
  const FilterOnBackground({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            //Colors.black54,
            //Colors.black.withOpacity(0.8),
            kPrimary.withOpacity(0.6),
            kPrimary.withOpacity(0.9),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: const [0, 1],
        ),
      ),
    );
  }
}
