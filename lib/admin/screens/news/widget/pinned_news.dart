import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:roomy/admin/screens/news/news_details_screen.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/helpers/get_helpers.dart';
import 'package:roomy/models/news_model.dart';
import 'package:roomy/widgets/cached_image.dart';

class PinnedNews extends StatelessWidget {
  final NewsModel news;
  final bool isTile;

  const PinnedNews(this.news, {Key key, this.isTile = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isTile
          ? () {
              Get.to(() => NewsDetailsScreen(news));
            }
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: cachedImage(
                  news.coverImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        news.category,
                        style: TextStyle(color: kPrimary, fontSize: 12),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.circle,
                        size: 6,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5),
                      Text(
                        getCreatedAt(news.createdAt),
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
