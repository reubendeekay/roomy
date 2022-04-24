import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/route_manager.dart';
import 'package:roomy/admin/screens/users/become_host/become_host.dart';
import 'package:roomy/admin/screens/users/become_host/widgets/otp/admin_pin_setup.dart';
import 'package:roomy/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/loading_screen.dart';
import 'package:roomy/models/user_model.dart';
import 'package:roomy/providers/auth_provider.dart';
import 'package:roomy/providers/dark_mode_provider.dart';
import 'package:roomy/screens/bookings/my_bookings.dart';
import 'package:roomy/screens/history/history_screen.dart';
import 'package:roomy/screens/profile/user_profile.dart';
import 'package:roomy/screens/wishlist/wishlist_screen.dart';

class MainDrawer extends StatefulWidget {
  static const String routeName = '/main_drawer';

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final _controller = ZoomDrawerController();

  int currentIndex = 0;

  List<Map<String, dynamic>> options = [
    {'text': 'Home', 'icon': Icons.home},
    {'text': 'Edit Profile', 'icon': Icons.person},
    {'text': 'History', 'icon': Icons.history},
    {'text': 'Wishlist', 'icon': Icons.favorite},
    {'text': 'Reservations', 'icon': Icons.book},
    {'text': 'Travely Hosting', 'icon': Icons.security},
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    List<Widget> screens = [
      MyNav(),
      UserProfile(
        isFromDrawer: true,
      ),
      HistoryScreen(
        isDrawer: true,
      ),
      WishlistScreen(),
      MyBookingsScreen(),
      user != null
          ? (user.isHost
              ? AdminPinSetup(
                  isDrawer: true,
                )
              : BecomeHostScreen(isDrawer: true))
          : null,
    ];
    final isRtl = false;
    return WillPopScope(
      onWillPop: () {
        if (screens[currentIndex] is MyNav) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          });
          return Future.value(true);
        } else {
          Get.off(() => MainDrawer());
          return Future.value(false);
        }
      },
      child: ZoomDrawer(
        controller: _controller,
        menuScreen: buildProfile(context),
        mainScreen: Provider.of<AuthProvider>(context).user == null
            ? LoadingScreen()
            : screens[currentIndex],
        borderRadius: 24.0,
        closeCurve: Curves.easeInToLinear,
        showShadow: true,
        duration: Duration(milliseconds: 200),
        style: DrawerStyle.Style1,
        angle: -10.0,
        backgroundColor: Colors.amber,
        isRtl: isRtl,
        slideWidth: MediaQuery.of(context).size.width * (isRtl ? .45 : 0.65),
      ),
    );
  }

  Widget buildProfile(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;
    return Scaffold(
      backgroundColor: isDark ? Theme.of(context).primaryColor : kPrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.1,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Consumer<AuthProvider>(
                  builder: (ctx, data, _) {
                    data.getCurrentUser(FirebaseAuth.instance.currentUser.uid);

                    UserModel user = data.user;
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: user != null
                              ? CachedNetworkImageProvider(user.imageUrl)
                              : AssetImage('assets/images/avatar.png'),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            user != null ? user.fullName : 'Hello there!',
                            style: GoogleFonts.openSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        )
                      ],
                    );
                  },
                )),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  options.length,
                  (index) => menuOption(context, options[index]['text'],
                      options[index]['icon'], currentIndex == index, index),
                )),
            Spacer(),

            ////////////////////////////////SIGN OUT//////////////////////////////////////
            GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Text(
                    'Sign out',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                )),
            SizedBox(
              height: 30,
            )
            //////////////////////////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }

  Widget menuOption(BuildContext context, String title, IconData icon,
      bool isSelected, int index) {
    return Container(
      child: TextButton(
        onPressed: () {
          setState(() {
            currentIndex = index;
          });
          _controller.close();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.amber : Colors.white,
                size: 18,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.amber : Colors.white,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
