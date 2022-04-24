import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/booking_model.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/screens/bookings/booking_qr/components/filter_on_bacground.dart';
import 'package:roomy/screens/bookings/booking_qr/components/qr_travely.dart';
import 'package:roomy/screens/bookings/booking_qr/components/ticket_info_content.dart';

import 'components/clipper.dart';

class QRScreen extends StatefulWidget {
  QRScreen({Key key, @required this.booking, @required this.property})
      : super(key: key);
  final BookingModel booking;
  final PropertyModel property;

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kPrimary,
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(widget.property.coverImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const FilterOnBackground(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: QRTravelyInfo(
                booking: widget.booking,
                property: widget.property,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _isCollapsed ? -120 : size.width - 65,
            child: Stack(
              children: [
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: size.height,
                    width: size.width + 90,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Colors.orange,
                        Colors.orange,
                      ],
                    )),
                    child: TicketInfo(
                      booking: widget.booking,
                      property: widget.property,
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  top: size.height * 0.65 + 37,
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _isCollapsed = !_isCollapsed;
                    }),
                    child: Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: kPrimary,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.blueGrey,
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/qr-code.png',
                          color: Colors.white,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 7,
                  top: size.height * 0.65 + 37,
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _isCollapsed = !_isCollapsed;
                    }),
                    child: Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.orange.withOpacity(0.4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange,
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          color: Colors.white,
                          height: 26,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
