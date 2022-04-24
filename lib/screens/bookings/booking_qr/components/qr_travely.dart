import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:roomy/models/booking_model.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/providers/auth_provider.dart';

class QRTravelyInfo extends StatelessWidget {
  const QRTravelyInfo({Key key, this.booking, this.property}) : super(key: key);
  final BookingModel booking;
  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WayColumn(
                cityShort: (property.location.country[0] +
                        property.location.country[1])
                    .toUpperCase(),
                cityFullName: property.location.country,
                crossAalignment: CrossAxisAlignment.start,
                date: DateFormat('EEE, MMM dd yyyy').format(booking.checkIn),
                time: 'Check in',
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 70,
                    width: 70,
                    color: Colors.white,
                  ),
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.orange.withOpacity(0.4),
                  ),
                  //const SizedBox(height: 5),
                ],
              ),
              WayColumn(
                cityShort:
                    (property.location.town[0] + property.location.town[1])
                        .toUpperCase(),
                cityFullName: property.location.town,
                crossAalignment: CrossAxisAlignment.end,
                date: DateFormat('EEE, MMM dd yyyy').format(booking.checkOut),
                time: 'Check out',
              ),
            ],
          ),
        ),
        const SizedBox(height: 60),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booked by',
              style: TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              user.fullName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rooms',
                      style: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      booking.numOfRooms.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Guests',
                      style: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      booking.numOfGuests.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
        const SizedBox(height: 30),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activities',
                      style: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      //  booking.activities.isEmpty?'None': booking.activities.first.name,
                      'None',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking At',
                      style: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm, MMM dd yyy').format(
                          booking.bookedAt != null
                              ? booking.bookedAt.toDate()
                              : Timestamp.now().toDate()),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
        const SizedBox(height: 30),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount',
              style: TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'KES ' + booking.price.toStringAsFixed(2),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const Spacer(),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orange.withOpacity(0.4),
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          title: Text(
            property.propertyOwner,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            'Enjoy your stay with us. Have any queries? Feel free to contact with us through the app.',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class WayColumn extends StatelessWidget {
  final String cityShort;
  final String cityFullName;
  final String date;
  final String time;
  final CrossAxisAlignment crossAalignment;

  const WayColumn({
    Key key,
    @required this.cityShort,
    @required this.cityFullName,
    @required this.crossAalignment,
    @required this.date,
    @required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        const CircleAvatar(
          backgroundColor: Colors.white,
          radius: 5,
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: crossAalignment,
          children: [
            Text(
              cityShort,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            Text(
              cityFullName,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              date,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
            Text(
              time,
              style: const TextStyle(
                color: Colors.white54,
                // fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
            ),
          ],
        )
      ],
    );
  }
}
