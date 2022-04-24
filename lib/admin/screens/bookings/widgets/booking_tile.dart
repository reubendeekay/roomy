import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:roomy/admin/constants.dart';
import 'package:roomy/admin/screens/bookings/booking_details_screen.dart';
import 'package:roomy/helpers/get_helpers.dart';
import 'package:roomy/models/booking_model.dart';

class BookingTile extends StatelessWidget {
  final BookingTileModel booking;

  const BookingTile({Key key, this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => BookingDetailsScreen(booking));
      },
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
        margin: const EdgeInsets.only(bottom: 1),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage:
                  CachedNetworkImageProvider(booking.user.imageUrl),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.user.fullName,
                    style: TextStyle(fontSize: 12, color: kPrimary),
                  ),
                  const SizedBox(
                    height: 2.5,
                  ),
                  Row(
                    children: [
                      Text(
                        booking.property.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: const Icon(
                          Icons.circle,
                          size: 5,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '\$ ${booking.booking.price}',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: kPrimary),
                      ),
                      const Spacer(),
                      Text(
                        getCreatedAt(booking.booking.bookedAt),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${booking.booking.numOfGuests} Guests',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  Text(
                    DateFormat('HH:mm').format(booking.booking.checkIn) +
                        ' - ' +
                        DateFormat('HH:mm').format(booking.booking.checkOut),
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
