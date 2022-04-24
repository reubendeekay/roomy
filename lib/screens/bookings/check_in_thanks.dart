import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CheckinThanks extends StatefulWidget {
  static const routeName = '/checkin-thanks';

  @override
  _CheckinThanksState createState() => _CheckinThanksState();
}

class _CheckinThanksState extends State<CheckinThanks> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2500), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Center(
            child: Lottie.asset('assets/check.json'),
          ),
          Text(
            'Thank you for checking in',
          )
        ],
      ),
    );
  }
}
