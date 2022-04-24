import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/providers/booking_provider.dart';

class CustomStepper extends StatefulWidget {
  CustomStepper({
    @required this.lowerLimit,
    @required this.upperLimit,
    @required this.stepValue,
    @required this.iconSize,
    @required this.value,
    this.price,
    this.type,
  });
  final double price;
  final int lowerLimit;
  final int upperLimit;
  final String type;
  final int stepValue;
  final double iconSize;
  int value;

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  @override
  Widget build(BuildContext context) {
    final booking = Provider.of<BookingProvider>(context, listen: false);
    final bookingData = Provider.of<BookingProvider>(
      context,
    ).booking;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoundedIconButton(
          icon: Icons.remove,
          iconSize: widget.iconSize,
          color: Colors.grey,
          onPress: () {
            setState(() {
              widget.value = widget.value == widget.lowerLimit
                  ? widget.lowerLimit
                  : widget.value -= widget.stepValue;
            });
            if (widget.type == 'room') {
              booking.updateRooms(widget.value, widget.price);
            } else {
              booking.updateGuests(widget.value, widget.price);
            }
          },
        ),
        Container(
          width: widget.iconSize,
          child: Text(
            widget.type == 'room'
                ? '${bookingData.numOfRooms == null ? 0 : bookingData.numOfRooms}'
                : '${bookingData.numOfGuests == null ? 0 : bookingData.numOfGuests}',
            style: TextStyle(
              fontSize: widget.iconSize * 0.8,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        RoundedIconButton(
          icon: Icons.add,
          color: kPrimary,
          iconSize: widget.iconSize,
          onPress: () {
            setState(() {
              widget.value = widget.value == widget.upperLimit
                  ? widget.upperLimit
                  : widget.value += widget.stepValue;
            });
            if (widget.type == 'room') {
              booking.updateRooms(widget.value, widget.price);
            } else {
              booking.updateGuests(widget.value, widget.price);
            }
          },
        ),
      ],
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  RoundedIconButton(
      {@required this.icon,
      @required this.onPress,
      @required this.iconSize,
      @required this.color});

  final IconData icon;
  final Function onPress;
  final double iconSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tightFor(width: iconSize, height: iconSize),
      // elevation: 6.0,
      onPressed: onPress,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(iconSize * 0.2)),
      fillColor: color.withOpacity(0.1),
      child: Icon(
        icon,
        color: color,
        size: iconSize * 0.8,
      ),
    );
  }
}
