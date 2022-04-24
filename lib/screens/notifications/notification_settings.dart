import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roomy/constants.dart';

class NotificationSettings extends StatelessWidget {
  static const routeName = '/notification-settings';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(Icons.arrow_back_ios_new))),
              ],
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Notification Settings',
                style: GoogleFonts.openSans(
                    fontSize: 24, fontWeight: FontWeight.bold, color: kPrimary),
              ),
            ),
            SizedBox(height: 30),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Toggle how and what you receive alerts on. Note that for some important notifications, some of the options toggled will be overriden',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                )),
            SizedBox(height: 5),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 15), child: Divider()),
            NotificationSwitcher(
              title: 'Subcribe to mailing list',
              description:
                  'Get notified via email on important news, progress or changes to the app',
            ),
            NotificationSwitcher(
              title: 'New offers',
              description:
                  'Receive custom tailored notifications about new and or trending offers ',
            ),
            NotificationSwitcher(
              title: 'Chat notifications',
              description: 'Receive push notifications for new messages',
            ),
            NotificationSwitcher(
              title: 'Notification sounds',
              description: 'Play sounds for new messages',
            ),
            NotificationSwitcher(
              title: 'Tips & Tricks',
              description:
                  'Show in app notifications about features. Critical system notifications will stil be shown even if toggled off',
            ),
            NotificationSwitcher(
              title: 'Account Updates',
              description:
                  'Receive the change log of new updates and be a beta tester for the app.',
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationSwitcher extends StatefulWidget {
  final String title;
  final String description;

  const NotificationSwitcher({Key key, this.title, this.description})
      : super(key: key);
  @override
  _NotificationSwitcherState createState() => _NotificationSwitcherState();
}

class _NotificationSwitcherState extends State<NotificationSwitcher> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: Text(widget.title),
            subtitle: Text(
              widget.description,
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Switch(
                value: _value,
                activeColor: kPrimary,
                onChanged: (bool value) {
                  setState(() {
                    _value = value;
                  });
                }),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15), child: Divider()),
        ],
      ),
    );
  }
}
