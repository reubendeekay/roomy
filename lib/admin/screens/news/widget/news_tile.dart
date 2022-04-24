import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:roomy/admin/screens/news/news_details_screen.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/news_model.dart';
import 'package:roomy/widgets/cached_image.dart';

class NewsTile extends StatelessWidget {
  final NewsModel news;
  NewsTile(this.news);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => NewsDetailsScreen(news, isTile: true));
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            SizedBox(
                height: 90,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: cachedImage(
                    'https://wttc.org/DesktopModules/MVC/NewsArticleList/images/-1_20210112090511_Consumer%20Survey%20Finds%2070%20Percent%20of%20Travelers%20Plan%20to%20Holiday%20in%202021.jpg',
                    fit: BoxFit.cover,
                  ),
                )),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The Consumer Survey Finds 70 Percent of Travelers Plan to Holiday in 2021',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'World',
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
                        '1m ago',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
