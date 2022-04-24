import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/helpers/hotel_shimer.dart';
import 'package:roomy/providers/property_provider.dart';

import 'package:roomy/screens/hotel_profile/hotel_profile_tile.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = '/wishlist';
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Provider.of<PropertyProvider>(context).fetchWishlist();

    final wishlist = Provider.of<PropertyProvider>(context).yourWishlist;

    return Scaffold(
        appBar: ScrollAppBar(
            controller: _controller,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
                onTap: () => ZoomDrawer.of(context).open(),
                child: Icon(
                  Icons.format_align_left_outlined,
                ))),
        body: Snap(
          controller: _controller.appBar,
          child: ListView(
            controller: _controller,
            children: [
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Wishlist',
                  style: GoogleFonts.openSans(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: kPrimary),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                    'Properties you have added to the wishlist will appear here',
                    style: TextStyle(color: Colors.grey)),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  thickness: 1,
                ),
              ),
              ...List.generate(
                  wishlist.length,
                  (index) => HotelPropertyTile(
                        wishlist[index],
                      )),
              if (wishlist.length == 0)
                FutureBuilder(
                    future: Future.delayed(Duration(milliseconds: 3000)),
                    builder: (ctx, data) => data.connectionState !=
                            ConnectionState.waiting
                        ? Center(
                            child: Container(
                              height: 200,
                              width: 200,
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: Lottie.asset(
                                'assets/data.json',
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
        ));
  }
}
