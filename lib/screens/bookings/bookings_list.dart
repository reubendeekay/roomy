import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomy/models/booking_model.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/models/service_model.dart';
import 'package:roomy/screens/bookings/my_bookings.dart';

class BookingsList extends StatelessWidget {
  final String option;
  BookingsList({this.option});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: option == null
          ? FirebaseFirestore.instance
              .collection('userData')
              .doc('bookings')
              .collection(FirebaseAuth.instance.currentUser.uid)
              .orderBy('bookedAt')
              .snapshots()
          : FirebaseFirestore.instance
              .collection('userData')
              .doc('bookings')
              .collection(FirebaseAuth.instance.currentUser.uid)
              .where('status', isEqualTo: option.toLowerCase())
              .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> docs = snapshot.data.docs;
          docs.sort((a, b) => b['bookedAt'].compareTo(a['bookedAt']));
          return Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              shrinkWrap: true,
              itemBuilder: (ctx, i) => BookingWidget(
                booking: BookingModel(
                    checkIn: docs[i]['checkIn'].toDate(),
                    checkOut: docs[i]['checkOut'].toDate(),
                    numOfDays: docs[i]['numOfDays'],
                    numOfGuests: docs[i]['numOfGuests'],
                    bookingId: docs[i].id,
                    checkedInAt: docs[i]['checkedInAt'] != null
                        ? docs[i]['checkedInAt'].toDate()
                        : null,
                    numOfRooms: docs[i]['numOfRooms'],
                    price: double.parse(docs[i]['amount'].toString()),
                    status: docs[i]['status'],
                    services: docs[i]['services']
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
                    activities: docs[i]['activities']
                        .map<PropertyModel>(
                          (e) => PropertyModel(
                            name: e['name'],
                            id: e['id'],
                            price: e['price'],
                          ),
                        )
                        .toList()),
                property: PropertyModel(
                  name: docs[i]['propertyName'],
                  propertyOwner: docs[i]['propertyOwner'],
                  ownerId: docs[i]['ownerId'],
                  id: docs[i]['propertyId'],
                ),
              ),
              itemCount: docs.length,
            ),
          );
        }
        return Center(child: Container());
      },
    );
  }
}
