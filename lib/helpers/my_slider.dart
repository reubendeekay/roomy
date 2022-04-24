import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class MySlid extends StatefulWidget {

  @override
  State<MySlid> createState() => _MySlidState();
}

class _MySlidState extends State<MySlid> {
  String feel = "0";

  double _value = 0.0;

  double lastsection = 0.0;

  String feedbacktxt = "Very Poor";

  Color backgroundclr = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 250,
        child: Align(
          alignment: Alignment.topCenter,
          child: FlareActor(
            'assets/feelings.flr',
            fit: BoxFit.contain,

            //alignment: Alignment.Center,
            animation: feel,
          ),
        ),
      ),
      Slider(
        min: 0.0,
        max: 100.0,
        value: _value,
        divisions: 100,
        activeColor: Colors.blue,
        inactiveColor: Colors.black.withOpacity(0.6),
        label: feedbacktxt,
        onChanged: (val) {
          setState(() {
            _value = val;
          });
          if (_value == 0.0) {
            if (lastsection > 0.0) {
              setState(() {
                feel = "0-";
              });
            }
            setState(() {
              lastsection = 0.0;
              backgroundclr = Colors.red;
              feedbacktxt = "Very Good";
            });
          } else if (_value > 0.0 && _value < 25.0) {
            if (lastsection == 0.0) {
              setState(() {
                feel = "0+";
              });
            } else if (lastsection == 50.0) {
              setState(() {
                feel = "25-";
              });
            }
            setState(() {
              lastsection = 25.0;
              backgroundclr = Colors.orange;
              feedbacktxt = "Good";
            });
          } else if (_value >= 25.0 && _value < 50.0) {
            if (lastsection == 25.0) {
              setState(() {
                feel = "25+";
              });
            } else if (lastsection == 75.0) {
              setState(() {
                feel = "50-";
              });
            }
            setState(() {
              lastsection = 50.0;
              backgroundclr = Colors.orangeAccent;
              feedbacktxt = "Cool";
            });
          } else if (_value >= 50.0 && _value < 75.0) {
            if (lastsection == 50.0) {
              setState(() {
                feel = "50+";
              });
            } else if (lastsection == 100.0) {
              setState(() {
                feel = "75-";
              });
            }
            setState(() {
              lastsection = 75.0;
              backgroundclr = Colors.yellow;
              feedbacktxt = "Wow";
            });
          } else if (_value >= 75.0 && _value <= 100.0) {
            if (lastsection == 75.0) {
              setState(() {
                feel = "75+";
              });
            }
            setState(() {
              lastsection = 100.0;
              backgroundclr = Colors.green;
              feedbacktxt = "MasterPiece";
            });
          }
        },
      )
    ]);
  }
}
