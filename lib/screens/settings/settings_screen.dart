import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:roomy/admin/screens/users/become_host/become_host.dart';
import 'package:roomy/admin/screens/users/become_host/widgets/otp/admin_pin_setup.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/helpers/check_updates.dart';
import 'package:roomy/providers/auth_provider.dart';
import 'package:roomy/providers/dark_mode_provider.dart';
import 'package:roomy/screens/change_password/change_password.dart';
import 'package:roomy/screens/history/history_screen.dart';
import 'package:roomy/screens/notifications/notification_settings.dart';
import 'package:roomy/screens/policies/privacy_policy.dart';
import 'package:roomy/screens/policies/terms_of_use.dart';
import 'package:roomy/screens/privacy_security/privacy_security.dart';
import 'package:roomy/screens/profile/user_profile.dart';
import 'package:roomy/welcome_page/welcome_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<AuthProvider>(context).user;
    return Scaffold(
      appBar: ScrollAppBar(
          controller: _controller,
          // backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () => ZoomDrawer.of(context).open(),
              child: Icon(
                Icons.format_align_left_outlined,
              ))),
      body: Snap(
        controller: _controller.appBar,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            controller: _controller,
            children: [
              // SizedBox(height: 10),
              Container(
                child: Text(
                  'Settings',
                  style: GoogleFonts.openSans(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: kPrimary),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Text('Tweak any of your app related settings from here',
                  style: TextStyle(color: Colors.grey)),
              SizedBox(
                height: size.height * 0.015,
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 10,
              ),
              settingTitle('Account'),
              SizedBox(height: 5),
              GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(UserProfile.routeName),
                  child: setting('My Profile', Icons.person_outline)),
              GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, ChangePassword.routeName),
                  child: setting('Change Password', Icons.lock_open_outlined)),
              GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(HistoryScreen.routeName),
                  child: setting('History', Icons.history)),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 10,
              ),
              settingTitle('General'),
              SizedBox(height: 5),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(NotificationSettings.routeName);
                  },
                  child: setting(
                      'Notifications', Icons.notifications_none_outlined)),
              ChangeTheme(),
              GestureDetector(
                  onTap: () => Navigator.of(context)
                      .pushNamed(PrivacyAndSecurity.routeName),
                  child:
                      setting('Privacy & Security', Icons.vpn_lock_outlined)),
              GestureDetector(
                  onTap: () {
                    Get.to(() =>
                        user.isHost ? AdminPinSetup() : BecomeHostScreen());
                  },
                  child: setting(
                      user.isHost ? 'Travely Host Panel' : 'Become a Host',
                      Icons.travel_explore_rounded)),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 10,
              ),
              settingTitle('More'),
              SizedBox(height: 5),
              GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(PrivacyPolicy.routeName),
                  child: setting('Privacy Policy', Icons.privacy_tip_outlined)),
              GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(TermsofUse.routeName),
                  child: setting('Terms of  Use', Icons.gavel_outlined)),
              setting('FAQ', Icons.quiz_outlined),
              GestureDetector(
                  onTap: () async {
                    await checkForUpdate();
                    await canLaunch(
                            'https://play.google.com/store/apps/details?id=com.kwanzainc.travely')
                        ? await launch(
                            'https://play.google.com/store/apps/details?id=com.kwanzainc.travely')
                        : throw 'Could not launch url';
                  },
                  child: setting('Check for updates', Icons.error_outline)),
              GestureDetector(
                  onTap: () async {
                    Get.off(() => WelcomePage());
                    await FirebaseAuth.instance.signOut();
                  },
                  child: setting('Sign out', Icons.exit_to_app)),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingTitle(String title) {
    return Row(
      children: [
        // Icon(Icons.person_outline, color: Colors.black),
        // SizedBox(width: 15),
        Text(
          title.toUpperCase(),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        )
      ],
    );
  }

  Widget setting(String title, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        horizontalTitleGap: 0,
        leading: Icon(icon,
            color: title == 'Become a Host' || title == 'Travely Host Panel'
                ? kPrimary
                : Colors.grey),
        title: Text(title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            )),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        dense: true,
      ),
    );
  }
}

class ChangeTheme extends StatefulWidget {
  @override
  _ChangeThemeState createState() => _ChangeThemeState();
}

class _ChangeThemeState extends State<ChangeTheme> {
  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<DarkThemeProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        minLeadingWidth: 0,
        leading: Icon(
          dark.darkTheme ? Icons.light_mode_sharp : Icons.dark_mode_outlined,
          color: Colors.grey,
        ),
        title: Text(
          dark.darkTheme ? 'Light mode' : 'Dark mode',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        trailing: Switch(
            activeColor: kPrimary,
            value: dark.darkTheme,
            onChanged: (value) => dark.darkTheme = value),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        dense: true,
      ),
    );
  }
}
