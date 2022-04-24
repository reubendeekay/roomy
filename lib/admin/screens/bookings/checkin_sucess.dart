import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:roomy/admin/screens/analytics/analytics_overview.dart';

class CheckinSuccessScreen extends StatefulWidget {
  const CheckinSuccessScreen({Key key}) : super(key: key);

  @override
  State<CheckinSuccessScreen> createState() => _CheckinSuccessScreenState();
}

class _CheckinSuccessScreenState extends State<CheckinSuccessScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2500))
        .then((value) => Get.off(() => AnalyticsOverViewScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset('assets/check.json'),
        ],
      ),
    );
  }
}
