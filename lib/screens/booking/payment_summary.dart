import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/providers/auth_provider.dart';
import 'package:roomy/providers/booking_provider.dart';

class PaymentSummaryScreen extends StatelessWidget {
  static const routeName = '/payment-summary-screen';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final booking = Provider.of<BookingProvider>(context).booking;
    final property = ModalRoute.of(context).settings.arguments as PropertyModel;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            height: size.height,
            child: ListView(
              children: [
                Container(
                  // margin: EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  height: 65,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                      ),
                      Text(
                        'PAYMENT RECEIPT',
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              userDetail('User', user.fullName),
                              userDetail('Email', user.email),
                            ]),
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Text(
                            'Date: ${DateFormat('dd MMMM').format(booking.checkIn)}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 30,
                            color: kPrimary,
                            child: Center(
                              child: Text('SUCCESSFUL',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 50),
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      height: 30,
                      color: kPrimary,
                      alignment: Alignment.centerLeft,
                      child: Text('SERVICE PROVIDER',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(children: [
                    userDetail('Name', property.name),
                    userDetail('Location', property.location.town),
                    userDetail('Check in',
                        DateFormat('dd MMMM').format(booking.checkIn)),
                    userDetail('Check out',
                        DateFormat('dd MMMM').format(booking.checkOut)),
                  ]),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.fromLTRB(15, 15, 50, 10),
                  alignment: Alignment.centerLeft,
                  height: 30,
                  color: kPrimary,
                  child: Text('BOOKING DETAILS',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.fromLTRB(10, 0, 45, 10),
                    alignment: Alignment.centerLeft,
                    height: 30,
                    color: kPrimary.withOpacity(0.4),
                    child: Row(
                      children: [
                        Text('Description',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            )),
                        Spacer(),
                        Text('Amount',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    )),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(15, 15, 50, 10),
                  child: Column(children: [
                    paymentDetail(
                        property.name, property.price, booking.numOfDays),
                    ...booking.services
                        .map((e) => paymentDetail(e.name,
                            e.price.toStringAsFixed(2), booking.numOfDays))
                        .toList(),
                    ...booking.activities
                        .map((e) =>
                            paymentDetail(e.name, e.price, booking.numOfDays))
                        .toList()
                  ]),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(15, 0, 50, 0),
                  child: Divider(),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(15, 10, 50, 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                      ),
                      Text('Total',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )),
                      Spacer(),
                      Text('KES ${booking.price}',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 15,
              child: Container(
                width: size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 45,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: kPrimary,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text('CLOSE',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Icon(
                          Icons.print,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Print',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                      ]),
                    ),
                  ],
                ),
              ))
        ],
      )),
    );
  }

  Widget userDetail(String title, String value) {
    return Row(children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: 60,
        child: Text(
          '$title:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Text(
        value,
        style: TextStyle(color: Colors.grey),
      )
    ]);
  }

  Widget paymentDetail(String title, String amount, int days) {
    return Row(children: [
      Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'KES $amount x $days ${days > 1 ? 'days' : 'day'}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          )),
      Spacer(),
      Text(
        '\$ ${double.parse(amount) * days}',
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
      )
    ]);
  }
}
