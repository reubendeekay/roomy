import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/force_update.dart';
import 'package:roomy/models/change_log_model.dart';
import 'package:roomy/providers/auth_provider.dart';
import 'package:roomy/screens/explore/explore.dart';
import 'package:roomy/screens/home/homepage.dart';
import 'package:roomy/screens/inbox/inbox_screen.dart';
import 'package:roomy/screens/map_overview/map_overview_screen.dart';
import 'package:roomy/screens/settings/settings_screen.dart';

class MyNav extends StatefulWidget {
  static const routeName = '/my-nav';
  @override
  _MyNavState createState() => _MyNavState();
}

class _MyNavState extends State<MyNav> {
  var _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      Provider.of<AuthProvider>(context, listen: false).getOnlineStatus();
    });
  }

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false)
        .getCurrentUser(FirebaseAuth.instance.currentUser.uid);

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('development')
            .doc('app')
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data['version'] == 0.26
                ? WillPopScope(
                    onWillPop: () async {
                      if (_selectedTab != 0) {
                        setState(() {
                          _selectedTab = 0;
                        });
                      } else {
                        Navigator.of(context).pop();
                      }

                      return false;
                    },
                    child: _screens[_selectedTab],
                  )
                : SafeArea(
                    child: ForceUpdates(
                      changeLog: ChangeLogModel(
                        developerEmail: snapshot.data['email'],
                        changes: snapshot.data['changes'],
                        downloadUrl: snapshot.data['downloadUrl'],
                        imageUrls: snapshot.data['images'],
                        mainDescription: snapshot.data['description'],
                        version: snapshot.data['version'],
                      ),
                    ),
                  );
          } else {
            return WillPopScope(
              onWillPop: () async {
                if (_selectedTab != 0) {
                  setState(() {
                    _selectedTab = 0;
                  });
                } else {
                  Navigator.of(context).pop();
                }

                return false;
              },
              child: _screens[_selectedTab],
            );
          }
        },
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: DotNavigationBar(
          marginR: const EdgeInsets.all(10),
          paddingR: const EdgeInsets.all(3),
          backgroundColor: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.2),
              blurRadius: 1,
            )
          ],
          margin: const EdgeInsets.only(left: 5, right: 5),
          selectedItemColor: kPrimary,

          currentIndex: _selectedTab,
          dotIndicatorColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey[400],
          // enableFloatingNavBar: false,
          onTap: _handleIndexChanged,
          items: [
            /// Home
            DotNavigationBarItem(
              icon: const Icon(
                Icons.home,
                size: 30,
              ),
            ),

            /// Search
            // DotNavigationBarItem(
            //   icon: const Icon(
            //     Icons.search,
            //     size: 30,
            //   ),
            // ),

            /// Map
            DotNavigationBarItem(
              icon: const Icon(
                Icons.location_on,
                size: 30,
              ),
            ),

            /// Chat
            DotNavigationBarItem(
              icon: Icon(
                CupertinoIcons.chat_bubble_fill,
                size: 27,
              ),
            ),

            /// Profile
            DotNavigationBarItem(
              icon: const Icon(
                Icons.settings,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List _screens = [
  Homepage(),
  // ExploreScreen(),
  MapOverviewScreen(),
  InboxScreen(),
  SettingsScreen(),
];
