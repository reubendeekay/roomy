import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:roomy/admin/screens/auth/widgets/loading_screen.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/booking_model.dart';
import 'package:roomy/models/user_model.dart';
import 'package:roomy/providers/booking_provider.dart';
import 'package:roomy/providers/chat_provider.dart';
import 'package:roomy/screens/booking/booking_screen.dart';
import 'package:roomy/screens/bookings/booking_map_trail.dart';
import 'package:roomy/screens/bookings/booking_qr/qr_screen.dart';
import 'package:roomy/screens/chat/chat_room.dart';

class MyBookingDetails extends StatefulWidget {
  static const String routeName = '/my-booking-details';

  @override
  _MyBookingDetailsState createState() => _MyBookingDetailsState();
}

class _MyBookingDetailsState extends State<MyBookingDetails> {
  String status(BookingModel booking) {
    if (booking == 'checkedin' && booking == 'checkout') {
      return 'Checked out';
    } else if (booking == 'checkedin') {
      return 'Checked in';
    } else if (booking == 'cancelled') {
      return 'Booking cancelled';
    } else if (DateTime.now().isAfter(booking.checkOut)) {
      return 'Booking Expired';
    }

    return 'Pending Check in';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bookedProperty = Provider.of<BookingProvider>(context).bookedProperty;
    final booking = ModalRoute.of(context).settings.arguments as BookingModel;

    return Scaffold(
      body: bookedProperty == null
          ? LoadingScreen()
          : Stack(
              children: [
                Container(
                  height: size.height,
                  width: size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: size.height * 0.22,
                          width: size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                bookedProperty.coverImage,
                              ),
                            ),
                          ),
                          child: Stack(
                            children: [
                              if (booking.status == 'checkedin' ||
                                  booking.status == 'cancelled')
                                Container(
                                  height: size.height * 0.22,
                                  width: size.width,
                                  color: booking.status == 'checkedin'
                                      ? Colors.green.withOpacity(0.5)
                                      : Colors.red.withOpacity(0.5),
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 8),
                                    child: Text(status(booking),
                                        style: GoogleFonts.montserrat(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ),
                                ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).padding.top),
                                  Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.arrow_back_ios,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        Text(
                                          bookedProperty.name,
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 10,
                                                  color: Colors.grey,
                                                ),
                                              ],
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ])
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              actionIcon(
                                  onTap: () {
                                    Provider.of<BookingProvider>(context,
                                            listen: false)
                                        .intialize(
                                            double.parse(bookedProperty.price));
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.bottomToTop,
                                        duration: Duration(milliseconds: 200),
                                        child: BookingScreen(
                                          property: bookedProperty,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icons.replay_rounded,
                                  title: 'Book\n again',
                                  color: Colors.amber),
                              actionIcon(
                                onTap: () {
                                  // booking.status == 'checkedin'
                                  //     ? Provider.of<BookingProvider>(context,
                                  //             listen: false)
                                  //         .checkOut(
                                  //         booking.bookingId,
                                  //       )
                                  //     : Provider.of<BookingProvider>(context,
                                  //             listen: false)
                                  //         .checkIn(
                                  //         booking.bookingId,
                                  //       );

                                  // Navigator.of(context)
                                  //     .pushNamed(CheckinThanks.routeName);
                                  Get.to(() => QRScreen(
                                        property: bookedProperty,
                                        booking: booking,
                                      ));
                                },
                                isDisabled:
                                    DateTime.now().isAfter(booking.checkOut) ||
                                        (DateTime.now()
                                                .difference(booking.checkIn)
                                                .inHours >
                                            24),
                                icon: Icons.assignment_turned_in_outlined,
                                title: booking.status == 'checkedin'
                                    ? 'Check out'
                                    : 'Check in',
                                color: Colors.green,
                              ),
                              actionIcon(
                                title: 'Contact\n Travely',
                                color: kPrimary,
                                icon: FontAwesomeIcons.comment,
                                onTap: () async {
                                  final users = Provider.of<ChatProvider>(
                                          context,
                                          listen: false)
                                      .contactedUsers;
                                  List<String> room = users.map((e) {
                                    return e.chatRoomId.contains(FirebaseAuth
                                                .instance.currentUser.uid +
                                            '_' +
                                            bookedProperty.ownerId)
                                        ? FirebaseAuth
                                                .instance.currentUser.uid +
                                            '_' +
                                            bookedProperty.ownerId
                                        : bookedProperty.ownerId +
                                            '_' +
                                            FirebaseAuth
                                                .instance.currentUser.uid;
                                  }).toList();

                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(bookedProperty.ownerId)
                                      .get()
                                      .then((value) {
                                    Navigator.of(context).pushNamed(
                                        ChatRoom.routeName,
                                        arguments: {
                                          'user': UserModel(
                                            userId: value['userId'],
                                            fullName: value['fullName'],
                                            isAdmin: value['isAdmin'],
                                            isOnline: value['isOnline'],
                                            lastSeen: value['lastSeen'],
                                            imageUrl: value['profilePic'],
                                          ),
                                          'chatRoomId': room.first,
                                        });
                                  });
                                },
                              ),
                              actionIcon(
                                  color: Colors.red,
                                  isDisabled: booking.status == 'cancelled' ||
                                      DateTime.now().isAfter(booking.checkOut),
                                  title: 'Cancel\nBooking',
                                  icon: Icons.close,
                                  onTap: () => cancelBooking(booking)),
                            ]),
                        Container(
                          color: Theme.of(context).cardColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Booking Details',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              buildDetails(
                                title: 'Travely name',
                                value: bookedProperty.name,
                                icon: Icons.assignment_sharp,
                              ),
                              buildDetails(
                                  title: 'Rooms',
                                  value:
                                      booking.numOfRooms.toString() + ' room',
                                  icon: Icons.chair),
                              buildDetails(
                                title: 'Guests',
                                value: '${booking.numOfGuests} guest',
                                icon: Icons.people,
                              ),
                              buildDetails(
                                  title: 'Amount paid',
                                  value: 'KES ${booking.price}',
                                  icon: Icons.sell),
                            ],
                          ),
                        ),
                        Container(
                          color: Theme.of(context).cardColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Timeline',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                buildDetails(
                                    title: 'Booked On',
                                    value: booking.bookedAt == null
                                        ? DateFormat('dd MMM yyy')
                                            .format(DateTime.now())
                                        : DateFormat('dd MMM yyy')
                                            .format(booking.bookedAt.toDate()),
                                    icon: Icons.access_time_filled),
                                buildDetails(
                                    title: 'Check In',
                                    icon: Icons.calendar_today,
                                    value: DateFormat('dd MMM yyy')
                                        .format(booking.checkIn)),
                                buildDetails(
                                    title: 'Check Out',
                                    icon: Icons.calendar_today,
                                    value: DateFormat('dd MMM yyy')
                                        .format(booking.checkOut)),
                              ]),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Divider(),
                        Row(children: [
                          buildDetails(
                              title: 'City',
                              value: bookedProperty.location.town,
                              icon: Icons.location_city),
                          SizedBox(
                            width: 20,
                          ),
                          buildDetails(
                              title: 'Country',
                              icon: Icons.location_on,
                              value: bookedProperty.location.country),
                        ]),
                        SizedBox(
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    height: 45,
                    child: RaisedButton(
                      onPressed: !DateTime.now().isAfter(booking.checkOut)
                          ? () {
                              DateTime.now()
                                          .difference(booking.checkOut)
                                          .inHours <
                                      24
                                  ? {
                                      Provider.of<BookingProvider>(context,
                                              listen: false)
                                          .updateTrail(bookedProperty),
                                      Get.to(
                                          () => BookingMapTrail(bookedProperty))
                                    }
                                  : waitForTime(context);
                            }
                          : null,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: kPrimary,
                      child: DateTime.now().isAfter(booking.checkOut)
                          ? Text(
                              'Trail Expired',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )
                          : Text('Start Trail',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  void cancelBooking(BookingModel booking) {
    final bookedProperty = Provider.of<BookingProvider>(context).bookedProperty;
    DateTime.now().difference(booking.checkOut).inHours < 24
        ? showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text(
                    'CANCEL WARNING',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                      'Do you wish to cancel this booking? You will have to rebook again. Refunds will be transacted before 42 hours'),
                  actions: [
                    TextButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Provider.of<BookingProvider>(context, listen: false)
                            .cancelBooking(
                                bookingId: booking.bookingId,
                                ownerId: bookedProperty.ownerId,
                                bookerId:
                                    FirebaseAuth.instance.currentUser.uid);
                        booking.status = 'cancelled';

                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ))
        : cancelUnavailable(context);
  }
}

void waitForTime(BuildContext context) {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Text(
              'TRAIL NOT READY',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
                'You can only start the live trail to your travely location 24 hours to your check in time'),
            actions: [
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
}

void cancelUnavailable(BuildContext context) {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Text(
              'CANCELLATION INCOMPLETE',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
                'You can only cancel a travely booking 24 hours atleast 24 hours to your check in time. Try contacting the owner for specialized queries'),
            actions: [
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
}

Widget actionIcon(
    {Function onTap,
    IconData icon,
    String title,
    Color color,
    bool isDisabled = false}) {
  return GestureDetector(
    onTap: isDisabled ? null : onTap,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: isDisabled ? Colors.grey : color, shape: BoxShape.circle),
          child: Icon(icon, size: 22, color: Colors.white),
        ),
        SizedBox(
          height: 2.5,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 12),
        )
      ],
    ),
  );
}

Widget buildDetails({String title, String value, IconData icon}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon ?? Icons.calendar_today_outlined,
          size: 16,
          color: Colors.grey,
        ),
        SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
            SizedBox(height: 2.5),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    ),
  );
}
