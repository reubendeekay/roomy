import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/models/service_model.dart';
import 'package:roomy/models/user_model.dart';

class BookingModel {
  final String bookingId;

  final DateTime checkedInAt;

  double price;
  int numOfRooms;
  int numOfGuests;
  List<PropertyModel> activities = [];
  List<ServiceModel> services = [];
  int numOfDays;
  final DateTime checkIn;
  final DateTime checkOut;
  String status;
  final Timestamp bookedAt;
  final String userId;

  BookingModel({
    this.price = 0,
    this.numOfRooms = 1,
    this.numOfGuests = 1,
    this.services,
    this.userId,
    this.numOfDays = 0,
    this.checkIn,
    this.checkOut,
    this.bookedAt,
    this.status,
    this.activities,
    this.bookingId,
    this.checkedInAt,
  });
}

class BookingTileModel {
  final BookingModel booking;
  final PropertyModel property;
  final UserModel user;

  BookingTileModel({this.booking, this.property, this.user});
}
