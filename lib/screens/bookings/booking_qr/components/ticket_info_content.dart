import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:roomy/models/booking_model.dart';
import 'package:roomy/models/property_model.dart';

class TicketInfo extends StatelessWidget {
  const TicketInfo({Key key, this.booking, this.property}) : super(key: key);
  final BookingModel booking;
  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(
        left: 140,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          const Text(
            'YOUR QR CODE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            height: size.width * 0.6,
            width: size.width * 0.6,
            child: QrImage(
              data: booking.bookingId +
                  '_' +
                  property.id +
                  '_' +
                  property.ownerId,
              version: QrVersions.auto,
              size: size.width * 0.6,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Show at reception',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Travely',
                style: TextStyle(color: Colors.white70),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    property.name.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Learn more',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Facilitated by',
                  style: TextStyle(color: Colors.white70),
                ),
                const Text(
                  'THE TRAVELY APP',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Generally, all travely hosts should scan to verify that the authenticity of the booking. While the step is optional since booking is secure, this should provide an extra layer of security and automation.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
