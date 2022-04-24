import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roomy/constants.dart';

class MyMarker extends StatelessWidget {
  // declare a global key and get it trough Constructor

  const MyMarker(this.globalKeyMyWidget, {Key key}) : super(key: key);
  final GlobalKey globalKeyMyWidget;

  @override
  Widget build(BuildContext context) {
    // wrap your widget with RepaintBoundary and
    // pass your global key to RepaintBoundary
    return RepaintBoundary(
      key: globalKeyMyWidget,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 250,
            height: 180,
            decoration: const BoxDecoration(
                color: Colors.black, shape: BoxShape.circle),
          ),
          Container(
              width: 100,
              height: 80,
              decoration:
                  const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.paperPlane,
                    color: Colors.white,
                    size: 35,
                  ),
                  Text(
                    'Travely',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
