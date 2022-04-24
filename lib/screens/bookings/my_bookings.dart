import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/helpers/country_helpers.dart';
import 'package:roomy/models/booking_model.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/models/user_model.dart';
import 'package:roomy/providers/booking_provider.dart';
import 'package:roomy/providers/chat_provider.dart';
import 'package:roomy/providers/dark_mode_provider.dart';
import 'package:roomy/screens/bookings/bookings_list.dart';
import 'package:roomy/screens/bookings/my_booking_details.dart';
import 'package:roomy/screens/chat/chat_room.dart';

class MyBookingsScreen extends StatefulWidget {
  static const routeName = '/my-bookings-screen';
  @override
  _MyBookingsScreenState createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  int _selectedIndex = 0;
  String changeOption() {
    if (_selectedIndex == 1) {
      return 'pending';
    } else if (_selectedIndex == 2) {
      return 'approved';
    } else if (_selectedIndex == 3) {
      return 'cancelled';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHome = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: kPrimary,
                  image: DecorationImage(
                    image: AssetImage('assets/images/world_map.png'),
                    fit: BoxFit.cover,
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            isHome != null
                                ? Navigator.of(context).pop()
                                : ZoomDrawer.of(context).open();
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'My Reservations',
                          style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 0;
                                });
                              },
                              child: SelectedReservation(
                                title: 'ALL',
                                isSelected: _selectedIndex == 0,
                              )),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 1;
                                });
                              },
                              child: SelectedReservation(
                                title: 'PENDING',
                                isSelected: _selectedIndex == 1,
                              )),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 2;
                                });
                              },
                              child: SelectedReservation(
                                title: 'APPROVED',
                                isSelected: _selectedIndex == 2,
                              )),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 3;
                                });
                              },
                              child: SelectedReservation(
                                title: 'CANCELLED',
                                isSelected: _selectedIndex == 3,
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              )),
          BookingsList(
            option: changeOption(),
          ),
        ],
      ),
    );
  }
}

class SelectedReservation extends StatefulWidget {
  final String title;
  final bool isSelected;
  SelectedReservation({
    this.title,
    this.isSelected,
  });

  @override
  _SelectedReservationState createState() => _SelectedReservationState();
}

class _SelectedReservationState extends State<SelectedReservation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: widget.isSelected ? Colors.white : Colors.grey[400],
              fontWeight: widget.isSelected ? FontWeight.w900 : FontWeight.bold,
            ),
          ),
          SizedBox(height: 3),
          if (widget.isSelected)
            Icon(
              Icons.circle,
              size: 8,
              color: Colors.amber,
            )
        ],
      ),
    );
  }
}

class BookingWidget extends StatelessWidget {
  final BookingModel booking;
  final PropertyModel property;
  BookingWidget({this.booking, this.property});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () async {
        Provider.of<BookingProvider>(context, listen: false)
            .getBookedProperty(property.id);
        Navigator.of(context).pushNamed(
          MyBookingDetails.routeName,
          arguments: booking,
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(15, 25, 15, 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('dd').format(booking.checkIn),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    dayFormat(
                                      dayFormat(DateFormat('dd')
                                          .format(booking.checkIn)),
                                    ),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                              Text(
                                '${DateFormat('MMMM').format(booking.checkIn)}, ${DateFormat('EEEE').format(booking.checkIn)},',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_sharp,
                                    size: 12,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    DateFormat('dd MMM yyyy')
                                        .format(booking.checkIn),
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  Text(' - '),
                                  Text(
                                    DateFormat('dd MMM yyyy')
                                        .format(booking.checkOut),
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${booking.activities.length} activities',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                '${booking.services == null ? 0 : booking.services.length} services',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Provider.of<BookingProvider>(context,
                                        listen: false)
                                    .getBookedProperty(property.id);
                                Navigator.of(context).pushNamed(
                                  MyBookingDetails.routeName,
                                  arguments: booking,
                                );
                              },
                              child: Text(
                                'REVIEW',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kPrimary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            GestureDetector(
                              onTap: () async {
                                final users = Provider.of<ChatProvider>(context,
                                        listen: false)
                                    .contactedUsers;
                                List<String> room = users.map((e) {
                                  return e.chatRoomId.contains(FirebaseAuth
                                              .instance.currentUser.uid +
                                          '_' +
                                          property.ownerId)
                                      ? FirebaseAuth.instance.currentUser.uid +
                                          '_' +
                                          property.ownerId
                                      : property.ownerId +
                                          '_' +
                                          FirebaseAuth.instance.currentUser.uid;
                                }).toList();

                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(property.ownerId)
                                    .get()
                                    .then((value) {
                                  Navigator.of(context).pushNamed(
                                      ChatRoom.routeName,
                                      arguments: {
                                        'user': UserModel(
                                          userId: value['userId'],
                                          fullName: value['fullName'],
                                          imageUrl: value['profilePic'],
                                        ),
                                        'chatRoomId': room.first,
                                      });
                                });
                              },
                              child: Text(
                                'CONTACT',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: kPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
                Positioned(
                    right: 0,
                    top: 25,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        color: Theme.of(context).shadowColor,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: kPrimary,
                            ),
                          ),
                          Text(
                            '${booking.price}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: kPrimary,
                            ),
                          ),
                        ],
                      ),
                    )),
                Positioned(
                  top: -15,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.telegramPlane,
                              color: kPrimary,
                            ),
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).cardColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
