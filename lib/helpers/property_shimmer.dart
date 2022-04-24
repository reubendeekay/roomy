import 'package:flutter/material.dart';
import 'package:roomy/helpers/my_shimmer.dart';

class PropertyShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: EdgeInsets.only(bottom: 5),
          child: AspectRatio(
            aspectRatio: 2.4,
            child: MyShimmer(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        MyShimmer(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
            height: 20,
            color: Colors.grey,
            width: size.width * 0.5,
          ),
        ),
        MyShimmer(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
            height: 15,
            color: Colors.grey,
            width: size.width * 0.7,
          ),
        ),
        MyShimmer(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 5, 180, 5),
            height: 12,
            color: Colors.grey,
            width: size.width * 3,
          ),
        )
      ]),
    );
  }
}
