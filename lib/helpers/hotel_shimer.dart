import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:roomy/helpers/my_shimmer.dart';

class HotelShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          MyShimmer(
              child: Container(
            width: size.width * 0.3,
            height: size.width * 0.25,
            color: Colors.grey,
          )),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyShimmer(
                  child: Container(
                height: 25,
                width: size.width * 0.5,
                color: Colors.grey,
              )),
              SizedBox(
                height: 5,
              ),
              MyShimmer(
                  child: Container(
                height: 10,
                width: size.width * 0.3,
                color: Colors.grey,
              )),
              SizedBox(
                height: 5,
              ),
              MyShimmer(
                  child: Container(
                height: 15,
                width: size.width * 0.2,
                color: Colors.grey,
              )),
              SizedBox(
                height: 5,
              ),
              MyShimmer(
                  child: Container(
                height: 20,
                width: size.width * 0.4,
                color: Colors.grey,
              )),
            ],
          )
        ],
      ),
    );
  }
}
