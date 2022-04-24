import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:roomy/models/notifications_model.dart';
import 'package:roomy/screens/notifications/widgets/notifications_tile.dart';

class NotificationsScreen extends StatelessWidget {
  static const routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('userData')
          .doc('notifications')
          .collection(FirebaseAuth.instance.currentUser.uid)
          .orderBy('createdAt')
          .snapshots(),
      builder: (ctx, snapshots) {
        if (!snapshots.hasData) {
          return Container();
        } else {
          List<DocumentSnapshot> docs = snapshots.data.docs;
          return docs.length > 0
              ? ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemBuilder: (ctx, i) => NotificationTile(NotificationsModel(
                    title: docs[i]['title'],
                    tag: docs[i]['tag'],
                    body: docs[i]['body'],
                    createdAt: docs[i]['createdAt'],
                    imageUrl: docs[i]['imageUrl'],
                  )),
                  itemCount: docs.length,
                )
              : Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You have no notifications',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'when you receive a notification about bookings,app functionality, news and updates, it will appear here.This does not include chat notifications',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
        }
      },
    );
  }
}
