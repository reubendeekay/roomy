import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsModel {
  final String tag;
  final String senderId;
  final String title;
  final String body;
  final Timestamp createdAt;
  final String imageUrl;

  NotificationsModel(
      {this.tag,
      this.senderId,
      this.title,
      this.body,
      this.createdAt,
      this.imageUrl});
}
