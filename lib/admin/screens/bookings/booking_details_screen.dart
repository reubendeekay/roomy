import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:roomy/admin/constants.dart';
import 'package:roomy/models/booking_model.dart';
import 'package:roomy/providers/booking_provider.dart';
import 'package:roomy/widgets/done_icon.dart';

class BookingDetailsScreen extends StatelessWidget {
  final BookingTileModel booking;
  BookingDetailsScreen(this.booking);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              topProfile(),
              biggerHeading('Client Details'),
              textField(title: 'Name', value: booking.user.fullName),
              textField(title: 'Email', value: booking.user.email),
              textField(title: 'Phone', value: booking.user.phoneNumber),
              const SizedBox(
                height: 10,
              ),
              biggerHeading('Booking Details'),
              textField(title: 'Travely', value: booking.property.name),
              textField(
                  title: 'Check in',
                  value:
                      DateFormat('dd/MM/yyyy').format(booking.booking.checkIn)),
              textField(
                  title: 'Check out',
                  value: DateFormat('dd/MM/yyyy')
                      .format(booking.booking.checkOut)),
              textField(
                  title: 'No of Guests',
                  value: '${booking.booking.numOfGuests ?? 0}'),
              textField(
                  title: 'No of Rooms',
                  value: '${booking.booking.numOfRooms ?? 0}'),
              textField(title: 'Price', value: 'KES ${booking.booking.price}'),
              textField(title: 'Payment Method', value: 'M-Pesa'),
              textField(title: 'Booking Status', value: 'Pending'),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 45,
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: RaisedButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text(
                              'CANCEL WARNING',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: Text(
                                'Do you wish to cancel this booking? Refund will be deducted from your account.'),
                            actions: [
                              TextButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Yes'),
                                onPressed: () async {
                                  await Provider.of<BookingProvider>(context,
                                          listen: false)
                                      .cancelBooking(
                                          bookingId: booking.booking.bookingId,
                                          ownerId: booking.property.ownerId,
                                          bookerId: booking.user.userId);
                                  booking.booking.status = 'cancelled';

                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        content: DoneIcon(),
                                      );
                                    },
                                  );
                                  Future.delayed(Duration(milliseconds: 2500),
                                      () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  });
                                },
                              )
                            ],
                          ));
                },
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: const Text(
                  'Cancel Booking',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textField({String title, String value}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          Text(value,
              style: const TextStyle(
                color: Colors.grey,
              )),
          Divider(
            thickness: 1.5,
            color: Colors.grey[400],
          )
        ],
      ),
    );
  }

  Widget biggerHeading(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
      ),
    );
  }

  Widget topProfile() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: CachedNetworkImageProvider(booking.user.imageUrl),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.user.fullName,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                booking.user.email,
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ],
          )
        ],
      ),
    );
  }
}
