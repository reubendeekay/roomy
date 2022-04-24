import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/notifications_model.dart';
import 'package:roomy/screens/bookings/my_bookings.dart';

class NotificationTile extends StatelessWidget {
  final NotificationsModel notification;
  NotificationTile(this.notification);
  Future getDestination(BuildContext context) {
    if (notification.tag.toLowerCase() == 'booking') {
      return Navigator.of(context)
          .pushNamed(MyBookingsScreen.routeName, arguments: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => getDestination(context),
      child: Container(
        width: size.width,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  CachedNetworkImageProvider(notification.imageUrl),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '${notification.tag} ',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: kPrimary),
                        ),
                        TextSpan(
                          text: notification.title,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )
                      ]),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      notification.body,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
