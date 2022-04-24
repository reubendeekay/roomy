import 'package:flutter/material.dart';
import 'package:roomy/screens/change_password/change_password.dart';
import 'package:roomy/screens/privacy_security/widgets/security_tile.dart';

class PrivacyAndSecurity extends StatelessWidget {
  static const routeName = '/privacy-security';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(children: [
              GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.arrow_back_ios_new)),
              SizedBox(
                width: 20,
              ),
              Text(
                'Privacy and Security',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ]),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15), child: Divider()),
          SizedBox(
            height: 20,
          ),
          SecurityTile(
            title: 'Password',
            colors: Colors.blue,
            icon: Icons.lock_outline_rounded,
            routeName: ChangePassword.routeName,
          ),
          SecurityTile(
              colors: Colors.green,
              title: 'Login Activity',
              icon: Icons.location_on_outlined),
          SecurityTile(
            colors: Colors.teal,
            title: 'Saved Login Info',
            icon: Icons.swap_vertical_circle_outlined,
          ),
          SecurityTile(
            title: 'Two factor Authentication',
            icon: Icons.privacy_tip_outlined,
            colors: Colors.red,
          ),
          SecurityTile(
            title: 'Lock with fingerprint',
            icon: Icons.fingerprint,
            colors: Colors.indigo,
          ),
          SecurityTile(
            title: 'Email Activity',
            icon: Icons.email_outlined,
            colors: Colors.amber,
          ),
          SecurityTile(
            title: 'Access Data',
            icon: Icons.accessibility_new_outlined,
            colors: Colors.purple,
          ),
        ],
      )),
    );
  }
}
