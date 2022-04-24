import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:roomy/admin/constants.dart';
import 'package:roomy/admin/helpers/chat_tile_shimmer.dart';
import 'package:roomy/admin/providers/admin_booking_provider.dart';
import 'package:roomy/admin/screens/bookings/qr_result_screen.dart';
import 'package:roomy/admin/screens/bookings/widgets/booking_tile.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/providers/booking_provider.dart';
import 'package:roomy/providers/property_provider.dart';

class ManageBookingsScreen extends StatefulWidget {
  static const routeName = '/manage-bookings';
  final PropertyModel property;
  ManageBookingsScreen({this.property});

  @override
  State<ManageBookingsScreen> createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> {
  int currentIndex = 0;

  List<String> tabOptions = [
    'Pending',
    'Completed',
    'Cancelled',
  ];

  double leftPosition = 0;
  @override
  Widget build(BuildContext context) {
    final bookings = Provider.of<AdminBookingProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
            widget.property != null
                ? widget.property.name + ' Bookings'
                : 'Manage Bookings',
            style: TextStyle(color: Colors.white)),
        elevation: 0.0,
        actions: [
          GestureDetector(
              onTap: () async {
                String code = await FlutterBarcodeScanner.scanBarcode(
                    null, 'Cancel', true, ScanMode.QR);

                await bookings.confirmBooking(
                    code.split('_')[1], code.split('_')[0], code.split('_')[2]);

                Get.to(() => QRResultScreen(bookings.booking));
              },
              child: Row(
                children: [
                  Text(
                    'Check in',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.qr_code, color: Colors.white),
                  SizedBox(width: 10),
                ],
              )),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                  children: List.generate(
                tabOptions.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = index;
                      if (currentIndex == 0) {
                        leftPosition = 0;
                      } else if (currentIndex == 1) {
                        leftPosition = 80;
                      } else if (currentIndex == 2) {
                        leftPosition = 165;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Text(tabOptions[index],
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: currentIndex == index
                                  ? kPrimary
                                  : Colors.grey)),
                      const SizedBox(
                        width: 25,
                      ),
                    ],
                  ),
                ),
              ))),
          Container(
              height: 5,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Stack(
                children: [
                  Container(height: 2, color: Colors.grey[300]),
                  AnimatedPositioned(
                      left: leftPosition,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                          width: currentIndex == 0 ? 55 : 63,
                          height: 2,
                          color: kPrimary)),
                ],
              )),
          FutureBuilder(
              future: Provider.of<AdminBookingProvider>(context, listen: false)
                  .getBooking(
                      propertyId:
                          widget.property != null ? widget.property.id : null),
              builder: (ctx, data) {
                if (data.connectionState == ConnectionState.waiting) {
                  return Expanded(
                      child: ListView(
                    children: List.generate(10, (index) => ChatTileShimmer()),
                  ));
                }

                return Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(0),
                    children: List.generate(
                        bookings.bookings.length,
                        (index) => BookingTile(
                              booking: bookings.bookings[index],
                            )),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
