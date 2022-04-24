import 'package:flutter/material.dart';
import 'package:roomy/onboard/onboardme.dart';
import 'package:roomy/screens/auth/auth_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/welcome-screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: OnboardingMe(
        /// Number of Pages for the screens
        numOfPage: 3,

        /// No of colors you want for your screen
        noOfBackgroundColor: 4,

        /// List of background colors => In descending order
        bgColor: [
          Color(0xFF3594DD),
          Color(0xFF4563DB),
          Color(0xFF5036D5),
          Color(0xFF5B16D0),
        ],

        /// List of  Call-to-action action
        ctaText: ['Skip', 'Get Started'],

        /// List that maps your screen content
        screenContent: [
          {
            "Scr 1 Heading": "Explore and Discover Amazing stays",
            "Scr 1 Sub Heading":
                "Find the perfect activities, services, places and experiences anywhere, anytime",
            "Scr 1 Image Path": "assets/world1.png",
          },
          {
            "Scr 2 Heading": "Your next stay starts here",
            "Scr 2 Sub Heading":
                "Plan your next adventure with infinite possibilities. Skip the lines and have a hassle free experience. Check in easily!.",
            "Scr 2 Image Path": "assets/adventure.png",
          },
          {
            "Scr 3 Heading": "Book your whole trip in one app",
            "Scr 3 Sub Heading":
                "Book and manage your stays with just a few clicks. Enjoy free cancellation and 24/7 customer support",
            "Scr 3 Image Path": "assets/booking.png",
          },
        ],

        /// Bool for Circle Page Indicator
        isPageIndicatorCircle: true,

        /// Home Screen Route that lands after on-boarding
        homeRoute: AuthScreen.routeName,
      ),
    );
  }
}
