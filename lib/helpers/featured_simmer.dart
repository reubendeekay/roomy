import 'package:flutter/material.dart';
import 'package:roomy/helpers/my_shimmer.dart';

class FeaturedShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: 8,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Container(
              width: size.width * 0.4,
              height: size.height * 0.29,
              margin: EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyShimmer(
                    child: Container(
                      height: size.height * 0.16,
                      width: size.width * 0.4,
                      color: Colors.grey,
                    ),
                  ),
                  MyShimmer(
                      child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    color: Colors.grey,
                    height: 15,
                    width: size.width * 0.3,
                  )),
                  MyShimmer(
                      child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    color: Colors.grey,
                    height: 8,
                    width: size.width * 0.18,
                  )),
                  MyShimmer(
                      child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    color: Colors.grey,
                    height: 10,
                    width: size.width * 0.23,
                  )),
                ],
              ));
        });
  }
}
