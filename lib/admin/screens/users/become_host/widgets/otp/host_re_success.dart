import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:roomy/admin/screens/admin_home.dart';
import 'package:roomy/admin/screens/users/become_host/widgets/otp/components/default_button.dart';

class HostRegSuccess extends StatelessWidget {
  final bool isDrawer;
  HostRegSuccess({this.isDrawer = false});
  static String routeName = "/login_success";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: size.height * 0.1),
          Image.asset(
            "assets/images/success.png",
            height: size.height * 0.4, //40%
          ),
          SizedBox(height: size.height * 0.08),
          Text(
            "Application Successful",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          SizedBox(
            width: size.width * 0.6,
            child: DefaultButton(
              text: "Go to Panel",
              press: () {
                Navigator.of(context).pop();

                Get.off(() => AdminHomepage(isDrawer: isDrawer));
              },
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
