import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/user_model.dart';
import 'package:roomy/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<AuthProvider>(context).user;
    final size = MediaQuery.of(context).size;
    List<String> options = [
      'Home',
      'Edit Profile',
      'History',
      'Wishlist',
      'Reservations',
    ];

    return Scaffold(
      backgroundColor: kPrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: user.imageUrl != null
                        ? CachedNetworkImageProvider(user.imageUrl)
                        : AssetImage('assets/images/avatar.png'),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      user.fullName,
                      style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  options.length,
                  (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        child: menuOption(
                            context, options[index], currentIndex == index),
                      )),
            ),
            Spacer(),
            GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                },
                child: menuOption(context, 'Log Out', false)),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Widget menuOption(BuildContext context, String title, bool isSelected) {
    return Container(
      child: TextButton(
        onPressed: () {
          // ZoomDrawer.of(context).close();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.amber : Colors.white,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
