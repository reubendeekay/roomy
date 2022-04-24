import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:roomy/admin/providers/admin_user_provider.dart';
import 'package:roomy/admin/screens/analytics/analytics_overview.dart';
import 'package:roomy/admin/screens/bookings/manage_bookings_screen.dart';
import 'package:roomy/admin/screens/home/widgets/admin_chat.dart';
import 'package:roomy/admin/screens/manage_property/manage_property_screen.dart';
import 'package:roomy/admin/screens/users/all_users_screen.dart';
import 'package:roomy/main_drawer.dart';
import 'package:roomy/providers/auth_provider.dart';

class AdminHomeTop extends StatelessWidget {
  final bool isDrawer;
  AdminHomeTop(this.isDrawer);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<AuthProvider>(context).user;
    final host = Provider.of<AuthProvider>(context).host;

    return SafeArea(
      child: SizedBox(
        width: size.width,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_outlined),
                    onPressed: () {
                      isDrawer
                          ? Get.off(() => MainDrawer())
                          : Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Host Panel',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(AdminChat.routeName);
                    },
                    child: Icon(
                      FontAwesomeIcons.paperPlane,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            Center(
                child: Column(
              children: [
                Text(
                  'BALANCE',
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'KSH. ${(host.balance * 100).toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24),
                )
              ],
            )),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeTopOption(
                  color: Colors.green,
                  icon: Icons.dashboard_customize,
                  title: 'Manage\nProperty',
                  routeName: ManagePropertyScreen.routeName,
                ),
                HomeTopOption(
                  color: Colors.blue,
                  icon: Icons.event_seat_outlined,
                  title: 'Manage\nBookings',
                  routeName: ManageBookingsScreen.routeName,
                ),
                HomeTopOption(
                  color: Colors.orange,
                  icon: Icons.bar_chart,
                  title: 'Your\nAnalytics',
                  routeName: AnalyticsOverViewScreen.routeName,
                ),
                HomeTopOption(
                  color: user.isAdmin ? Colors.red : Colors.grey,
                  icon: Icons.person_search_rounded,
                  title: 'Super\nAdmin',
                  routeName: user.isAdmin ? AllUsersScreen.routeName : null,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class HomeTopOption extends StatelessWidget {
  final Color color;
  final String title;
  final IconData icon;
  final String routeName;

  const HomeTopOption(
      {Key key, this.color, this.title, this.icon, this.routeName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color,
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            if (title != null)
              const SizedBox(
                height: 5,
              ),
            if (title != null)
              FittedBox(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
