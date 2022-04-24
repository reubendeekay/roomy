import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:roomy/models/booking_model.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/models/service_model.dart';
import 'package:roomy/models/user_model.dart';

class AdminBookingProvider with ChangeNotifier {
  List<BookingTileModel> _bookings = [];
  List<BookingTileModel> get bookings => [..._bookings];
  BookingTileModel _booking;
  BookingTileModel get booking => _booking;

  Future<void> getBooking({String propertyId}) async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final results = propertyId != null
        ? await FirebaseFirestore.instance
            .collection('admin')
            .doc('bookings')
            .collection(propertyId)
            .get()
        : await FirebaseFirestore.instance
            .collection('admin')
            .doc('bookings')
            .collection(uid)
            .get();
    List<BookingTileModel> bookingsResults = [];
    await Future.forEach(results.docs, (element) async {
      UserModel user;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(element['userId'])
          .get()
          .then((doc) {
        user = UserModel(
            fullName: doc['fullName'],
            email: doc['email'],
            imageUrl: doc['profilePic'],
            phoneNumber: doc['phoneNumber'],
            userId: doc['userId']);
      });

      BookingModel bookingModel = BookingModel(
        checkIn: element['checkIn'].toDate(),
        checkOut: element['checkOut'].toDate(),
        numOfDays: element['numOfDays'],
        numOfGuests: element['numOfGuests'],
        bookingId: element.id,
        bookedAt: element['bookedAt'],
        checkedInAt: element['checkedInAt'] != null
            ? element['checkedInAt'].toDate()
            : null,
        numOfRooms: element['numOfRooms'],
        price: double.parse(element['amount'].toString()),
        status: element['status'],
        services: element['services']
            .map<ServiceModel>(
              (s) => ServiceModel(
                category: s['category'],
                price: double.parse(s['price'].toString()),
                name: s['name'],
                status: s['status'],
                imageUrl: s['imageUrl'],
              ),
            )
            .toList(),
      );

      PropertyModel property = PropertyModel(
          name: element['propertyName'], ownerId: element['ownerId']);

      bookingsResults.add(BookingTileModel(
          booking: bookingModel, property: property, user: user));
    });

    _bookings = bookingsResults;
    notifyListeners();
  }

  Future<void> confirmBooking(
      String propertyId, String bookingId, String ownerId) async {
    final results = await FirebaseFirestore.instance
        .collection('admin')
        .doc('bookings')
        .collection(ownerId)
        .doc(bookingId)
        .get();

    UserModel user;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(results['userId'])
        .get()
        .then((doc) {
      user = UserModel(
          fullName: doc['fullName'],
          email: doc['email'],
          imageUrl: doc['profilePic'],
          phoneNumber: doc['phoneNumber'],
          userId: doc['userId']);
    });

    BookingModel bookingModel = BookingModel(
      checkIn: results['checkIn'].toDate(),
      checkOut: results['checkOut'].toDate(),
      numOfDays: results['numOfDays'],
      numOfGuests: results['numOfGuests'],
      bookingId: results.id,
      bookedAt: results['bookedAt'],
      checkedInAt: results['checkedInAt'] != null
          ? results['checkedInAt'].toDate()
          : null,
      numOfRooms: results['numOfRooms'],
      price: double.parse(results['amount'].toString()),
      status: results['status'],
      services: results['services']
          .map<ServiceModel>(
            (s) => ServiceModel(
              category: s['category'],
              price: double.parse(s['price'].toString()),
              name: s['name'],
              status: s['status'],
              imageUrl: s['imageUrl'],
            ),
          )
          .toList(),
    );
    final propResults = await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .doc(propertyId)
        .get();

    await FirebaseFirestore.instance
        .collection('admin')
        .doc('bookings')
        .collection(ownerId)
        .doc(bookingId)
        .update({
      'checkedInAt': Timestamp.now(),
      'isConfirmed': true,
      'status': 'checkedin',
    });
    await FirebaseFirestore.instance
        .collection('userData')
        .doc('bookings')
        .collection(results['userId'])
        .doc(bookingId)
        .update({
      'checkedInAt': Timestamp.now(),
      'isConfirmed': true,
      'status': 'checkedin',
    });

    PropertyModel property = PropertyModel(
        name: propResults['name'], ownerId: propResults['ownerId']);

    _booking =
        BookingTileModel(booking: bookingModel, property: property, user: user);

    notifyListeners();
  }
}
