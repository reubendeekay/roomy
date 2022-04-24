import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotFoundIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.2,
        constraints: BoxConstraints(
          minHeight: 200,
        ),
        child: Lottie.asset(
          'assets/data.json',
        ));
  }
}
