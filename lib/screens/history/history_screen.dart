import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/helpers/hotel_shimer.dart';
import 'package:roomy/providers/property_provider.dart';
import 'package:roomy/screens/hotel_profile/hotel_profile_tile.dart';

class HistoryScreen extends StatelessWidget {
  static const String routeName = '/history';
  final bool isDrawer;
  HistoryScreen({this.isDrawer = false});
  @override
  Widget build(BuildContext context) {
    final history =
        Provider.of<PropertyProvider>(context, listen: false).yourHistory;
    Provider.of<PropertyProvider>(context, listen: false).fetchHistory();
    return Scaffold(
      appBar: isDrawer
          ? AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: GestureDetector(
                  onTap: () => ZoomDrawer.of(context).open(),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                  )))
          : null,
      body: WillPopScope(
        onWillPop: () async {
          if (!isDrawer) {
            return Future.value(false);
          }
          ZoomDrawer.of(context).open();
          return Future.value(true);
        },
        child: SafeArea(
          child: ListView(
            children: [
              if (!isDrawer) SizedBox(height: 20),
              if (!isDrawer)
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
                  'Your History',
                  style: GoogleFonts.openSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kPrimary),
                ),
              ),
              SizedBox(height: 10),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'See the latest properties you viewed in case you want to return',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  )),
              SizedBox(height: 5),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(),
              ),
              ...List.generate(
                  history.length,
                  (index) => HotelPropertyTile(
                        history[index],
                      )),
              if (history.length < 1)
                FutureBuilder(
                    future: Future.delayed(Duration(milliseconds: 2000)),
                    builder: (ctx, data) => data.connectionState !=
                            ConnectionState.waiting
                        ? Center(
                            child: Container(
                              height: 200,
                              width: 200,
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: Lottie.asset(
                                'assets/data1.json',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          )
                        : ListView(
                            shrinkWrap: true,
                            children:
                                List.generate(10, (index) => HotelShimmer()),
                          ))
            ],
          ),
        ),
      ),
    );
  }
}
