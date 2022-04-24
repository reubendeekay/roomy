import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/providers/booking_provider.dart';
import 'package:roomy/providers/search_provider.dart';

import 'package:roomy/screens/booking/widgets/service_tile.dart';
import 'package:roomy/widgets/calendar_popup.dart';
import 'package:roomy/widgets/custom_stepper.dart';

class HotelBooking extends StatefulWidget {
  final PropertyModel property;
  HotelBooking({this.property});
  @override
  _HotelBookingState createState() => _HotelBookingState();
}

class _HotelBookingState extends State<HotelBooking> {
  int numOfGuests = 0;
  int numOfRooms = 0;

  DateTime _startDate;

  DateTime _endDate;

  @override
  Widget build(BuildContext context) {
    final booking = Provider.of<BookingProvider>(context).booking;
    final bookingAction = Provider.of<BookingProvider>(context, listen: false);
    Provider.of<SearchProvider>(context, listen: false)
        .getNearbyServices(widget.property);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            'ACCOMODATION',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.symmetric(vertical: 10),
            color: Theme.of(context).primaryColor,
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rooms',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Number of rooms',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                        ]),
                    SizedBox(
                      width: 10,
                    ),
                    CustomStepper(
                        lowerLimit: 1,
                        type: 'room',
                        upperLimit: 100,
                        price: double.parse(widget.property.price),
                        stepValue: 1,
                        iconSize: 26,
                        value: booking.numOfRooms)
                  ],
                ),
              ),
              Container(
                // margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Guests',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Number of guests',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                        ]),
                    SizedBox(
                      width: 10,
                    ),
                    CustomStepper(
                        lowerLimit: 1,
                        upperLimit: 100,
                        type: 'guests',
                        stepValue: 1,
                        price: double.parse(widget.property.price),
                        iconSize: 26,
                        value: booking.numOfGuests)
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              )
            ]),
          ),
          GestureDetector(
            onTap: () => showDialog(
                context: context,
                builder: (ctx) => CalendarPopupView(
                      barrierDismissible: true,
                      minimumDate: DateTime.now(),
                      maximumDate: DateTime.utc(2100, 12, 12),
                      initialEndDate: DateTime.now(),
                      initialStartDate: DateTime.now(),
                      onApplyClick: (DateTime startData, DateTime endData) {
                        setState(() {
                          _startDate = startData;
                          _endDate = endData;
                          print(endData.difference(startData).inDays + 1);
                        });
                        bookingAction.updateDays(
                            days: _endDate.difference(_startDate).inDays + 1,
                            price: double.parse(widget.property.price),
                            checkIn: _startDate,
                            checkOut: _endDate);
                      },
                      onCancelClick: () {},
                    )),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              width: double.infinity,
              padding: EdgeInsets.all(10),
              color: Theme.of(context).primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Check in',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 20,
                    child: _startDate != null
                        ? Text(
                            DateFormat('dd MMMM').format(_startDate),
                            style: TextStyle(fontSize: 15),
                          )
                        : Text('Choose check in date'),
                  ),
                  Divider(
                    height: 12,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Check out',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 20,
                    child: _startDate != null
                        ? Text(
                            DateFormat('dd MMMM').format(_endDate),
                            style: TextStyle(fontSize: 15),
                          )
                        : Text('Choose check out date'),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'ROOMS/SERVICES',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              '*Long press an item to view full details',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          if (widget.property.services != null)
            Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(10),
                color: Theme.of(context).primaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    widget.property.ammenities.length,
                    (index) =>
                        SelectableServiceTile(widget.property.services[index]),
                  ),
                )),
          const SizedBox(
            height: 5,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            const Text(
              'Price: ',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'KES ${booking.price}',
              style: const TextStyle(
                  fontSize: 16, color: kPrimary, fontWeight: FontWeight.w600),
            ),
          ]),
        ],
      ),
    );
  }
}
