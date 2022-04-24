import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:roomy/models/booking_model.dart';
import 'package:roomy/models/notifications_model.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/models/service_model.dart';

class BookingProvider with ChangeNotifier {
  BookingModel _booking;
  BookingModel get booking => _booking;
  PropertyModel _bookedProperty;
  PropertyModel _trailProperty;
  PropertyModel get trailProperty => _trailProperty;
  PropertyModel get bookedProperty => _bookedProperty;

  void intialize(double price) {
    _booking = BookingModel(services: [], activities: []);
    updatePrice(price);
  }

  void updatePrice(double price) {
    _booking = BookingModel(
      price: price,
      numOfRooms: _booking.numOfRooms,
      numOfGuests: booking.numOfGuests,
      numOfDays: _booking.numOfDays,
      services: _booking.services,
      activities: _booking.activities,
      checkIn: _booking.checkIn,
      checkOut: _booking.checkOut,
    );
    notifyListeners();
  }

  void updateRooms(int rooms, double price) {
    final previous = booking.numOfRooms * price;
    _booking = BookingModel(
      numOfRooms: rooms,
      numOfGuests: booking.numOfGuests,
      price: (booking.price - previous) + (rooms * price),
      numOfDays: _booking.numOfDays,
      services: _booking.services,
      activities: _booking.activities,
      checkIn: _booking.checkIn,
      checkOut: _booking.checkOut,
    );
    notifyListeners();
  }

  void updateGuests(int guests, double price) {
    _booking = BookingModel(
      numOfGuests: guests,
      numOfRooms: _booking.numOfRooms,
      price: _booking.price,
      numOfDays: _booking.numOfDays,
      activities: _booking.activities,
      services: _booking.services,
      checkIn: _booking.checkIn,
      checkOut: _booking.checkOut,
    );
    notifyListeners();
  }

  void updateDays({
    int days,
    DateTime checkIn,
    DateTime checkOut,
    double price,
  }) {
    _booking = BookingModel(
      price: days > 1
          ? (booking.numOfDays * -price) + (_booking.price + (days * price))
          : _booking.price,
      numOfDays: days,
      numOfRooms: _booking.numOfRooms,
      numOfGuests: booking.numOfGuests,
      services: _booking.services,
      checkIn: checkIn,
      checkOut: checkOut,
      activities: _booking.activities,
    );
    notifyListeners();
  }

  void addService(
    ServiceModel service,
  ) {
    if (_booking.services.contains(service)) {
      _booking.services.remove(service);
    } else {
      _booking.services.add(service);
    }
    _booking.services.forEach((element) {
      print(element);
    });
    _booking = BookingModel(
      price: _booking.price,
      numOfRooms: _booking.numOfRooms,
      numOfGuests: booking.numOfGuests,
      numOfDays: _booking.numOfDays,
      services: _booking.services,
      checkIn: _booking.checkIn,
      checkOut: _booking.checkOut,
      activities: _booking.activities,
    );
    notifyListeners();
  }

  Future<void> addActivity(
    PropertyModel activity,
  ) async {
    double price = 0.0;

    if (_booking.activities.contains(activity)) {
      _booking.activities.remove(activity);
      price = _booking.price - double.parse(activity.price);
    } else {
      _booking.activities.add(activity);
      price = _booking.price + double.parse(activity.price);
    }

    _booking.activities.forEach((element) {
      print(element);
    });
    _booking = BookingModel(
      price: price,
      numOfRooms: _booking.numOfRooms,
      numOfGuests: booking.numOfGuests,
      numOfDays: _booking.numOfDays,
      services: _booking.services,
      checkIn: _booking.checkIn,
      checkOut: _booking.checkOut,
      activities: _booking.activities,
    );

    notifyListeners();
  }

  Future<void> completeBooking(
      PropertyModel property, NotificationsModel notification) async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final bookingId = FirebaseFirestore.instance
        .collection('userData')
        .doc('bookings')
        .collection(uid)
        .doc()
        .id;
    try {
      await FirebaseFirestore.instance
          .collection('userData')
          .doc('bookings')
          .collection(uid)
          .doc(bookingId)
          .set({
        'propertyId': property.id,
        'propertyName': property.name,
        'propertyOwner': property.propertyOwner,
        'services': _booking.services
            .map((e) => {
                  'name': e.name,
                  'category': e.category,
                  'price': e.price,
                  'imageUrl': e.imageUrl,
                  'status': e.status,
                })
            .toList(),
        'activities': _booking.activities
            .map((e) => {
                  'name': e.name,
                  'id': property.id,
                  'price': e.price,
                })
            .toList(),
        'amount': _booking.price,
        'numOfRooms': _booking.numOfRooms,
        'numOfGuests': _booking.numOfGuests,
        'numOfDays': _booking.numOfDays,
        'checkIn': _booking.checkIn,
        'isCancelled': true,
        'isConfirmed': false,
        'checkedInAt': null,
        'checkOut': _booking.checkOut,
        'ownerId': property.ownerId,
        'status': 'pending',
        'bookedAt': Timestamp.now(),
      });
      await FirebaseFirestore.instance
          .collection('userData')
          .doc('notifications')
          .collection(uid)
          .doc()
          .set({
        'tag': notification.tag,
        'body': notification.body,
        'createdAt': Timestamp.now(),
        'title': notification.title,
        'imageUrl': notification.imageUrl,
        'senderId': notification.senderId,
      });

      //////////////TO THE OWNER
      ///
      ///
      await FirebaseFirestore.instance
          .collection('propertyData')
          .doc('propertyListing')
          .collection('properties')
          .doc(property.id)
          .update({
        'bookings': FieldValue.increment(1),
      });
      await FirebaseFirestore.instance
          .collection('admin')
          .doc('bookings')
          .collection(property.ownerId)
          .doc(bookingId)
          .set({
        'userId': uid,
        'propertyId': property.id,
        'propertyName': property.name,
        'propertyOwner': property.propertyOwner,
        'services': _booking.services
            .map((e) => {
                  'name': e.name,
                  'category': e.category,
                  'price': e.price,
                  'imageUrl': e.imageUrl,
                  'status': e.status,
                })
            .toList(),
        'amount': double.parse(property.price),
        'numOfRooms': _booking.numOfRooms,
        'numOfGuests': _booking.numOfGuests,
        'numOfDays': _booking.numOfDays,
        'checkIn': _booking.checkIn,
        'isCancelled': true,
        'isConfirmed': false,
        'checkedInAt': null,
        'checkOut': _booking.checkOut,
        'ownerId': property.ownerId,
        'status': 'pending',
        'bookedAt': Timestamp.now(),
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(property.ownerId)
          .collection('hosting')
          .doc('account')
          .update({
        'totalEarnings': FieldValue.increment(
            double.parse(property.price) * booking.numOfDays +
                double.parse(property.price) * booking.numOfRooms),
        'balance': FieldValue.increment(
            double.parse(property.price) * booking.numOfDays +
                double.parse(property.price) * booking.numOfRooms),
      });
      await Future.forEach(booking.activities, (element) async {
        final serviceResult = await FirebaseFirestore.instance
            .collection('propertyData')
            .doc('propertyListing')
            .collection('properties')
            .doc(element.id)
            .get();

        PropertyModel service = PropertyModel(
          id: serviceResult.id,
          name: serviceResult['name'],
          price: serviceResult['price'],
          ownerId: serviceResult['ownerId'],
          propertyOwner: serviceResult['ownerName'],
          propertyCategory: serviceResult['propertyCategory'],
        );

        await FirebaseFirestore.instance
            .collection('propertyData')
            .doc('propertyListing')
            .collection('properties')
            .doc(element.id)
            .update({
          'bookings': FieldValue.increment(1),
        });
        await FirebaseFirestore.instance
            .collection('admin')
            .doc('bookings')
            .collection(service.ownerId)
            .doc(bookingId)
            .set({
          'userId': uid,
          'propertyId': service.id,
          'propertyName': service.name,
          'propertyOwner': service.propertyOwner,
          'services': [],
          'amount': double.parse(service.price),
          'numOfRooms': _booking.numOfRooms,
          'numOfGuests': _booking.numOfGuests,
          'numOfDays': _booking.numOfDays,
          'checkIn': _booking.checkIn,
          'isCancelled': true,
          'isConfirmed': false,
          'checkedInAt': null,
          'checkOut': _booking.checkOut,
          'ownerId': service.ownerId,
          'status': 'pending',
          'bookedAt': Timestamp.now(),
        });
        await FirebaseFirestore.instance
            .collection('users')
            .doc(property.ownerId)
            .collection('hosting')
            .doc('account')
            .update({
          'balance': FieldValue.increment(double.parse(service.price)),
          'totalEarnings': FieldValue.increment(double.parse(service.price)),
        });
      });
    } catch (e) {
      throw (e);
    }
    print('Booking completed');

    // _booking = BookingModel();

    notifyListeners();
  }

  Future<void> getBookedProperty(String id) async {
    final e = await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .doc(id)
        .get();
    _bookedProperty = PropertyModel(
      id: e.id,
      name: e['name'],
      coverImage: e['coverImage'],
      views: e['views'],
      ammenities: e['ammenities'],
      price: e['price'],
      location: PropertyLocation(
        country: e['location']['country'],
        latitude: e['location']['latitude'],
        longitude: e['location']['longitude'],
        town: e['location']['town'],
      ),
      rates: e['rates'],
      images: e['images'],
      rating: double.parse(e['rating'].toString()),
      reviews: e['reviews'],
      ownerId: e['ownerId'],
      propertyOwner: e['ownerName'],
      propertyCategory: e['propertyCategory'],
      description: e['description'],
      offers: e['offers'],
    );

    notifyListeners();
  }

  Future<void> cancelBooking(
      {String bookingId, String bookerId, String ownerId}) async {
    await FirebaseFirestore.instance
        .collection('userData')
        .doc('bookings')
        .collection(bookerId)
        .doc(bookingId)
        .update({
      'status': 'cancelled',
    });

    await FirebaseFirestore.instance
        .collection('admin')
        .doc('bookings')
        .collection(ownerId)
        .doc(bookingId)
        .update({
      'status': 'cancelled',
    });
    notifyListeners();
  }

  Future<void> checkIn(String id) async {
    final uid = FirebaseAuth.instance.currentUser.uid;

    await FirebaseFirestore.instance
        .collection('userData')
        .doc('bookings')
        .collection(uid)
        .doc(id)
        .update({
      'status': 'checkedin',
      'checkedInAt': Timestamp.now(),
    });
    notifyListeners();
  }

  Future<void> checkOut(String id) async {
    final uid = FirebaseAuth.instance.currentUser.uid;

    await FirebaseFirestore.instance
        .collection('userData')
        .doc('bookings')
        .collection(uid)
        .doc(id)
        .update({
      'status': 'checkedout',
      'checkedOutAt': Timestamp.now(),
    });
    notifyListeners();
  }

  Future<void> updateTrail(PropertyModel property) {
    _trailProperty = property;
    notifyListeners();
  }
}
