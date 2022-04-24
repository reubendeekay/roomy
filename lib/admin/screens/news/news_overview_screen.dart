import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roomy/admin/helpers/chat_tile_shimmer.dart';
import 'package:roomy/admin/screens/news/widget/news_tile.dart';
import 'package:roomy/admin/screens/news/widget/pinned_news.dart';

import 'package:roomy/models/news_model.dart';

class NewsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  'News Feed',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // PinnedNews(),
          FeaturedNews(),
          OtherNews()
        ],
      ),
    );
  }
}

class FeaturedNews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('admin')
          .doc('info')
          .collection('news')
          .where('isPinned', isEqualTo: true)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: List.generate(10, (index) => ChatTileShimmer()),
          );
        }
        List<DocumentSnapshot> docs = snapshot.data.docs;
        return ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: docs
              .map((e) => PinnedNews(NewsModel(
                  category: e['category'],
                  content: e['content'],
                  coverImage: e['coverImage'],
                  createdAt: e['createdAt'],
                  id: e.id,
                  postedBy: e['postedBy'],
                  posterId: e['posterId'],
                  posterProfile: e['posterProfile'],
                  title: e['title'],
                  views: e['views'])))
              .toList(),
        );
      },
    );
  }
}

class OtherNews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('admin')
          .doc('info')
          .collection('news')
          .snapshots(),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: List.generate(10, (index) => ChatTileShimmer()),
          );
        }
        List<DocumentSnapshot> docs = snapshot.data.docs;
        return ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: docs
              .map((e) => NewsTile(NewsModel(
                  category: e['category'],
                  content: e['content'],
                  coverImage: e['coverImage'],
                  createdAt: e['createdAt'],
                  id: e.id,
                  postedBy: e['postedBy'],
                  posterId: e['posterId'],
                  posterProfile: e['posterProfile'],
                  title: e['title'],
                  views: e['views'])))
              .toList(),
        );
      },
    );
  }
}
