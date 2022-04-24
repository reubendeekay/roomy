import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/screens/chat/chat_screen.dart';
import 'package:roomy/screens/notifications/notifications_screen.dart';

class InboxScreen extends StatefulWidget {
  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  int currentIndex = 0;

  List<Widget> screens = [
    ChatScreen(),
    NotificationsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Inbox',
              style: GoogleFonts.openSans(
                  fontSize: 30, fontWeight: FontWeight.w900, color: kPrimary),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 0;
                    });
                  },
                  child: Text('Messages',
                      style: GoogleFonts.openSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: currentIndex == 0 ? kPrimary : Colors.grey)),
                ),
                SizedBox(
                  width: 25,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                  child: Text('Notifications',
                      style: GoogleFonts.openSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: currentIndex == 1 ? kPrimary : Colors.grey)),
                ),
              ],
            ),
          ),
          Container(
              height: 5,
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Stack(
                children: [
                  Container(height: 2, color: Theme.of(context).shadowColor),
                  AnimatedPositioned(
                      left: currentIndex == 0 ? 0 : 85,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                          width: currentIndex == 0 ? 65 : 85,
                          height: 2,
                          color: kPrimary)),
                ],
              )),
          Expanded(child: screens[currentIndex]),
        ],
      ),
    );
  }
}
