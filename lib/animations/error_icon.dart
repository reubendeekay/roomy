import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
            height: size.height * 0.18,
            constraints: BoxConstraints(
              minHeight: 150,
            ),
            child: Transform.scale(
              scale: 2,
              child: Lottie.asset(
                'assets/done1.json',
                fit: BoxFit.fitHeight,
              ),
            )),
        Text(
          'An error occured',
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }
}
