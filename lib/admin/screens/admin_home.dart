import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/route_manager.dart';

import 'package:roomy/admin/screens/home/widgets/admin_home_top.dart';
import 'package:roomy/admin/screens/news/news_overview_screen.dart';
import 'package:roomy/main_drawer.dart';

class AdminHomepage extends StatelessWidget {
  final bool isDrawer;
  AdminHomepage({Key key, this.isDrawer = false}) : super(key: key);
  static const routeName = '/admin-home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          if (!isDrawer) {
            Navigator.of(context).pop();
          }
          Get.off(() => MainDrawer());
          return Future.value(false);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AdminHomeTop(isDrawer),
            const SizedBox(
              height: 10,
            ),

            NewsOverviewScreen(),
            // Expanded(
            //   child: ListView(
            //     padding: const EdgeInsets.all(0),
            //     children: [
            //       GestureDetector(
            //           child: HomeTitle('Top Grossing', Icons.show_chart)),
            //       Container(
            //         margin: const EdgeInsets.only(left: 15),
            //         height: 200,
            //         child: AdminFeaturedProperty(),
            //       ),
            //       HomeTitle('Most Viewed', Icons.bar_chart_outlined),
            //       Container(
            //         margin: const EdgeInsets.only(left: 15),
            //         height: 200,
            //         child: AdminFeaturedProperty(),
            //       ),
            //       HomeTitle('Peoples Favorite', Icons.thumb_up_alt_outlined),
            //       Container(
            //         margin: const EdgeInsets.only(left: 15),
            //         height: 200,
            //         child: AdminFeaturedProperty(),
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
