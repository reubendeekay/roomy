import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  final String id;
  final bool isPinned;
  final String title;
  final String postedBy;
  final String posterId;
  final String content;
  final String category;
  final String posterProfile;
  final String coverImage;
  final Timestamp createdAt;
  List<String> images = [];
  final int views;

  NewsModel(
      {this.id,
      this.isPinned,
      this.title,
      this.postedBy,
      this.posterId,
      this.content,
      this.createdAt,
      this.category,
      this.posterProfile,
      this.coverImage,
      this.views});
}
