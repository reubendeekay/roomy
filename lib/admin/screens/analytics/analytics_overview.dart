import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:roomy/admin/screens/analytics/chart_data.dart';
import 'package:roomy/admin/screens/analytics/withdraw_screen.dart';
import 'package:roomy/admin/screens/home/widgets/property_category.dart';
import 'package:roomy/providers/auth_provider.dart';
import 'package:roomy/screens/bookings/my_booking_details.dart';
import 'package:roomy/screens/home/widgets/home_title.dart';

class AnalyticsOverViewScreen extends StatefulWidget {
  const AnalyticsOverViewScreen({Key key}) : super(key: key);
  static const routeName = '/your-analytics';

  @override
  State<AnalyticsOverViewScreen> createState() =>
      _AnalyticsOverViewScreenState();
}

class _AnalyticsOverViewScreenState extends State<AnalyticsOverViewScreen> {
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final host = Provider.of<AuthProvider>(context).host;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                SizedBox(
                    height: 30, child: Image.asset('assets/images/coin.png')),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Balance',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'KES ${(host.balance * 100).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (ctx) {
                            return WithdrawWidget();
                          });
                    },
                    child: Icon(FontAwesome.money, color: Colors.green)),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              'Revenue Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            width: size.width,
            height: 200,
            child: LineChart(
              mainData(isLoaded: isLoaded),
              swapAnimationCurve: Curves.linear,
              swapAnimationDuration: const Duration(milliseconds: 4000),
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Text(
              'Travely Performance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: buildDetails(
                  icon: Icons.attach_money_sharp,
                  title: 'Total Earnings',
                  value: 'KES ${(host.totalEarnings * 100).toStringAsFixed(2)}',
                ),
              ),
              Expanded(
                child: buildDetails(
                  icon: Icons.sell,
                  title: 'Total Bookings',
                  value: host.totalBookings.toString(),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: buildDetails(
                  icon: Icons.favorite,
                  title: 'Total Likes',
                  value: host.likes.toString(),
                ),
              ),
              Expanded(
                child: buildDetails(
                  icon: Icons.remove_red_eye,
                  title: 'Total Views',
                  value: host.views.toString(),
                ),
              ),
            ],
          ),
          HomeTitle('Most Booked', Icons.sell),
          Container(
            margin: const EdgeInsets.only(left: 15),
            height: 200,
            child: AdminFeaturedProperty(
              criteria: 'bookings',
            ),
          ),
          HomeTitle('Peoples Favourite', Icons.favorite),
          Container(
            margin: const EdgeInsets.only(left: 15),
            height: 200,
            child: AdminFeaturedProperty(
              criteria: 'likes',
            ),
          ),
          HomeTitle('Most Impression', Icons.show_chart),
          Container(
            margin: const EdgeInsets.only(left: 15),
            height: 200,
            child: AdminFeaturedProperty(),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
