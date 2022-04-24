import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/providers/booking_provider.dart';
import 'package:roomy/screens/booking/add_activity_screen.dart';
import 'package:roomy/screens/booking/categories/events_booking.dart';
import 'package:roomy/screens/booking/categories/hotel_booking.dart';
import 'package:roomy/screens/booking/categories/restaurant_booking.dart';
import 'package:roomy/screens/booking/payment_screen.dart';

class BookingScreen extends StatefulWidget {
  static const routeName = '/booking-screen';

  final PropertyModel property;
  BookingScreen({this.property});
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  Widget bookingCategory() {
    if (widget.property.propertyCategory.toLowerCase() == 'residence' ||
        widget.property.propertyCategory.toLowerCase() == 'hotel') {
      return HotelBooking(
        property: widget.property,
      );
    } else if (widget.property.propertyCategory.toLowerCase() == 'event' ||
        widget.property.propertyCategory.toLowerCase() == 'activity') {
      return EventBooking(
        property: widget.property,
      );
    } else if (widget.property.propertyCategory.toLowerCase() == 'restaurant') {
      return RestaurantBooking(
        property: widget.property,
      );
    }

    return HotelBooking(
      property: widget.property,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final booking = Provider.of<BookingProvider>(context).booking;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 50,
          backgroundColor: kPrimary,
          centerTitle: true,
          title: const Text(
            'BOOKING INFORMATION',
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w900),
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Container(
            child: Stack(
              children: [
                Container(
                  height: size.height - 50,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        bookingCategory(),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'CONTACT INFORMATION',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w900),
                        ),
                        inputCard('Contact name'),
                        inputCard('Email address'),
                        inputCard('National ID/Passport'),
                        const SizedBox(
                          height: 70,
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 20,
                  left: 20,
                  child: SizedBox(
                    height: 45,
                    width: size.width,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        color: kPrimary,
                        onPressed: booking.numOfDays > 0
                            ? () => Navigator.of(context).pushNamed(
                                AddActivityScreen.routeName,
                                arguments: widget.property)
                            : null,
                        child: const Text(
                          'Continue',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        )),
                  ),
                )
              ],
            ),
          ),
        )));
  }

  Widget inputCard(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).shadowColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
          maxLines: null,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            labelText: title,
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1,
                )),
          )),
    );
  }
}
